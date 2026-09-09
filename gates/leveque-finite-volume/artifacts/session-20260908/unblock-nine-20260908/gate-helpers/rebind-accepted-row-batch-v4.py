"""Refresh only current-worktree bindings for an unchanged 38--41-row acceptance set.

Default: prepare immutable evidence and run complete validation on its proposed
gate. --apply: additionally perform a guarded atomic replacement. No row closes,
no accepted semantic field/native input changes, and no model role runs.
Operational use is POSIX only through the existing prepared launcher.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse
import copy
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import sys
import tempfile

H = Path(__file__).resolve().parent
R = H.parents[5]
G = R / 'gates/leveque-finite-volume/chapter-01.json'
PINNED = {
    'rebind-unchanged-closed-rows.py': '98562c5a0e939fb05aaa8cd45df8a007d8d143787c979b979881387141060221',
    'qualified_row_support_v5.py': 'abc07db16099a1010a213249d5db5a3a0aed5f631f6ec30748819791b3410d25',
    'validate-closed-row-audits-rebind-v4.py': '77467c52b5565872f5d961767653ef1d0c983f3aa51f22890d6da92371c67905',
    'source-context-v5-validator-dependencies.json': '04055047d8b8a1dfd0c3d0ec0829999e83fb6c3b120c07a51d1b424251f03d61',
    'batch-rebind-runtime-pins.json': 'f3f79bcbb30b2ba2865ca2a674a764767e8c23e326717efa21a9dc14f7c792ca',
}

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def load(name, filename):
    path = H / filename
    if sha(path) != PINNED[filename]:
        raise ValueError('Pinned helper changed: ' + filename)
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

old = load('batch_old_rebind', 'rebind-unchanged-closed-rows.py')
q = load('batch_qualified_support_v5', 'qualified_row_support_v5.py')
require, encode, parse, digest = old.require, old.encode, old.parse, old.digest
ARTIFACT_FIELDS = old.ARTIFACT_FIELDS
OPEN_EVIDENCE = {'command': '', 'artifact': '', 'artifact_sha256': '', 'exit_code': None, 'count': 0}

def immutable(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('xb') as handle:
        handle.write(data)
        handle.flush()
        os.fsync(handle.fileno())

def file_ref(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}

def refresh_bindings(before, after):
    require(set(before) == set(after), 'Binding keys changed')
    require({k: v for k, v in before.items() if k != 'lean_worktree_sha256'} ==
            {k: v for k, v in after.items() if k != 'lean_worktree_sha256'},
            'Only the current worktree fingerprint may change; source/profile/baseline pins are fixed')
    require(re.fullmatch(r'[0-9a-f]{64}', after.get('lean_worktree_sha256', '')) is not None,
            'Invalid current worktree fingerprint')

def request_copy(request, bindings):
    require('current_bindings' in request, 'Old request lacks its bound context')
    refresh_bindings(request['current_bindings'], bindings)
    result = copy.deepcopy(request)
    result['current_bindings'] = copy.deepcopy(bindings)
    require({k: v for k, v in request.items() if k != 'current_bindings'} ==
            {k: v for k, v in result.items() if k != 'current_bindings'}, 'Request semantics changed')
    return result

def preserve(before, after, selected, qualified):
    require(set(before) == set(after), 'Top-level schema changed')
    require([r['id'] for r in before['rows']] == [r['id'] for r in after['rows']], 'Inventory/order changed')
    refresh_bindings(before['bindings'], after['bindings'])
    for a, b in zip(before['rows'], after['rows']):
        excluded = old.MUTABLE | ({'qualified_binding_request'} if a['id'] in qualified else set())
        if a['id'] in selected:
            require({k: v for k, v in a.items() if k not in excluded} ==
                    {k: v for k, v in b.items() if k not in excluded}, 'Accepted semantics changed: ' + a['id'])
        else:
            require(a == b, 'Unselected/skipped row changed: ' + a['id'])
    for key in before:
        if key not in ('rows', 'bindings'):
            require(before[key] == after[key], 'Nonbinding top-level value changed: ' + key)

def validation_result(result, candidate_ref, bindings, rows):
    require(result.get('mode') == 'released-complete-validation', 'Inventory is not complete validation')
    require(type(result.get('closed_rows')) is int and result['closed_rows'] == len(rows), 'Closed count differs')
    require(result.get('validated_gate_input') == candidate_ref and result.get('current_bindings') == bindings,
            'Complete validation is not bound to this proposal/current context')
    records = result.get('records')
    require(isinstance(records, list) and len(records) == len(rows), 'Incomplete validation records')
    require(len({r['row'] for r in records}) == len(records) and {r['row'] for r in records} == set(rows),
            'Validation row set differs')
    for record in records:
        row = rows[record['row']]
        require(type(record.get('exit_code')) is int and record['exit_code'] == 0, 'Nonzero complete validator result')
        require(record['declaration'] == row['lean_declarations'][0], 'Validated another declaration')
        for key in ('classification', *q.DIRECTIONS):
            require(record[key] == row[key], 'Complete result changes accepted relation')
        if row.get('qualified_binding_request'):
            for key in ('qualified_binding_request', 'coordinator_selected_interpretation', 'native_evidence'):
                require(record[key] == row[key], 'Qualified validation binding mismatch: ' + key)
            for key in q.SOURCE_CONTEXT_KEYS:
                require((key in record) == (key in row), 'Source-context validation presence mismatch: ' + key)
                if key in row:
                    require(record[key] == row[key], 'Source-context validation binding mismatch: ' + key)
    return records

def tracked_refs(reader, document):
    for reference in old.manifest_references(document):
        reader.bound(reference)

def staged(reader, paths):
    records = []
    for relative in sorted(paths):
        data = reader.read(reader.path(relative))
        indexed = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', ':' + relative], cwd=R)
        require(indexed == data, 'Current source not exactly staged: ' + relative)
        records.append({'path': relative, 'sha256': digest(data)})
    return records

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--input', type=Path, required=True)
    p.add_argument('--input-sha256', required=True)
    p.add_argument('--label', required=True)
    p.add_argument('--apply', action='store_true')
    args = p.parse_args()
    require(os.name != 'nt', 'Use prepared native Python -> POSIX launcher; never native Git')
    require(re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9-]{0,79}', args.label) is not None, 'Invalid fresh label')
    reader = old.Reader(R)
    input_path = args.input.resolve()
    require(input_path.is_relative_to(R), 'Input must be repository evidence')
    raw_input = reader.read(input_path)
    require(digest(raw_input) == args.input_sha256, 'Input SHA mismatch')
    spec = parse(raw_input)
    require(set(spec) == {'schema', 'expected_gate_sha256', 'expected_closed_row_ids', 'current_bindings',
                         'current_native', 'runtime_pins'}, 'Unexpected batch input schema')
    require(type(spec['schema']) is int and spec['schema'] == 1, 'Wrong batch schema')
    for filename, expected in PINNED.items():
        require(digest(reader.read(H / filename)) == expected, 'Helper pin changed: ' + filename)
    deps = parse(reader.read(H / 'source-context-v5-validator-dependencies.json'))
    tracked_refs(reader, deps)
    require(spec['runtime_pins'] == file_ref(H/'batch-rebind-runtime-pins.json'),
            'Runtime pins must be this reviewed frozen installed-validator snapshot')
    _, runtime_raw = reader.bound(spec['runtime_pins'])
    runtime = parse(runtime_raw)
    require(runtime['schema'] == 1 and runtime['scope'] == 'installed sealed validator scripts and schemas',
            'Wrong runtime pin scope')
    paths = {p.relative_to(R).as_posix() for folder in (R/'.faithfulness-audit/scripts', R/'.faithfulness-audit/schemas')
             for p in folder.rglob('*') if p.is_file() and '__pycache__' not in p.parts}
    require(len(runtime['files']) == len({x['path'] for x in runtime['files']}) and
            {x['path'] for x in runtime['files']} == paths, 'Installed validator file set changed')
    tracked_refs(reader, runtime)
    original = reader.read(G)
    require(digest(original) == spec['expected_gate_sha256'], 'Prior gate differs from exact explicit guard')
    gate = parse(original)
    require(gate['chapter_gate'] == 'ACTIVE', 'Only ACTIVE gates may be rebound')
    require(len(gate['verification_evidence']) == 8 and
            all(v == OPEN_EVIDENCE for v in gate['verification_evidence'].values()), 'Global evidence must already be OPEN')
    protected = q.validate_preserved_rows(gate)
    reader.read(H / 'protected-baseline.json')
    baseline_raw = reader.read(H / 'unchanged-closed-row-inputs.json')
    require(digest(baseline_raw) == old.INPUT_SHA, 'Original 32-row payload baseline changed')
    historical_pins = {x['id']: x for x in parse(baseline_raw)['closed_rows']}
    originals = {r['id']: r for r in gate['rows']}
    closed = {k: r for k, r in originals.items() if r['status'] in ('PROVED', 'REUSED')}
    require(not any(r['status'] == 'DISCREPANCY' for r in originals.values()), 'No discrepancy protocol here')
    require(38 <= len(closed) <= 41 and spec['expected_closed_row_ids'] == sorted(closed), 'Wrong explicit closed row set/count')
    historical = {r['id'] for r in protected['closed_rows']}
    qualified = set(closed) - historical
    _, choices = q.choices()
    require(len(historical) == 32 and historical <= set(closed) and qualified <= set(choices), 'Wrong protected/qualified partition')
    require(all(bool(r.get('qualified_binding_request')) == (k in qualified) for k, r in closed.items()),
            'Qualified request partition differs from protected baseline')
    checker = q.gate_checker()
    reader.read(R.parent / deps['external_released_gate_checker']['workspace_relative_path'])
    require(checker.ROW_ARTIFACT_REFS == ARTIFACT_FIELDS, 'Released artifact schema changed')
    context = checker.current_context(G, 1)
    require(context['bindings'] == spec['current_bindings'], 'Explicit current context is stale')
    refresh_bindings(gate['bindings'], context['bindings'])
    native = spec['current_native']
    require(set(native) == {'proof_manifest', 'check', 'receipt', 'output'}, 'Wrong current native schema')
    manifest, native_output = old.native_evidence(reader, {
        'native_manifest': native['proof_manifest'], 'native_check': native['check'],
        'native_receipt': native['receipt'], 'native_output': native['output']})
    require(not re.search(r'\bwarning:', native_output), 'Current native output has warnings')
    source_paths = {item['path'] for item in manifest['files']}
    prior_artifacts, old_requests, accepted_inputs = {}, {}, {}
    for row_id, row in closed.items():
        task_path = reader.path(row['faithfulness_task'])
        task = parse(reader.read(task_path))
        audit_out = reader.path(task['audit_output'])
        audit_manifest = parse(reader.read(audit_out / 'manifest.json'))
        decision = parse(reader.read(reader.path(row['faithfulness_decision'])))
        require(task['target'] == manifest['rows'][row_id], 'Current native target differs from accepted target: ' + row_id)
        require(row['lean_declarations'] == [task['target']['declaration']], 'Accepted declaration changed')
        q.accepted_pair(decision)
        tracked_refs(reader, task)
        tracked_refs(reader, audit_manifest)
        require(not checker.faithfulness_defects(row, row['status'], row_id), 'Accepted row fails released semantics')
        for src in [audit_manifest['target'], *audit_manifest['local_import_sources']]:
            if src['path'].endswith('.lean') and not src['path'].startswith('.lake/'):
                source_paths.add(src['path'])
        if row_id in qualified:
            checked = q.validate_bound_row(row)
            tracked_refs(reader, checked['request'])
            for path in checked['audit_hashes']:
                reader.read(Path(path))
            request_path, raw = reader.bound(row['qualified_binding_request'])
            old_requests[row_id] = parse(raw)
            refresh_bindings(old_requests[row_id]['current_bindings'], context['bindings'])
        accepted_inputs[row_id] = {'task_id': task['task_id'], 'manifest_sha256': sha(audit_out/'manifest.json'),
                                  'decision_sha256': sha(audit_out/'decision.json')}
        old_context = None
        for check, (path_field, hash_field) in ARTIFACT_FIELDS.items():
            path = (G.parent / row[path_field]).resolve()
            require(path.is_relative_to(R), 'Artifact escapes repository')
            raw = reader.read(path)
            require(digest(raw) == row[hash_field], 'Prior artifact hash mismatch')
            if row_id in historical:
                _, baseline_artifact = reader.bound(historical_pins[row_id]['artifacts'][check])
                require(old.payload_span(raw) == old.payload_span(baseline_artifact),
                        'Protected historical payload changed: ' + row_id)
            artifact = parse(raw)
            require(artifact['check'] == check, 'Artifact role changed')
            if old_context is None:
                old_context = {'bindings': {key: artifact['bindings'][key] for key in context['bindings']}}
            prior_artifacts[row_id, check] = (path, raw)
        require(not checker.row_artifact_defects(row, 1, old_context, G.parent, set(), location=row_id),
                'Prior artifacts fail their own recorded context: ' + row_id)
    staged_records = staged(reader, source_paths)
    directory = H.parent / 'accepted-row-rebind-runs' / args.label
    require(not directory.exists(), 'Output label already exists')
    reader.unchanged()
    directory.mkdir(parents=True)
    immutable(directory / 'prior-gate.json', original)
    candidate = copy.deepcopy(gate)
    candidate['bindings'] = copy.deepcopy(context['bindings'])
    rows = {r['id']: r for r in candidate['rows']}
    request_records, artifact_records = [], []
    for row_id in sorted(qualified):
        copied = request_copy(old_requests[row_id], context['bindings'])
        path = directory / 'requests' / (row_id + '.json')
        immutable(path, encode(copied))
        reader.read(path)
        rows[row_id]['qualified_binding_request'] = file_ref(path)
        request_records.append({'row': row_id, 'old': originals[row_id]['qualified_binding_request'],
                                'new': file_ref(path), 'only_changed_field': 'current_bindings'})
        q.validate_bound_row(rows[row_id])
    for row_id in sorted(closed):
        binding = checker.row_artifact_bindings(rows[row_id], 1, context)
        for check, (path_field, hash_field) in ARTIFACT_FIELDS.items():
            previous_path, previous = prior_artifacts[row_id, check]
            procedure = ('Refresh worktree context only; preserve the prior payload byte-for-byte and accepted semantics. '
                'Prior gate SHA256 ' + digest(original) + '; current native receipt SHA256 ' + native['receipt']['sha256']
                + '; batch input SHA256 ' + args.input_sha256 + '. Fresh complete validation of the whole proposed '
                'acceptance set is required before installation and recorded separately; no new semantic judgment. '
                'Original procedure: ' + parse(previous)['procedure'])
            raw = old.rebind_artifact(previous, binding, procedure)
            path = directory / 'artifacts' / row_id / ('gate-' + check + '.json')
            immutable(path, raw)
            reader.read(path)
            rows[row_id][path_field] = path.relative_to(G.parent).as_posix()
            rows[row_id][hash_field] = digest(raw)
            artifact_records.append({'row': row_id, 'role': check, 'previous': file_ref(previous_path),
                'new': file_ref(path), 'payload_span_sha256': digest(old.payload_span(raw))})
    preserve(gate, candidate, set(closed), qualified)
    q.validate_preserved_rows(candidate)
    used = set()
    for row_id in sorted(closed):
        require(not checker.row_artifact_defects(rows[row_id], 1, context, G.parent, used, location=row_id),
                'Proposed artifact fails released checks: ' + row_id)
    candidate_path = directory / 'candidate-gate.json'
    candidate_raw = encode(candidate)
    immutable(candidate_path, candidate_raw)
    reader.read(candidate_path)
    command = [sys.executable, '-B', str(H/'validate-closed-row-audits-rebind-v4.py'), '--validate',
               '--gate-input', str(candidate_path), '--gate-input-sha256', digest(candidate_raw)]
    if len(closed) == 41:
        command.append('--require-all-closed')
    completed = subprocess.run(command, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    validation_path = directory / 'complete-validation-output.json'
    immutable(validation_path, completed.stdout)
    validation_receipt = {'schema': 1, 'command': command, 'exit_code': completed.returncode,
                          'output_sha256': digest(completed.stdout), 'candidate': file_ref(candidate_path)}
    immutable(directory/'complete-validation-receipt.json', encode(validation_receipt))
    require(completed.returncode == 0, 'Fresh complete validation failed; actual output/exit retained, gate unchanged')
    records = validation_result(parse(completed.stdout), file_ref(candidate_path), context['bindings'],
                                {k: rows[k] for k in closed})
    for record in records:
        expected = accepted_inputs[record['row']]
        require(record['task'] == expected['task_id'] and record['manifest_sha256'] == expected['manifest_sha256']
                and record['decision_sha256'] == expected['decision_sha256'], 'Complete result changed accepted audit')
        reader.bound(record['config'])
    reader.read(validation_path)
    reader.read(directory/'complete-validation-receipt.json')
    plan = {'schema': 1, 'source_acceptance': False, 'bindings': context['bindings'], 'current_native': native,
            'prior_gate_sha256': digest(original), 'candidate_gate_sha256': digest(candidate_raw),
            'rows': sorted(closed), 'qualified_request_copies': request_records, 'artifacts': artifact_records,
            'explicitly_staged_sources': staged_records, 'complete_validation': file_ref(directory/'complete-validation-receipt.json')}
    immutable(directory/'plan.json', encode(plan))
    reader.read(directory/'plan.json')
    def boundary():
        require(G.read_bytes() == original, 'Concurrent gate write')
        current_runtime_paths = {p.relative_to(R).as_posix()
            for folder in (R/'.faithfulness-audit/scripts', R/'.faithfulness-audit/schemas')
            for p in folder.rglob('*') if p.is_file() and '__pycache__' not in p.parts}
        require(current_runtime_paths == paths, 'Installed validator file set changed during preparation')
        old.staged_sources_equal(reader, staged_records)
        for row_id in qualified:
            q.validate_bound_row(rows[row_id])
        require(checker.current_context(G, 1)['bindings'] == context['bindings'], 'Current context changed')
        reader.unchanged()
        require(G.read_bytes() == original, 'Concurrent gate write during final guards')
    boundary()
    if args.apply:
        fd, temporary = tempfile.mkstemp(prefix=G.name+'.batch-rebind-', dir=G.parent)
        try:
            with os.fdopen(fd, 'wb') as handle:
                handle.write(candidate_raw); handle.flush(); os.fsync(handle.fileno())
            boundary()
            os.replace(temporary, G)
            require(G.read_bytes() == candidate_raw, 'Installed bytes differ from validated proposal')
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)
    else:
        require(G.read_bytes() == original, 'Preview mutated gate')
    receipt = {'schema': 1, 'status': 'PASS', 'mode': 'APPLIED_GLOBAL_CHECKS_OPEN' if args.apply else 'VALIDATED_PROPOSAL_GATE_UNCHANGED',
               'gate_mutated': args.apply, 'terminal_acceptance': False, 'new_semantic_judgment': False,
               'closed_rows_rebound': len(closed), 'qualified_requests_copied': len(qualified),
               'artifact_count': len(artifact_records), 'prior_gate_sha256': digest(original),
               'candidate_gate_sha256': digest(candidate_raw), 'actual_gate_sha256': sha(G),
               'helper_sha256': sha(Path(__file__)), 'input': file_ref(input_path),
               'plan': file_ref(directory/'plan.json'), 'complete_validation': file_ref(directory/'complete-validation-receipt.json'),
               'completed_at_utc': datetime.now(timezone.utc).isoformat()}
    immutable(directory/'receipt.json', encode(receipt))
    print(json.dumps({'receipt': file_ref(directory/'receipt.json'), **receipt}, indent=2))

if __name__ == '__main__':
    main()
