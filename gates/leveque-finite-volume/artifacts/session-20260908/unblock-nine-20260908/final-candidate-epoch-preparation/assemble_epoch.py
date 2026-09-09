"""Assemble only an evidence-complete candidate epoch; never validates/adopts it.

Input references may be external runtime paths, each explicitly SHA256-bound.
Read-only Git checks require the POSIX workflow launcher. No fabricated defaults.
The previously reviewed two-lane converter owns asset/provenance reconstruction.
"""
from pathlib import Path
import argparse
import importlib.util
import json
import os
import re
import sys
from candidate_checks import CHECKS, bound, digest, git, need, load_inputs
from capture_checks import commands


def read_ref(ref):
    need(set(ref) == {'path', 'sha256'}, 'Invalid external evidence reference')
    p = Path(ref['path'])
    need(p.is_absolute() and not p.is_symlink(), 'Explicit absolute evidence path required')
    raw = p.read_bytes()
    need(digest(raw) == ref['sha256'], 'Changed evidence: ' + str(p))
    return raw


def data_ref(ref):
    return json.loads(read_ref(ref))


def schema_checker(ref):
    read_ref(ref)
    s = importlib.util.spec_from_file_location('existing_asset_schema_checks', Path(ref['path']))
    module = importlib.util.module_from_spec(s)
    need(s.loader is not None, 'Missing reviewed structural checker')
    s.loader.exec_module(module)
    return module.schema_check


def expected_plan(topology, assets):
    """Same field comparison as released reconciliation.plan, including its limits."""
    roles = {x['id']: x['role'] for x in topology['instances']}
    groups = {}
    for asset in assets:
        groups.setdefault(asset['concept_id'], []).append(asset)
    result = []
    for concept, group in sorted(groups.items()):
        formal = [a for a in group if roles[a['lane_id']] == 'formalization']
        reorg = [a for a in group if roles[a['lane_id']] == 'reorganization']
        if len({a.get('producer') for a in reorg if a.get('producer')}) > 1:
            kind = 'producer-conflict'
        elif formal and not reorg:
            kind = 'formalization-only'
        elif reorg and not formal:
            kind = 'reorganization-only'
        elif any(len({a.get(k) for a in group}) > 1 for k in ('source_hash', 'type_hash', 'policy_hash')):
            kind = 'semantic-conflict'
        elif len({(a.get('module'), a.get('declaration')) for a in group}) > 1:
            kind = 'commuting-move'
        elif len({a.get('proof_hash') for a in group}) > 1:
            kind = 'body-only'
        else:
            kind = 'identical'
        result.append({'concept_id': concept, 'classification': kind,
            'asset_ids': [a['asset_id'] for a in group],
            'requires_adjudication': kind in ('semantic-conflict', 'producer-conflict')})
    return result


def checked_reviews(root, topology, bundle, review):
    assets = bundle['epoch_fields']['assets']
    plan = expected_plan(topology, assets)
    need(review['status'] == 'reviewed-for-candidate-assembly' and review['bundle_sha256'], 'Missing actual review')
    need(review['plan'] == plan, 'Collision review does not cover actual structural plan')
    # The released planner omits content identity for non-declarations. Never use
    # an identical result to silently unify different gate/audit/row/module bytes.
    by_id = {a['asset_id']: a for a in assets}
    required = set()
    for group in plan:
        if group['classification'] not in ('identical', 'formalization-only', 'reorganization-only'):
            required.add(group['concept_id'])
        members = [by_id[k] for k in group['asset_ids']]
        if any(a['kind'] != 'declaration' for a in members) and len({a['content_sha256'] for a in members}) > 1:
            required.add(group['concept_id'])
        if len({a.get('producer') for a in members if a['kind'] == 'declaration'}) > 1:
            required.add(group['concept_id'])
    decisions = {x['concept_id']: x for x in review['concept_decisions']}
    need(len(decisions) == len(review['concept_decisions']) and set(decisions) == required,
         'Every changed/conflicting concept needs one explicit review; no invented extra decisions')
    transports = {x['id']: x for x in review['transports']}
    collisions = {x['id']: x for x in review['collisions']}
    need(len(transports) == len(review['transports']) and len(collisions) == len(review['collisions']), 'Duplicate review ID')
    used_collisions, used_transports = set(), set()
    for concept, decision in decisions.items():
        need(decision['resolution'].strip() and decision['evidence'], 'Missing concrete reviewed resolution')
        for ref in decision['evidence']:
            bound(root, ref, committed=True)
        collision = collisions[decision['collision_id']]
        need(collision['status'] == 'resolved' and collision['resolution'] == decision['resolution'], 'Unresolved collision')
        used_collisions.add(collision['id'])
        cls = next(x['classification'] for x in plan if x['concept_id'] == concept)
        members = [by_id[k] for x in plan if x['concept_id'] == concept for k in x['asset_ids']]
        changed_producer = len({x.get('producer') for x in members if x['kind'] == 'declaration'}) > 1
        if cls in ('semantic-conflict', 'producer-conflict', 'body-only', 'commuting-move') or changed_producer:
            need(decision['transport_ids'], 'Changed declaration concept requires explicit transport')
        for tid in decision['transport_ids']:
            need(tid in transports, 'Missing transport')
            used_transports.add(tid)
    # Baseline-only transports (e.g. original Eq1.3) are explicit, never inferred.
    for entry in review['additional_transport_evidence']:
        need(entry['transport_id'] in transports and entry['evidence'], 'Missing baseline transport evidence')
        for ref in entry['evidence']:
            bound(root, ref, committed=True)
        used_transports.add(entry['transport_id'])
    need(used_collisions == set(collisions) and used_transports == set(transports), 'Unlinked review entries')
    for t in transports.values():
        old, new = t['old_hashes'], t['new_hashes']
        stable = all(old[k] == new[k] for k in ('source', 'type', 'policy', 'producer'))
        c, f = t['change_class'], t['faithfulness']
        if c == 'move':
            need(stable and old['proof'] == new['proof'] and f == 'reuse', 'Invalid pure-move transport')
        elif c == 'body-only':
            need(stable and old['proof'] != new['proof'] and f == 'replay', 'Invalid body-only transport')
        else:
            need(c in ('signature', 'policy', 'producer') and f in ('full-reaudit', 'reopen'), 'Semantic change needs reaudit/reopen')
            k = 'type' if c == 'signature' else c
            need(old[k] != new[k], 'Transport class has no corresponding changed hash')
    return list(collisions.values()), list(transports.values())


def assemble(spec):
    need(os.name != 'nt', 'Use the reviewed POSIX workflow launcher')
    topology = data_ref(spec['topology']); request = data_ref(spec['request']); status = data_ref(spec['status'])
    bundle = data_ref(spec['bundle']); schema = data_ref(spec['epoch_schema'])
    need(bundle['artifact_kind'] == 'two-lane-candidate-asset-preparation', 'Wrong converter output')
    for k in ('topology', 'request', 'status', 'epoch_schema'):
        need(bundle['input_sha256'][k] == spec[k]['sha256'], 'Bundle input mismatch: ' + k)
    need(status['current_state'] == 'CANDIDATE' and status['result_kind'] == 'candidate', 'Not actual CANDIDATE')
    need(status['request_id'] == request['request_id'] and status['request_sha256'] == spec['request']['sha256'], 'Request/status mismatch')
    need(request['topology']['sha256'] == spec['topology']['sha256'], 'Request topology mismatch')
    need((request['task'], request['remote_write_policy'], request['admission_backend']) == ('prepare', 'forbid', 'none'),
         'Only local prepare/forbid/none is supported; no admission receipt fabricated')
    candidate = bundle['epoch_fields']['candidate']; recorded = status['candidate']
    need(candidate['commit'] == recorded['commit'] and candidate['tree'] == recorded['tree'], 'Candidate mismatch')
    root = Path(recorded['scratch_repository'])
    need(git(root, 'rev-parse', 'HEAD').decode().strip() == candidate['commit'], 'Wrong candidate checkout')
    need(git(root, 'rev-parse', 'HEAD^{tree}').decode().strip() == candidate['tree'], 'Candidate tree mismatch')
    replay, gate, _ = load_inputs(root, spec['replay_inputs'], committed=True)
    review = data_ref(spec['collision_transport_review'])
    need(review['bundle_sha256'] == spec['bundle']['sha256'], 'Review has wrong bundle')
    collisions, transports = checked_reviews(root, topology, bundle, review)
    collected = data_ref(spec['check_receipts'])
    need(collected['candidate_commit'] == candidate['commit'] and collected['candidate_tree'] == candidate['tree'], 'Receipt candidate mismatch')
    expected = commands(spec['replay_inputs']['path'], spec['replay_inputs']['sha256'], candidate['tree'])
    validations = {}
    for pair in collected['checks']:
        receipt = data_ref(pair['receipt']); output = read_ref(pair['output'])
        name = receipt['check']
        need(name in CHECKS and name not in validations, 'Wrong/duplicate validation name')
        need(receipt['kind'] == 'actual-candidate-check' and type(receipt['exit_code']) is int and receipt['exit_code'] == 0,
             'Missing actual candidate command success')
        need(receipt['input_commit'] == candidate['commit'] and receipt['candidate_tree'] == candidate['tree'], 'Receipt not candidate-bound')
        need(receipt['command'] == expected[name] and receipt['output_sha256'] == digest(output), 'Command/output mismatch')
        parsed = json.loads(output)
        need(parsed['check'] == name and parsed['result'] == 'PASS'
             and parsed['gate_sha256'] == replay['gate']['sha256']
             and parsed['input_manifest_sha256'] == spec['replay_inputs']['sha256'], 'Wrong replay output')
        validations[name] = {'status': 'PASS', 'tree': candidate['tree'], 'command': receipt['command'],
                            'output_sha256': digest(output), 'elapsed_ms': receipt['elapsed_ms']}
    need(set(validations) == set(CHECKS), 'All eight actual receipts required')
    books_packet = data_ref(spec['book_evidence']); books = books_packet['affected_books']
    need(books_packet['candidate_tree'] == candidate['tree'] and books_packet['evidence'], 'Missing candidate book evidence')
    for ref in books_packet['evidence']:
        bound(root, ref, committed=True)
    required_books = {b for campaign in topology['campaigns'] for b in campaign['book_ids']}
    required_books |= {b for t in transports for b in t['affected_books']}
    need({b['book_id'] for b in books} >= required_books and len({b['book_id'] for b in books}) == len(books),
         'Every configured/transport-affected book needs one explicit current verdict or reopening')
    for book in books:
        need(book['tree'] == candidate['tree'], 'Stale book tree')
        if book['status'] == 'pass':
            need(book['stored_verdict'] == book['current_verdict'] == 'PASS' and book['certificate_disposition'] == 'current',
                 'PASS requires a current matching certificate')
            # Current bounded packet can establish Chapter1 only; other books need
            # a separate reviewed current checker, not an inferred PASS.
            need(book['book_id'] == gate['book_id'] and set(book['rows']) == {r['id'] for r in gate['rows']},
                 'Additional book PASS needs a separately extended validator')
        else:
            need(book['status'] == 'reopened' and book['rows'] and book['certificate_disposition'] == 'rejected-stale'
                 and not (book['stored_verdict'] == book['current_verdict'] == 'PASS'), 'Invalid explicit reopening')
    org_packet = data_ref(spec['organization_evidence'])
    need(org_packet['candidate_tree'] == candidate['tree'], 'Stale organization tree')
    organization = json.loads(bound(root, replay['organization_measurement'], committed=True))
    need(org_packet['organization'] == organization, 'Organization differs from replayed exact measurement')
    for r in organization['repository_ratchet']:
        need(r['owner'] and (not set(r['current_items']) - set(r['baseline_items']) or r.get('approved_exception')),
             'Unreviewed ratchet increase')
    epoch = {'schema_version': 2, 'workflow_schema_version': 3, 'epoch_id': spec['epoch_id'],
        'campaign_id': request['campaign_id'], 'status': 'candidate', 'topology_sha256': spec['topology']['sha256'],
        'anchor': topology['shared_anchor'], **bundle['epoch_fields'], 'transports': transports,
        'collisions': collisions, 'affected_books': books, 'organization': organization, 'validations': validations}
    top_schema = {k: v for k, v in schema.items() if k not in ('$schema', '$id', '$defs')}
    schema_checker(spec['schema_checker'])(epoch, top_schema, schema, 'candidate epoch')
    need(not git(root, 'status', '--porcelain', '--untracked-files=all').strip(), 'Candidate dirty after assembly')
    # Recheck all externally supplied bytes against races. No runtime/refs are changed.
    for key in ('topology', 'request', 'status', 'bundle', 'epoch_schema', 'collision_transport_review',
                'check_receipts', 'book_evidence', 'organization_evidence', 'schema_checker'):
        read_ref(spec[key])
    return epoch


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--inputs', type=Path, required=True); p.add_argument('--inputs-sha256', required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args(); need(not a.output.exists(), 'Fresh epoch output path required')
    original = a.inputs.read_bytes(); need(digest(original) == a.inputs_sha256, 'Assembly input hash mismatch')
    inputs = json.loads(original)
    candidate_root = Path(data_ref(inputs['status'])['candidate']['scratch_repository'])
    need(not a.output.resolve().is_relative_to(candidate_root.resolve()), 'Epoch output must be outside candidate checkout')
    epoch = assemble(inputs)
    need(a.inputs.read_bytes() == original, 'Assembly inputs changed')
    with a.output.open('x', encoding='utf-8', newline='\n') as stream:
        stream.write(json.dumps(epoch, indent=2, sort_keys=True) + '\n')
    print('Assembled candidate-status epoch from actual evidence; released validation and PASS checkpoint still pending.')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError, TypeError) as exc:
        raise SystemExit('REFUSED: ' + str(exc))
