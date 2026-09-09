"""Project one complete interpretation-qualified audit; --apply explicitly writes.

No model role runs here. Read-only validation is the default. Global gate
validation remains open after applying a row; this is not terminal authority.
"""
from pathlib import Path
import argparse
import copy
import hashlib
import json
import os
import subprocess
import sys
import tempfile

import qualified_row_support_dim_roots_v2 as q


def immutable(path, payload):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        q.require(path.read_bytes() == payload, 'immutable artifact collision: ' + str(path))
    else:
        with path.open('xb') as handle:
            handle.write(payload)
            handle.flush()
            os.fsync(handle.fileno())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gate-checker', required=True, type=Path)
    parser.add_argument('--gate', required=True, type=Path)
    parser.add_argument('--request', required=True, type=Path)
    parser.add_argument('--request-sha256', required=True)
    parser.add_argument('--rebind', action='store_true')
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    q.require(os.name != 'nt', 'use native Python plus the existing POSIX launcher; never native Git')
    q.require(q.sha(args.request) == args.request_sha256, 'reviewed request hash mismatch')
    request_path = args.request.resolve()
    q.require(request_path.is_relative_to(q.ROOT), 'request must be repository evidence')
    gate_path = args.gate.resolve()
    q.require(gate_path == q.ROOT/'gates/leveque-finite-volume/chapter-01.json', 'wrong gate')
    checker = q.load_module('qualified_gate', args.gate_checker.resolve(), q.CHECKER_SHA)
    original = gate_path.read_bytes()
    gate = json.loads(original)
    q.validate_preserved_rows(gate)
    context = checker.current_context(gate_path, 1)
    v = q.validate_request(request_path, complete=True)
    request, task, decision = v['request'], v['task'], v['decision']
    q.require(request['current_bindings'] == context['bindings'], 'request is not bound to current source fingerprint/context')
    matches = [row for row in gate['rows'] if row['id'] == request['row']]
    q.require(len(matches) == 1, 'expected exactly one selected row')
    row = matches[0]
    if args.rebind:
        q.require(row['status'] == request['status'] and row.get('faithfulness_task') == request['task']['path']
                  and row.get('lean_declarations') == [task['target']['declaration']], 'rebind must preserve same closed status/task/target')
        q.validate_bound_row(row)
    else:
        q.require(row['status'] in ('READY', 'IN_PROGRESS'), 'selected row is not an open proof/reuse candidate')
    target = q.repo_path(task['target']['path'])
    baseline = context['bindings']['lean_git_head']
    subprocess.run(['git', 'merge-base', '--is-ancestor', baseline, 'HEAD'], cwd=q.ROOT, check=True)
    indexed = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', ':' + task['target']['path']], cwd=q.ROOT)
    q.require(indexed == target.read_bytes(), 'target must have exact staged bytes before binding')
    if request['status'] == 'REUSED':
        reused = subprocess.check_output(['git', 'show', baseline + ':' + task['target']['path']], cwd=q.ROOT)
        q.require(reused == target.read_bytes(), 'REUSED requires exact unchanged integrated-baseline target bytes')
    contract = q.contract_for(v)
    if args.rebind:
        q.require(row['contract_hash'] == checker.canonical_sha256(contract), 'rebind changes qualified contract')
    for key in ('next_foundation', 'next_action', 'current_target', 'open_reason', 'strengthening_evidence',
                'applicability_audit', 'nonvacuity_witness', 'adjudication_status', 'adjudication_audit',
                'reuse_source', 'reuse_audit', 'interpretation_refinement_ref', *q.SOURCE_CONTEXT_KEYS):
        row.pop(key, None)
    row.update({'status': request['status'], 'lean_declarations': [task['target']['declaration']],
                'contract_hash': checker.canonical_sha256(contract),
                'blind_pass': 'PASS', 'direct_pass': 'PASS', 'round_trip_pass': 'PASS',
                'classification': v['classification'], **dict(zip(q.DIRECTIONS, v['pair'])),
                'faithfulness_task': request['task']['path'], 'faithfulness_decision': request['decision']['path'],
                'qualified_binding_request': q.reference(request_path),
                'coordinator_selected_interpretation': request['interpretation_packet'],
                'native_evidence': request['native'], **v['fields'],
                'adjudication_required': decision.get('adjudicated') is True})
    if v['refinement'] is not None:
        row['interpretation_refinement_ref'] = v['refinement']['reference']
    if v['source_context'] is not None:
        row.update(v['source_context']['refs'])
    if request['status'] == 'REUSED':
        row.update(reuse_source=f"Integrated baseline {baseline}; exact unchanged {task['target']['path']}::{task['target']['declaration']}",
                   reuse_audit=f"Complete validated {task['task_id']}; decision SHA-256 {request['decision']['sha256']}")
    if decision.get('adjudicated') is True:
        row['adjudication_status'] = 'resolved'
        row['adjudication_audit'] = (
            f"Independent complete sealed adjudication accepts {v['classification']} with implication pair {v['pair']}, "
            f"qualified by coordinator selection SHA-256 {q.SELECTION_SHA}. Decision SHA-256 {request['decision']['sha256']}. "
            + (f"Strengthening evidence SHA-256 {request['strengthening_evidence']['sha256']}. " if v['fields'] else '')
            + 'Original role outcomes remain unchanged; ' + decision['rationale'])
    q.validate_bound_row(row)
    q.require(not checker.faithfulness_defects(row, row['status'], row['id']), 'released row faithfulness requirements fail')
    binding = checker.row_artifact_bindings(row, 1, context)
    binding_dir = q.bound(request['task']).parent/'gate-bindings'/checker.canonical_sha256(binding)
    artifacts = []
    common = {key: row[key] for key in ('contract_hash', 'classification', *q.DIRECTIONS)}
    roles = {'blind': 'blind_translation', 'direct': 'direct_judge', 'round-trip': 'roundtrip_judge'}
    for check, (path_field, hash_field) in checker.ROW_ARTIFACT_REFS.items():
        if check == 'source-contract':
            payload = {key: row[key] for key in ('contract_hash', 'source_label', 'printed_page', 'pdf_page')}
            payload['contract'] = contract
        else:
            role = v['output']/'agent_outputs'/(roles[check] + '.json')
            payload = {**common, 'decision': 'PASS', 'analysis':
                f"Original independent {roles[check]} SHA-256 {q.sha(role)}; complete sealed decision SHA-256 {request['decision']['sha256']}; "
                f"exact request/native evidence SHA-256 {args.request_sha256}. Projects accepted {v['classification']} {v['pair']} only under "
                f"coordinator-selected interpretation SHA-256 {request['interpretation_packet']['sha256']}. "
                'Original role classifications are preserved, including any resolved adjudication. ' + decision['rationale']}
        artifact = {'schema_version': 1, 'check': check, 'bindings': binding, 'exit_code': 0, 'payload': payload,
                    'procedure': 'Project the complete-phase validated source account, independent role and sealed decision. '
                                 'Keep coordinator selection separate from printed source and literal user replies; generate no semantic judgment.'}
        path = binding_dir/('gate-' + check + '.json')
        payload_bytes = q.encode(artifact)
        row[path_field], row[hash_field] = path.relative_to(gate_path.parent).as_posix(), hashlib.sha256(payload_bytes).hexdigest()
        artifacts.append((path, payload_bytes))
    old_rows = {r['id']: r for r in json.loads(original)['rows']}
    q.require(all(r == old_rows[r['id']] for r in gate['rows'] if r['id'] != row['id']), 'unselected row mutation')
    q.validate_preserved_rows(gate)
    closed = [r for r in gate['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES]
    semantic = gate['verification_loops']['semantic_equivalence']
    semantic['rows_requiring_check'] = len(closed)
    for counter, field in [('blind_recorded', 'blind_pass'), ('direct_recorded', 'direct_pass'), ('round_trip_recorded', 'round_trip_pass')]:
        semantic[counter] = sum(r.get(field) == 'PASS' for r in closed)
    semantic['unresolved_adjudications'] = sum(r.get('adjudication_required', False) and r.get('adjudication_status') != 'resolved' for r in closed)
    for name in gate['verification_evidence']:
        gate['verification_evidence'][name] = {'command': '', 'artifact': '', 'artifact_sha256': '', 'exit_code': None, 'count': 0}
    gate['bindings'] = copy.deepcopy(context['bindings'])
    if args.apply:
        q.require(q.sha(request_path) == args.request_sha256, 'request changed during validation')
        q.require(gate_path.read_bytes() == original, 'gate changed during validation')
        q.require(checker.current_context(gate_path, 1)['bindings'] == context['bindings'], 'current fingerprint changed')
        q.validate_request(request_path)  # Rehash exact proof/audit inputs at the write boundary.
        q.require(all(q.sha(path) == digest for path, digest in v['audit_hashes'].items()), 'audit changed after validation')
        for path, payload in artifacts:
            immutable(path, payload)
        defects = checker.row_artifact_defects(row, 1, context, gate_path.parent, set(), location=row['id'])
        q.require(not defects, '; '.join(defects))
        immutable(binding_dir/('prior-gate-' + hashlib.sha256(original).hexdigest() + '.json'), original)
        fd, temporary = tempfile.mkstemp(prefix=gate_path.name + '.qualified-', dir=gate_path.parent)
        try:
            with os.fdopen(fd, 'wb') as handle:
                handle.write(q.encode(gate)); handle.flush(); os.fsync(handle.fileno())
            q.require(gate_path.read_bytes() == original, 'gate changed immediately before replace')
            q.require(checker.current_context(gate_path, 1)['bindings'] == context['bindings'], 'fingerprint changed before replace')
            q.require(gate_path.read_bytes() == original, 'gate changed during final context check')
            q.require(q.sha(request_path) == args.request_sha256, 'request changed before replace')
            q.require(all(q.sha(path) == digest for path, digest in v['audit_hashes'].items()), 'audit changed before replace')
            os.replace(temporary, gate_path)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)
    print(json.dumps({'mode': 'ROW_BOUND_GLOBAL_CHECKS_OPEN' if args.apply else 'VALIDATED_PREVIEW_NO_WRITES',
                      'row': row['id'], 'status': row['status'], 'classification': v['classification'],
                      'implications': v['pair'], 'request_sha256': args.request_sha256,
                      'unchanged_other_rows': len(gate['rows']) - 1, 'terminal_acceptance': False}))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
