"""Measure current organization from actual source and separately pinned reviews.

No gate, all-closed condition, source verdict, native build, or operational epoch
is involved. Outputs are a fresh organization object and a provenance receipt.
Run through POSIX launcher; all Git use is read-only.
"""
from pathlib import Path
import argparse
import importlib.util
import json
import os
import re
import sys
import time
from candidate_checks import TOOLS, bound, decoded, digest, frozen_execution, git, need

KEYS = ('unexpected_changes', 'unclassified_modules', 'mixed_pending_split',
        'duplicate_wrappers', 'placeholder_findings', 'canonical_placement_pending')


def source_path(path):
    return path.endswith('.lean') and (path in ('ComputationalMathematics.lean', 'NumStability.lean')
        or path.startswith(('ComputationalMathematics/', 'NumStability/')))


def measure(root, inputs):
    need(os.name != 'nt', 'Use the reviewed POSIX workflow launcher')
    need(inputs['schema_version'] == 1 and inputs['kind'] == 'organization-measurement-inputs', 'Wrong input kind')
    observed = []
    def read(ref):
        observed.append(ref)
        return decoded(root, ref)
    def pin(ref):
        observed.append(ref)
        return bound(root, ref)
    topology_raw = Path(inputs['topology']['path']).read_bytes()
    need(digest(topology_raw) == inputs['topology']['sha256'], 'Topology bytes changed')
    topology = json.loads(topology_raw)
    campaign = next(x for x in topology['campaigns'] if x['id'] == inputs['campaign_id'])
    owner = campaign['owner']
    need(owner == inputs['ratchet_owner'] and owner, 'Owner must be the actual configured campaign owner')
    review = read(inputs['unit_scope_review'])
    need(review['status'] == 'reviewed-for-organization-measurement' and review['review_evidence'], 'Missing exact unit review')
    need(set(review['unit_scope']) == set(KEYS), 'Unit review must specify all six lists explicitly')
    for key in KEYS:
        need(isinstance(review['unit_scope'][key], list), 'Unmeasured unit scope field: ' + key)
    for ref in review['review_evidence'] + review['source_files']:
        pin(ref)
    need(review['source_files'] and len({r['path'] for r in review['source_files']}) == len(review['source_files']),
         'Need exact unique source files in reviewed unit scope')
    need(re.fullmatch('[0-9a-f]{40}', review['anchor']) is not None, 'Actual source-diff anchor required')
    need(git(root, 'rev-parse', review['anchor'] + '^{commit}').decode().strip() == review['anchor'], 'Missing actual anchor')
    head = git(root, 'rev-parse', 'HEAD').decode().strip()
    # Existing capture receipts may precede the final metadata commit. Their
    # explicit source/tool pins must establish current applicability, not labels.
    for name in ('layout', 'tiers', 'compatibility', 'hygiene'):
        entry = inputs['supporting_executions'][name]
        receipt, _ = frozen_execution(root, entry)
        observed.extend([entry['receipt'], entry['output']])
        need(isinstance(entry['command'], list) and len(entry['command']) == 2
             and entry['command'][1] == TOOLS[name], 'Wrong actual organization command')
        need(entry['applicability_review']['path'] in {x['path'] for x in review['review_evidence']},
             'Receipt applicability needs an explicit source-pinned review')
        applicability = read(entry['applicability_review'])
        need(applicability['status'] == 'reviewed-current-inputs'
             and applicability['receipt_sha256'] == entry['receipt']['sha256']
             and applicability['production_source_tree_sha256'] == review['production_source_tree_sha256']
             and applicability['source_files_sha256'] == digest(json.dumps(review['source_files'],
                 sort_keys=True, separators=(',', ':'), ensure_ascii=True).encode()), 'Stale organization receipt applicability')
    for name in ('layout', 'tiers', 'compatibility', 'hygiene', 'graph_engine', 'project_roots',
                 'layout_policy', 'tier_policy', 'axiom_policy'):
        ref = inputs['tools'][name]
        need(ref['path'] == TOOLS[name], 'Wrong pinned organization tool/policy')
        pin(ref)
    sys.path.insert(0, str(root / 'tools/architecture'))
    module_spec = importlib.util.spec_from_file_location('organization_measurement_layout', root / TOOLS['layout'])
    module = importlib.util.module_from_spec(module_spec)
    need(module_spec.loader is not None, 'Missing current layout implementation')
    module_spec.loader.exec_module(module)
    source, modules = module.scan_sources(root)
    need(source['source_tree_sha256'] == review['production_source_tree_sha256'], 'Unit review is not bound to the current production source tree')
    assignments, unclassified = module.tier_assignments(modules)
    current, duplicate_imports = module.current_debt(modules, assignments, unclassified)
    need(not duplicate_imports, 'Actual duplicate imports exist')
    by_path = {m.path: m for m in modules}
    paths = {r['path'] for r in review['source_files']}
    need(paths <= set(by_path), 'Unit review names an absent production module')
    unit_names = {by_path[p].name for p in paths}
    changed = set(git(root, 'diff', '--name-only', review['anchor'], '--').decode().splitlines())
    changed.update(git(root, 'ls-files', '--others', '--exclude-standard').decode().splitlines())
    changed = {p for p in changed if source_path(p)}
    expected = set(review['reviewed_changed_source_paths'])
    need(len(expected) == len(review['reviewed_changed_source_paths']), 'Duplicate reviewed source path')
    actual = dict(review['unit_scope'])
    actual['unexpected_changes'] = sorted(changed - expected)
    need(not expected - changed, 'Review lists source changes no longer present')
    actual['unclassified_modules'] = sorted(unit_names & set(current['unclassified_modules']))
    actual['mixed_pending_split'] = sorted(unit_names & set(current['mixed_modules']))
    # The existing predicate checks actual proof-placeholder declarations. Its
    # global test-library inclusion is retained, not silently weakened.
    actual['placeholder_findings'] = module.placeholder_failures([by_path[p] for p in sorted(paths)])
    need(actual == review['unit_scope'], 'Current measured lists differ from reviewed unit scope')
    need(all(value == [] for value in actual.values()), 'Current unit scope has an unresolved organization finding')
    baseline = read(inputs['ratchet_baseline'])['legacy']
    exceptions = inputs['approved_exceptions']
    need(set(exceptions) <= set(module.LEGACY_KEYS), 'Unknown ratchet exception category')
    ratchet = []
    for name in module.LEGACY_KEYS:
        before, after = sorted(baseline[name]), sorted(current[name])
        entry = {'category': name, 'owner': owner, 'baseline_items': before, 'current_items': after}
        additions = set(after) - set(before)
        if additions:
            exception = exceptions.get(name)
            need(exception and exception['review_evidence'] and exception['rationale'].strip(), 'Unapproved ratchet increase')
            pin(exception['review_evidence'])
            entry['approved_exception'] = exception['rationale']
        else:
            need(name not in exceptions, 'Unused ratchet exception')
        ratchet.append(entry)
    # A pending-assets category, if needed, must be supplied by separate exact
    # asset inventory evidence; do not confuse module names with occurrence IDs.
    need(not inputs.get('pending_asset_ids'), 'Pending asset IDs need an additive reviewed ratchet record')
    for ref in observed:
        bound(root, ref)
    need(git(root, 'rev-parse', 'HEAD').decode().strip() == head, 'Input HEAD changed')
    need(Path(inputs['topology']['path']).read_bytes() == topology_raw, 'Topology changed')
    final_source, _ = module.scan_sources(root)
    need(final_source['source_tree_sha256'] == source['source_tree_sha256'], 'Production source changed during measurement')
    return {'unit_scope': actual, 'repository_ratchet': ratchet}, {
        'kind': 'actual-current-organization-measurement-not-gate-verdict', 'input_commit': head,
        'source_tree_sha256': source['source_tree_sha256'], 'anchor': review['anchor'],
        'ratchet_owner': owner, 'unit_modules': len(paths), 'actual_changed_source_paths': sorted(changed),
        'observed_files': observed, 'topology': inputs['topology'],
        'manual_source_pinned_lists': ['duplicate_wrappers', 'canonical_placement_pending'],
        'limits': 'Current organization only; no all-closed assertion, source verdict, candidate, epoch or admission.'}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--root', type=Path, required=True); p.add_argument('--inputs', type=Path, required=True)
    p.add_argument('--inputs-sha256', required=True); p.add_argument('--output', type=Path, required=True)
    a = p.parse_args(); need(not a.output.exists(), 'Fresh output directory required')
    raw = a.inputs.read_bytes(); need(digest(raw) == a.inputs_sha256, 'Input manifest changed')
    start = time.monotonic_ns()
    organization, provenance = measure(a.root, json.loads(raw))
    need(a.inputs.read_bytes() == raw, 'Inputs changed during measurement')
    a.output.mkdir(parents=True)
    data = (json.dumps(organization, indent=2, sort_keys=True) + '\n').encode()
    (a.output / 'organization.json').write_bytes(data)
    provenance.update(exit_code=0, elapsed_ms=(time.monotonic_ns() - start) // 1000000,
                      inputs_sha256=a.inputs_sha256, organization_sha256=digest(data))
    (a.output / 'measurement-receipt.json').write_text(json.dumps(provenance, indent=2) + '\n', encoding='utf-8', newline='\n')
    print('Measured actual current organization sets with exact source-pinned reviews; no gate verdict asserted.')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError, TypeError) as exc:
        raise SystemExit('REFUSED: ' + str(exc))
