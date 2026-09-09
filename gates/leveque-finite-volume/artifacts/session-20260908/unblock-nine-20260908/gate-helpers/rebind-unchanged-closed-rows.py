"""Prepare immutable current-context evidence for exactly 32 unchanged closed rows.

Run only through the prepared POSIX launcher. Default writes a new immutable
proposal/preflight directory and leaves the gate unchanged. --execute installs
the checked candidate with an explicit prior-gate byte guard. No semantic row
field, payload byte span, judgment, source contract, or global check is changed.
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

H = Path(__file__).resolve().parent
R = H.parents[5]
G = R / 'gates/leveque-finite-volume/chapter-01.json'
INPUT_SHA = '78d630474e23ac6015b77fb7a4f07bb64d629c24fa68a136849a79d4e1c70224'
AUDIT_INPUT_SHA = 'a4d69705ad56e78af0e4211f851dae04f5228db8a78de848d95ed69fa370843a'
ARTIFACT_FIELDS = {
    'source-contract': ('source_contract_artifact', 'source_contract_sha256'),
    'blind': ('blind_artifact', 'blind_sha256'),
    'direct': ('direct_artifact', 'direct_sha256'),
    'round-trip': ('round_trip_artifact', 'round_trip_sha256'),
}
MUTABLE = {field for pair in ARTIFACT_FIELDS.values() for field in pair}
ALLOWED_AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def canonical(value):
    return digest(json.dumps(value, sort_keys=True, separators=(',', ':'),
                             ensure_ascii=False).encode('utf-8'))


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, 'Duplicate JSON key: ' + key)
        result[key] = value
    return result


def parse(data):
    return json.loads(data, object_pairs_hook=unique_object)


def encode(value):
    return (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode('utf-8')


def semantics(row):
    return {key: value for key, value in row.items() if key not in MUTABLE}


class Reader:
    def __init__(self, root):
        self.root = root.resolve()
        self.observed = {}

    def path(self, relative):
        require(isinstance(relative, str) and relative and '\\' not in relative
                and ':' not in relative and not relative.startswith('/'), 'Expected repository-relative POSIX path')
        require(all(part not in ('', '.', '..') for part in relative.split('/')), 'Invalid path component')
        path = self.root / relative
        require(path.resolve().is_relative_to(self.root) and not path.is_symlink(), 'Path escapes repository or is linked')
        return path

    def read(self, path):
        data = path.read_bytes()
        actual = digest(data)
        require(path not in self.observed or self.observed[path] == actual, 'Input changed: ' + str(path))
        self.observed[path] = actual
        return data

    def bound(self, reference):
        require(isinstance(reference, dict) and {'path', 'sha256'} <= set(reference), 'Missing file reference')
        path = self.path(reference['path'])
        data = self.read(path)
        require(digest(data) == reference['sha256'], 'File hash mismatch: ' + reference['path'])
        return path, data

    def unchanged(self):
        for path, expected in self.observed.items():
            require(digest(path.read_bytes()) == expected, 'Concurrent input change: ' + str(path))


def payload_span(raw):
    """Return the exact UTF-8 bytes of the existing top-level payload value."""
    document = parse(raw)
    text = raw.decode('utf-8')
    decoder = json.JSONDecoder(object_pairs_hook=unique_object)
    def skip(index):
        while index < len(text) and text[index].isspace():
            index += 1
        return index
    index = skip(0)
    require(text[index] == '{', 'Artifact must be an object')
    index += 1
    found = None
    while True:
        index = skip(index)
        if text[index] == '}':
            break
        key, index = decoder.raw_decode(text, index)
        index = skip(index)
        require(text[index] == ':', 'Malformed artifact member')
        start = skip(index + 1)
        value, end = decoder.raw_decode(text, start)
        if key == 'payload':
            require(found is None and value == document['payload'], 'Duplicate or inconsistent payload')
            found = text[start:end].encode('utf-8')
        index = skip(end)
        if text[index] == ',':
            index += 1
        else:
            require(text[index] == '}', 'Malformed artifact separator')
    require(found is not None, 'Missing payload')
    return found


def rebind_artifact(raw, bindings, procedure):
    old = parse(raw)
    require(set(old) == {'schema_version', 'check', 'bindings', 'procedure', 'exit_code', 'payload'}, 'Unexpected artifact schema')
    require(type(old['schema_version']) is int and old['schema_version'] == 1
            and type(old['exit_code']) is int and old['exit_code'] == 0, 'Existing artifact is not successful schema 1')
    span = payload_span(raw)
    prefix = {'schema_version': old['schema_version'], 'check': old['check'],
              'bindings': bindings, 'procedure': procedure, 'exit_code': old['exit_code']}
    head = json.dumps(prefix, indent=2, ensure_ascii=False).rstrip()[:-1].rstrip()
    new = (head + ',\n  "payload": ').encode('utf-8') + span + b'\n}\n'
    expected = {**old, 'bindings': bindings, 'procedure': procedure}
    require(parse(new) == expected and payload_span(new) == span, 'Rebinding changed the existing payload')
    return new


def manifest_references(value):
    if isinstance(value, dict):
        if isinstance(value.get('path'), str) and isinstance(value.get('sha256'), str):
            yield value
        for child in value.values():
            yield from manifest_references(child)
    elif isinstance(value, list):
        for child in value:
            yield from manifest_references(child)


def checked_axioms(output, declaration):
    matches = re.findall(re.escape("'" + declaration + "' depends on axioms:") + r'\s*\[([^\]]*)\]', output)
    require(len(matches) == 1, 'Missing or duplicate axiom report: ' + declaration)
    actual = {name.strip() for name in matches[0].split(',') if name.strip()}
    require(actual <= ALLOWED_AXIOMS, 'Unexpected axiom: ' + declaration)
    printed = re.findall(r'(?m)^@?' + re.escape(declaration)
                         + r'(?:\.\{[^}\r\n]+\})?\s*(?=[:{(\[])', output)
    require(len(printed) == 1, 'Missing or duplicate exact native type: ' + declaration)
    return sorted(actual)


def audit_evidence(reader, baseline, audit_inputs):
    _, receipt_raw = reader.bound(audit_inputs['receipt'])
    _, output_raw = reader.bound(audit_inputs['output'])
    receipt, output = parse(receipt_raw), parse(output_raw)
    require(type(receipt.get('exit_code')) is int and receipt['exit_code'] == 0, 'Audit validation did not actually exit zero')
    require(receipt.get('output_sha256') == digest(output_raw), 'Audit output does not match receipt')
    argv = receipt.get('command')
    require(argv == ['/usr/bin/python3', baseline['audit_validator']['path'], '--validate'],
            'Require the exact unchanged validator --validate command')
    reader.bound(baseline['audit_validator'])
    require(output.get('mode') == 'released-complete-validation' and output.get('closed_rows') == 32,
            'Inventory-only or non-32 audit result is not validation')
    records = output.get('records')
    require(isinstance(records, list) and len(records) == 32, 'Expected 32 complete-validator records')
    require({record['row'] for record in records} == set(baseline['closed_row_ids']), 'Audit row set differs from pinned 32')
    return {record['row']: record for record in records}


def native_evidence(reader, baseline):
    _, manifest_raw = reader.bound(baseline['native_manifest'])
    _, check_raw = reader.bound(baseline['native_check'])
    _, receipt_raw = reader.bound(baseline['native_receipt'])
    _, output_raw = reader.bound(baseline['native_output'])
    manifest, receipt = parse(manifest_raw), parse(receipt_raw)
    check, output = check_raw.decode('utf-8-sig'), output_raw.decode('utf-8-sig')
    require(type(receipt.get('exit_code')) is int and receipt['exit_code'] == 0, 'Native declaration check did not exit zero')
    require(receipt.get('command') == 'lake env lean ' + manifest['check_file'], 'Native check command differs')
    require(receipt.get('argv') == ['lake', 'env', 'lean', manifest['check_file']], 'Native argv differs')
    require(receipt.get('output_sha256') == digest(output_raw), 'Native output hash mismatch')
    require(manifest['check_file'] == baseline['native_check']['path']
            and manifest['check_file_sha256'] == digest(check_raw), 'Native check input differs')
    require(re.search(r'\berror:|sorryAx', output) is None, 'Native output contains an error or recovery axiom')
    declarations = manifest['declarations']
    require(len(declarations) == len(set(declarations)) == 41, 'Expected the exact full-41 declaration check')
    for declaration in declarations:
        for line in ('#check ' + declaration, '#print axioms ' + declaration):
            require(check.splitlines().count(line) == 1, 'Missing or repeated native check command: ' + line)
        checked_axioms(output, declaration)
    for item in manifest['files']:
        reader.bound(item)
    return manifest, output


def verify_preservation(before, after, selected):
    require([r['id'] for r in before['rows']] == [r['id'] for r in after['rows']], 'Inventory identity/order changed')
    for old, new in zip(before['rows'], after['rows']):
        if old['id'] in selected:
            require(semantics(old) == semantics(new), 'Semantic field changed: ' + old['id'])
        else:
            require(old == new, 'Unselected row changed: ' + old['id'])
    for key in before:
        if key not in {'rows', 'bindings'}:
            require(before[key] == after[key], 'Nonbinding top-level field changed: ' + key)
    require(set(before) == set(after), 'Top-level fields changed')


def immutable(path, raw):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('xb') as stream:
        stream.write(raw)


def staged_sources_equal(reader, records):
    for item in records:
        actual = reader.read(reader.path(item['path']))
        indexed = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', ':' + item['path']], cwd=R)
        require(digest(actual) == item['sha256'] and indexed == actual,
                'Staged source changed: ' + item['path'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--label', required=True)
    parser.add_argument('--expected-gate-sha256', required=True)
    parser.add_argument('--execute', action='store_true')
    args = parser.parse_args()
    require(os.name != 'nt', 'Use the prepared native-Python -> POSIX workflow launcher')
    require(re.fullmatch(r'[a-zA-Z0-9][a-zA-Z0-9-]{0,79}', args.label), 'Invalid fresh output label')
    require(re.fullmatch(r'[0-9a-f]{64}', args.expected_gate_sha256), 'Expected an exact prior-gate SHA256')
    reader = Reader(R)
    initial_raw = reader.read(H / 'unchanged-closed-row-inputs.json')
    require(digest(initial_raw) == INPUT_SHA, 'Frozen 32-row baseline changed')
    baseline = parse(initial_raw)
    audit_pin_raw = reader.read(H / 'unchanged-closed-row-audit-validation-inputs.json')
    require(digest(audit_pin_raw) == AUDIT_INPUT_SHA, 'Frozen audit validation pins changed')
    audit_inputs = parse(audit_pin_raw)
    _, baseline_gate_raw = reader.bound(baseline['prior_gate'])
    require(digest(baseline_gate_raw) == baseline['prior_gate_sha256'], 'Initial prior gate changed')
    original = reader.read(G)
    require(digest(original) == args.expected_gate_sha256, 'Current gate differs from explicit byte guard')
    gate = parse(original)
    require(gate['chapter_gate'] == 'ACTIVE', 'This helper only rebinds an ACTIVE gate')
    open_evidence = {'command': '', 'artifact': '', 'artifact_sha256': '', 'exit_code': None, 'count': 0}
    require(len(gate['verification_evidence']) == 8
            and all(value == open_evidence for value in gate['verification_evidence'].values()),
            'All eight global evidence records must already be OPEN')
    selected = baseline['closed_row_ids']
    require(len(selected) == len(set(selected)) == 32, 'Baseline is not exactly 32 distinct rows')
    require(set(MUTABLE) == set(baseline['mutable_row_fields']), 'Mutable row field policy changed')
    require([pin['id'] for pin in baseline['closed_rows']] == selected,
            'Baseline closed-row record order differs from its explicit row set')
    originals = {row['id']: row for row in gate['rows']}
    require(len(originals) == len(gate['rows']), 'Duplicate row IDs')
    for pin in baseline['closed_rows']:
        row = originals[pin['id']]
        require(semantics(row) == pin['semantic_fields'] and canonical(semantics(row)) == pin['semantic_sha256'],
                'Pinned closed-row semantics changed: ' + row['id'])
    require(canonical([semantics(originals[row]) for row in selected]) == baseline['closed_semantics_sha256'],
            'Pinned closed-row semantic aggregate changed')
    audit_records = audit_evidence(reader, baseline, audit_inputs)
    native, native_output = native_evidence(reader, baseline)
    checker_path = R.parent / baseline['gate_checker_relative_to_workspace']
    require(digest(reader.read(checker_path)) == baseline['gate_checker_sha256'], 'Released checker changed')
    spec = importlib.util.spec_from_file_location('unchanged_rows_released_checker', checker_path)
    checker = importlib.util.module_from_spec(spec)
    require(spec.loader is not None, 'Missing released checker loader')
    spec.loader.exec_module(checker)
    require(checker.ROW_ARTIFACT_REFS == ARTIFACT_FIELDS, 'Released artifact schema changed')
    context = checker.current_context(G, 1)
    require(context['lean_root'].resolve() == R.resolve(), 'Checker resolved another repository')
    staged = set()
    prior_artifacts = {}
    old_used = set()
    audit_rows = []
    for pin in baseline['closed_rows']:
        row = originals[pin['id']]
        task_path, task_raw = reader.bound(pin['task'])
        _, manifest_raw = reader.bound(pin['manifest'])
        _, decision_raw = reader.bound(pin['decision'])
        task, manifest, decision = parse(task_raw), parse(manifest_raw), parse(decision_raw)
        require(manifest['status'] == 'completed' and manifest['task_id'] == task['task_id'], 'Audit manifest is not completed')
        for reference in manifest_references(manifest):
            reader.bound(reference)
        require(task['target'] == native['rows'][row['id']], 'Current native target differs from the accepted target')
        require(row['faithfulness_task'] == pin['task']['path'] and row['faithfulness_decision'] == pin['decision']['path'],
                'Accepted audit identity changed')
        require(row['lean_declarations'] == [task['target']['declaration']]
                == [manifest['target']['declaration']], 'Declaration identity changed')
        record = audit_records[row['id']]
        require(type(record.get('exit_code')) is int and record['exit_code'] == 0, 'A released complete validator failed')
        require(record['task'] == task['task_id'] and record['declaration'] == task['target']['declaration']
                and record['manifest_sha256'] == digest(manifest_raw) and record['decision_sha256'] == digest(decision_raw),
                'Audit validation is stale or for another task')
        require(decision.get('accepted') is True and decision.get('task_id') == task['task_id'], 'Existing decision is not accepted')
        for field in ('classification', 'lean_implies_source', 'source_implies_lean'):
            require(record[field] == row[field], 'Validation differs from unchanged row: ' + field)
        require(decision['classification'] == row['classification']
                and all(decision['implications'][field]['verdict'] == row[field]
                        for field in ('lean_implies_source', 'source_implies_lean')), 'Sealed decision differs from row')
        reader.bound(record['config'])
        argv = record['command']
        require(isinstance(argv, list) and len(argv) == 6 and argv[1] == '-B'
                and argv[2].endswith('/.faithfulness-audit/scripts/validate_audit.py')
                and argv[3].endswith('/' + pin['task']['path']) and argv[4:] == ['--phase', 'complete'],
                'Record did not run the unchanged complete validator')
        require(re.fullmatch(r'[0-9a-f]{64}', record['output_sha256']), 'Missing validator output hash')
        for source in [manifest['target'], *manifest['local_import_sources']]:
            path, data = reader.bound(source)
            if path.suffix == '.lean' and not source['path'].startswith('.lake/'):
                staged.add(source['path'])
        old_context = None
        for check, (path_field, hash_field) in ARTIFACT_FIELDS.items():
            current_path = (G.parent / row[path_field]).resolve()
            require(current_path.is_relative_to(R.resolve()), 'Artifact path escapes repository')
            current_raw = reader.read(current_path)
            require(digest(current_raw) == row[hash_field], 'Current artifact hash differs from row')
            _, baseline_raw = reader.bound(pin['artifacts'][check])
            require(payload_span(current_raw) == payload_span(baseline_raw), 'Existing qualified payload changed')
            artifact = parse(current_raw)
            require(artifact['check'] == check, 'Artifact role mismatch')
            if old_context is None:
                old_context = {'bindings': {key: artifact['bindings'][key] for key in context['bindings']}}
            prior_artifacts[(row['id'], check)] = (current_raw, current_path)
        defects = checker.row_artifact_defects(row, 1, old_context, G.parent, old_used, location=row['id'])
        require(not defects, 'Existing artifacts fail their own bound context: ' + repr(defects))
        audit_rows.append({'row': row['id'], 'task': task['task_id'], 'manifest_sha256': digest(manifest_raw),
                           'decision_sha256': digest(decision_raw), 'axioms': checked_axioms(native_output, task['target']['declaration'])})
    staged_records = []
    for relative in sorted(staged):
        actual = reader.read(reader.path(relative))
        indexed = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', ':' + relative], cwd=R)
        require(indexed == actual, 'Source bytes must be explicitly staged: ' + relative)
        staged_records.append({'path': relative, 'sha256': digest(actual), 'staged_bytes_equal': True})
    directory = H.parent / 'unchanged-closed-row-rebind-runs' / args.label
    require(not directory.exists(), 'Output label already exists')
    reader.unchanged()
    candidate = copy.deepcopy(gate)
    candidate['bindings'] = copy.deepcopy(context['bindings'])
    rows = {row['id']: row for row in candidate['rows']}
    directory.mkdir(parents=True, exist_ok=False)
    immutable(directory / 'prior-gate.json', original)
    artifact_records = []
    for row_id in selected:
        row = rows[row_id]
        binding = checker.row_artifact_bindings(row, 1, context)
        for check, (path_field, hash_field) in ARTIFACT_FIELDS.items():
            previous, previous_path = prior_artifacts[(row_id, check)]
            procedure = ('Rebind only context and provenance; copy the existing payload byte-for-byte. '
                         'The unchanged complete-audit validator actually exited 0 for the exact pinned 32 rows; '
                         'audit validation receipt SHA256 ' + audit_inputs['receipt']['sha256'] + '; '
                         'current native declaration/axiom receipt SHA256 ' + baseline['native_receipt']['sha256'] + '; '
                         'native output SHA256 ' + baseline['native_output']['sha256'] + '; '
                         'prior artifact SHA256 ' + digest(previous) + '; prior gate SHA256 ' + digest(original) + '. '
                         'No new semantic judgment is asserted. Original procedure: ' + parse(previous)['procedure'])
            raw = rebind_artifact(previous, binding, procedure)
            path = directory / 'artifacts' / row_id / ('gate-' + check + '.json')
            immutable(path, raw)
            require(reader.read(path) == raw, 'New artifact changed immediately after exclusive creation')
            row[path_field] = path.relative_to(G.parent).as_posix()
            row[hash_field] = digest(raw)
            artifact_records.append({'row': row_id, 'check': check, 'path': path.relative_to(R).as_posix(),
                                     'sha256': digest(raw), 'previous_path': previous_path.relative_to(R).as_posix(),
                                     'previous_sha256': digest(previous), 'payload_bytes_sha256': digest(payload_span(raw))})
    verify_preservation(gate, candidate, set(selected))
    used = set()
    for row_id in selected:
        defects = checker.row_artifact_defects(rows[row_id], 1, context, G.parent, used, location=row_id)
        require(not defects, 'New artifacts fail released row checks: ' + repr(defects))
    candidate_raw = encode(candidate)
    immutable(directory / 'candidate-gate.json', candidate_raw)
    immutable(directory / 'plan.json', encode({'schema': 1, 'mode': 'execute' if args.execute else 'preflight-only',
              'initial_baseline_gate_sha256': baseline['prior_gate_sha256'], 'current_prior_gate_sha256': digest(original),
              'closed_semantics_sha256': baseline['closed_semantics_sha256'], 'bindings': context['bindings'],
              'rows': audit_rows, 'explicitly_staged_sources': staged_records, 'artifacts': artifact_records,
              'candidate_gate_sha256': digest(candidate_raw), 'global_evidence': 'OPEN, unchanged'}))
    reader.read(directory / 'prior-gate.json')
    reader.read(directory / 'candidate-gate.json')
    reader.read(directory / 'plan.json')
    require(checker.current_context(G, 1)['bindings'] == context['bindings'], 'Context changed during preparation')
    staged_sources_equal(reader, staged_records)
    reader.unchanged()
    require(G.read_bytes() == original, 'Concurrent gate write detected')
    if args.execute:
        temporary = directory / 'install-temporary.json'
        immutable(temporary, candidate_raw)
        require(G.read_bytes() == original, 'Gate changed at installation byte guard')
        os.replace(temporary, G)
        require(G.read_bytes() == candidate_raw, 'Installed gate differs from checked candidate')
    else:
        require(G.read_bytes() == original, 'Dry run changed the gate')
    receipt = {'schema': 1, 'status': 'PASS', 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
               'mode': 'execute' if args.execute else 'preflight-only', 'gate_mutated': args.execute,
               'closed_rows_rebound': 32, 'artifact_count': 128, 'payloads_preserved_byte_for_byte': True,
               'all_other_row_fields_preserved': True, 'unselected_rows_preserved': True,
               'released_row_artifact_defects': [], 'global_evidence': 'OPEN, unchanged',
               'prior_gate_sha256': digest(original), 'candidate_gate_sha256': digest(candidate_raw),
               'actual_gate_sha256': digest(G.read_bytes()), 'helper_sha256': digest(Path(__file__).read_bytes()),
               'plan_sha256': digest((directory / 'plan.json').read_bytes())}
    immutable(directory / 'receipt.json', encode(receipt))
    print(json.dumps({'mode': receipt['mode'], 'receipt': str(directory / 'receipt.json'),
                      'receipt_sha256': digest((directory / 'receipt.json').read_bytes()),
                      'gate_sha256': receipt['actual_gate_sha256'], 'global_evidence': 'OPEN'}))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
