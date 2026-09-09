"""Assemble current-snapshot draft inputs; statuses deliberately require root review."""
from pathlib import Path
import hashlib
import json
import re

P = Path(__file__).resolve().parent
D = P.parent; S = D.parent; R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
read = lambda p: json.loads(p.read_bytes())
def pin(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p.read_bytes())}
def write(name, value):
    with (P / name).open('x', encoding='utf-8', newline='\n') as stream:
        stream.write(json.dumps(value, indent=2) + '\n')
obs = read(P / 'current-source-observation.json')
unit = read(P / 'unit-source-pins.json')
all_pins = read(P / 'all-production-source-pins.json')['files']
by_path = {x['path']: x for x in all_pins}
paths = {x['path'] for x in unit['files']}
# Verify closure of every added native owner too. Aggregate exposure is a
# separate boundary: importing all of Analysis does not make all its unrelated
# mathematics part of Chapter1's semantic claim.
module_path = {p[:-5].replace('/', '.'): p for p in by_path}
todo = list(paths)
while todo:
    p = todo.pop()
    for name in re.findall(r'^import\s+([A-Za-z0-9_\'.]+)', (R / p).read_text(encoding='utf-8'), re.M):
        dep = module_path.get(name)
        if dep and dep not in paths:
            paths.add(dep); todo.append(dep)
semantic_paths = sorted(paths)
paths.add('ComputationalMathematics/Analysis.lean')
source_files = [by_path[p] for p in sorted(paths)]
for ref in all_pins:
    assert sha((R / ref['path']).read_bytes()) == ref['sha256'], ref['path']
assert set(obs['actual_changed_source_paths']) <= paths
source_files_sha = sha(json.dumps(source_files, sort_keys=True, separators=(',', ':'), ensure_ascii=True).encode())
review_paths = [S / name for name in ('organization-review.md', 'production-organization-review.md',
    'transport-production-organization-review.md', 'interpreted-transport-organization-review.md',
    'general-propagation-discontinuity-organization-review.md', 'one-step-general-organization-review.md',
    'definition-repairs-organization-review.md', 'fv-foundations-organization-review.md',
    'batch8-foundations-organization-review.md', 'batch9-foundations-organization-review.md',
    'batch10-foundations-organization-review.md')]
review_paths += [D / name for name in ('linear-review/REVIEW.md', 'numerics-review/REVIEW.md',
    'material-review/REVIEW.md', 'organization/receipt.json', 'organization-local-replacements/REVIEW.md',
    'organization-local-replacements/receipt.json', 'dimensional-method-production/placement-inventory.json',
    'local-riemann-core-placement.json', 'local-riemann-update-placement.json',
    'local-replacement-fingerprints/declaration-mapping.json', 'local-replacement-fingerprints/final-receipt.json')]
review_paths += [P / name for name in ('REVIEW.md', 'current-source-observation.json', 'all-production-source-pins.json',
    'analysis-only-import-delta.json', 'selected-and-prospective-targets.json')]
review_paths += [S / name for name in ('unblock-nine-final-source-graph-capture-exit.json',
    'unblock-nine-final-source-graph-capture-output.txt', 'architecture-graphs/unblock-nine-final-source.json',
    'architecture-graphs/unblock-nine-final-source.md', 'unblock-nine-local-organization-layout-output.txt')]
review_refs = [pin(p) for p in review_paths]
executions = read(P / 'actual-four-executions.json')['executions']
rationales = {
 'layout': 'The first actual local layout output found the nine missing Analysis descendants; the later layout-02 actual zero-exit output covers 5988 modules and reports no debt. Current graph capture and exact source pins bind the repaired nine-import exposure. Root must approve applicability to this exact snapshot.',
 'tiers': 'The actual local tier receipt covers 5988 modules, 4976 exact rules and 27 prefixes. The nine new reusable owners and three source wrappers match the current tier manifest. Adding only Analysis import lines changes neither the module population nor tier-resolution inputs. Current manifest and all unit owner bytes are pinned.',
 'compatibility': 'The actual compatibility-02 receipt covers 3334 forwarders, 2537 canonical targets and zero production imports of historical paths. The added Analysis imports name only canonical leaves; no old forwarder or public owner was rewritten. Current source pins and the nine-import diff support the scoped applicability assessment.',
 'hygiene': 'The actual successful local hygiene receipt scanned 14905 Lean files with no placeholder or unreviewed axiom declaration. Root reports the subsequent source change was only the Analysis aggregate exposure. The actual input-HEAD versus current Analysis comparison has exactly nine added import lines, no removals, identical non-import lines and no new declarations/proofs. Every inventoried current source/owner byte is pinned; the new eight source wrappers and current twelve replacement modules retain their frozen placement hashes. Import-only additions contain no sorry/admit/axiom/constant declaration and cannot change the existing leaf proof text. This is a root-review-required applicability argument, not a rerun or a newly dated hygiene receipt.'}
for name, entry in executions.items():
    path = P / (name + '-applicability.draft.json')
    write(path.name, {'status': 'root-review-required', 'scope': 'current-snapshot only',
        'receipt_sha256': entry['receipt']['sha256'],
        'production_source_tree_sha256': obs['production_source_tree_sha256'],
        'source_files_sha256': source_files_sha, 'review_rationale': rationales[name],
        'review_evidence': review_refs, 'invalidated_by': 'Any additive Info/DIM source owner or import change after this snapshot.'})
    entry['applicability_review'] = pin(path)
app_refs = [executions[k]['applicability_review'] for k in executions]
keys = ('unexpected_changes', 'unclassified_modules', 'mixed_pending_split',
        'duplicate_wrappers', 'placeholder_findings', 'canonical_placement_pending')
write('unit-scope-review.draft.json', {'status': 'root-review-required', 'scope': 'current-snapshot only',
    'anchor': obs['anchor'], 'production_source_tree_sha256': obs['production_source_tree_sha256'],
    'source_files': source_files, 'review_evidence': review_refs + app_refs,
    'reviewed_changed_source_paths': obs['actual_changed_source_paths'],
    'unit_scope': {k: [] for k in keys},
    'draft_assessment': 'Proposed empty lists are supported by actual scans and the attached scoped manual review; root has not yet adopted this record or run final measurement.',
    'scope_counts': {'semantic_and_dependency_files': len(semantic_paths), 'aggregate_exposure_boundary_files': 1,
        'unit_files': len(source_files), 'production_modules': obs['production_module_count'],
        'actual_changed_source_paths': len(obs['actual_changed_source_paths'])}})
template = read(D / 'final-candidate-epoch-preparation/organization-inputs.template.json')
top = R / '.formalization/library-topology.json'
assert sha(top.read_bytes()) == obs['topology_sha256']
template.update(status='root-review-required', scope='current-snapshot only; not final after next production increment',
    topology={'path': '/c/' + top.as_posix()[3:], 'sha256': sha(top.read_bytes())},
    ratchet_owner=obs['campaign_owner'], unit_scope_review=pin(P / 'unit-scope-review.draft.json'),
    ratchet_baseline=pin(P / 'protected-anchor-layout-exceptions.json'),
    supporting_executions={k: {f: entry[f] for f in ('receipt', 'output', 'command', 'applicability_review')}
                           for k, entry in executions.items()})
write('organization-inputs.draft.json', template)
write('supporting-review-pins.json', {'status': 'current-snapshot-root-review-required', 'files': review_refs,
    'scope_source_files_sha256': source_files_sha})
write('draft-summary.json', {'status': 'root-review-required', 'final_measurement_run': False,
    'production_source_tree_sha256': obs['production_source_tree_sha256'], 'source_files': len(source_files),
    'semantic_dependency_files': len(semantic_paths), 'changed_source_paths': len(obs['actual_changed_source_paths']),
    'ratchet_owner_from_actual_topology': obs['campaign_owner'], 'four_receipts_actual_exit_zero': True,
    'source_changes_during_draft_assembly': [], 'inputs_sha256': sha((P / 'organization-inputs.draft.json').read_bytes())})
print(json.dumps(read(P / 'draft-summary.json'), indent=2))
