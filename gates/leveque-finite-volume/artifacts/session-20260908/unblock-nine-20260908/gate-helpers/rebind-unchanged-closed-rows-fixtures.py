"""Bounded fixture/read-only evidence checks; never call helper.main or Git."""
from pathlib import Path
import copy
import hashlib
import importlib.util
import json
import sys
from datetime import datetime, timezone

H = Path(__file__).resolve().parent


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    value = importlib.util.module_from_spec(spec)
    sys.modules[name] = value
    spec.loader.exec_module(value)
    return value


def main():
    helper = module('unchanged_rows_fixture_helper', H / 'rebind-unchanged-closed-rows.py')
    root = helper.R
    reader = helper.Reader(root)
    baseline_raw = reader.read(H / 'unchanged-closed-row-inputs.json')
    assert helper.digest(baseline_raw) == helper.INPUT_SHA
    baseline = helper.parse(baseline_raw)
    audit_raw = reader.read(H / 'unchanged-closed-row-audit-validation-inputs.json')
    assert helper.digest(audit_raw) == helper.AUDIT_INPUT_SHA
    audit_inputs = helper.parse(audit_raw)
    checker_path = root.parent / baseline['gate_checker_relative_to_workspace']
    assert helper.digest(reader.read(checker_path)) == baseline['gate_checker_sha256']
    checker = module('unchanged_rows_fixture_released_checker', checker_path)
    results = []

    def succeeds(name, action):
        action()
        results.append({'name': name, 'expected': 'accept', 'actual': 'accept'})

    def rejects(name, action):
        try:
            action()
        except (ValueError, AssertionError, KeyError) as error:
            results.append({'name': name, 'expected': 'reject', 'actual': 'reject', 'reason': str(error)})
        else:
            raise AssertionError('Unexpected acceptance: ' + name)

    audit = helper.audit_evidence(reader, baseline, audit_inputs)
    native, output = helper.native_evidence(reader, baseline)
    succeeds('captured complete validation covers exact 32 rows', lambda: helper.require(len(audit) == 32, 'row count'))
    succeeds('captured native checks cover 41 distinct exact types and allowed axioms',
             lambda: helper.require(len(native['declarations']) == 41, 'native count'))
    prior = helper.parse(reader.bound(baseline['prior_gate'])[1])
    originals = {r['id']: r for r in prior['rows']}
    selected = set(baseline['closed_row_ids'])
    pinned_reference_count = 0
    payloads = []
    staged_candidates = set()
    old_used = set()
    for pin in baseline['closed_rows']:
        row = originals[pin['id']]
        assert helper.semantics(row) == pin['semantic_fields']
        assert helper.canonical(helper.semantics(row)) == pin['semantic_sha256']
        task = helper.parse(reader.bound(pin['task'])[1])
        manifest_raw = reader.bound(pin['manifest'])[1]
        decision_raw = reader.bound(pin['decision'])[1]
        manifest, decision = helper.parse(manifest_raw), helper.parse(decision_raw)
        assert manifest['status'] == 'completed' and manifest['task_id'] == task['task_id']
        for reference in helper.manifest_references(manifest):
            reader.bound(reference)
            pinned_reference_count += 1
        assert task['target'] == native['rows'][row['id']]
        assert row['lean_declarations'] == [task['target']['declaration']] == [manifest['target']['declaration']]
        record = audit[row['id']]
        assert record['exit_code'] == 0
        assert record['task'] == task['task_id'] and record['declaration'] == task['target']['declaration']
        assert record['manifest_sha256'] == helper.digest(manifest_raw)
        assert record['decision_sha256'] == helper.digest(decision_raw)
        assert decision['accepted'] is True
        for field in ('classification', 'lean_implies_source', 'source_implies_lean'):
            assert record[field] == row[field]
        assert decision['classification'] == row['classification']
        assert all(decision['implications'][f]['verdict'] == row[f] for f in ('lean_implies_source', 'source_implies_lean'))
        reader.bound(record['config'])
        assert len(record['command']) == 6 and record['command'][4:] == ['--phase', 'complete']
        for source in [manifest['target'], *manifest['local_import_sources']]:
            if source['path'].endswith('.lean') and not source['path'].startswith('.lake/'):
                staged_candidates.add(source['path'])
        context = None
        for role, fields in helper.ARTIFACT_FIELDS.items():
            path, raw = reader.bound(pin['artifacts'][role])
            artifact = helper.parse(raw)
            if context is None:
                context = {'bindings': {key: artifact['bindings'][key] for key in prior['bindings']}}
            synthetic_binding = {**artifact['bindings'], 'lean_worktree_sha256': '0' * 64}
            new = helper.rebind_artifact(raw, synthetic_binding, 'Synthetic byte-preservation fixture only.')
            assert helper.payload_span(new) == helper.payload_span(raw)
            payloads.append({'row': row['id'], 'check': role, 'sha256': helper.digest(helper.payload_span(raw))})
        defects = checker.row_artifact_defects(row, 1, context, helper.G.parent, old_used, location=row['id'])
        assert not defects, defects
    succeeds('all 32 sealed target/dependency/decision references and original row artifacts', lambda: None)
    succeeds('all 128 existing qualified payload byte spans preserved', lambda: helper.require(len(payloads) == 128, 'count'))

    raw = ('{"schema_version":1,"check":"direct","bindings":{},"procedure":"prior",'
           '"exit_code":0,"payload": { "analysis":"α \\u03b2 payload", "nested": [1,{"x":true}] }}').encode()
    succeeds('non-ASCII and escaped JSON payload formatting is preserved',
             lambda: helper.require(helper.payload_span(helper.rebind_artifact(raw, {'current': True}, 'fixture'))
                                    == helper.payload_span(raw), 'payload formatting'))
    rejects('duplicate JSON payload keys', lambda: helper.payload_span(b'{"payload":1,"payload":2}'))
    bad = helper.parse(raw)
    bad['exit_code'] = False
    rejects('boolean exit code cannot pretend integer zero', lambda: helper.rebind_artifact(helper.encode(bad), {}, 'fixture'))
    bad['exit_code'] = 0
    bad['extra'] = 'unreviewed'
    rejects('extra artifact envelope key', lambda: helper.rebind_artifact(helper.encode(bad), {}, 'fixture'))
    declaration = native['declarations'][0]
    rejects('unapproved axiom', lambda: helper.checked_axioms(declaration + ' : Prop\n\'' + declaration + "' depends on axioms: [sorryAx]", declaration))
    rejects('missing exact native type', lambda: helper.checked_axioms("'" + declaration + "' depends on axioms: [propext]", declaration))
    rejects('duplicate axiom report', lambda: helper.checked_axioms(output + '\n' + output, declaration))
    changed = copy.deepcopy(prior)
    closed_index = next(i for i, row in enumerate(changed['rows']) if row['id'] in selected)
    changed['rows'][closed_index]['direct_artifact'] = 'synthetic-new-reference'
    succeeds('only selected artifact reference can change', lambda: helper.verify_preservation(prior, changed, selected))
    changed['rows'][closed_index]['reuse_audit'] = 'Changed qualification'
    rejects('changed accepted qualification', lambda: helper.verify_preservation(prior, changed, selected))
    changed = copy.deepcopy(prior)
    changed['rows'][closed_index]['status'] = 'IN_PROGRESS'
    rejects('changed closed status', lambda: helper.verify_preservation(prior, changed, selected))
    changed = copy.deepcopy(prior)
    other = next(r for r in changed['rows'] if r['id'] not in selected)
    other['status'] = 'PROVED'
    rejects('unselected row change', lambda: helper.verify_preservation(prior, changed, selected))
    changed = copy.deepcopy(prior)
    changed['verification_evidence'][next(iter(changed['verification_evidence']))]['exit_code'] = 0
    rejects('invented global success', lambda: helper.verify_preservation(prior, changed, selected))
    rejects('parent path traversal', lambda: reader.path('../outside'))
    rejects('absolute path input', lambda: reader.path('/c/outside'))

    class ReceiptOverride:
        def __init__(self, key, replacement):
            self.key, self.replacement = key, replacement
        def bound(self, reference):
            if reference['path'] == self.key:
                return reader.path(self.key), helper.encode(self.replacement)
            return reader.bound(reference)

    actual_receipt = helper.parse(reader.bound(audit_inputs['receipt'])[1])
    forged = copy.deepcopy(actual_receipt)
    forged['exit_code'] = 1
    rejects('nonzero complete audit receipt', lambda: helper.audit_evidence(
        ReceiptOverride(audit_inputs['receipt']['path'], forged), baseline, audit_inputs))
    forged = copy.deepcopy(actual_receipt)
    forged['command'][-1] = '--require-all-closed'
    rejects('wrong audit validator mode', lambda: helper.audit_evidence(
        ReceiptOverride(audit_inputs['receipt']['path'], forged), baseline, audit_inputs))
    forged = copy.deepcopy(actual_receipt)
    forged['output_sha256'] = 'f' * 64
    rejects('stale audit output receipt', lambda: helper.audit_evidence(
        ReceiptOverride(audit_inputs['receipt']['path'], forged), baseline, audit_inputs))
    native_receipt = helper.parse(reader.bound(baseline['native_receipt'])[1])
    forged_native = {**native_receipt, 'exit_code': False}
    rejects('boolean native success', lambda: helper.native_evidence(
        ReceiptOverride(baseline['native_receipt']['path'], forged_native), baseline))

    fixture_dir = H / 'unchanged-closed-row-fixtures'
    fixture_dir.mkdir(exist_ok=False)
    row = copy.deepcopy(originals[baseline['closed_row_ids'][0]])
    first_pin = baseline['closed_rows'][0]
    first_artifact = helper.parse(reader.bound(first_pin['artifacts']['source-contract'])[1])
    context = {'bindings': {key: first_artifact['bindings'][key] for key in prior['bindings']}}
    context['bindings']['lean_worktree_sha256'] = 'a' * 64
    for role, (path_field, hash_field) in helper.ARTIFACT_FIELDS.items():
        source = reader.bound(first_pin['artifacts'][role])[1]
        raw = helper.rebind_artifact(source, checker.row_artifact_bindings(row, 1, context),
                                     'Synthetic released-checker acceptance fixture; not operational evidence.')
        path = fixture_dir / (role + '.json')
        helper.immutable(path, raw)
        row[path_field] = path.relative_to(helper.G.parent).as_posix()
        row[hash_field] = helper.digest(raw)
    succeeds('synthetic rebind passes exact released row checker', lambda: helper.require(
        not checker.row_artifact_defects(row, 1, context, helper.G.parent, set(), location='synthetic'), 'defects'))
    bad_row = copy.deepcopy(row)
    bad_row['direct_sha256'] = '0' * 64
    rejects('released checker rejects stale artifact hash', lambda: helper.require(
        not checker.row_artifact_defects(bad_row, 1, context, helper.G.parent, set(), location='synthetic'), 'hash defect'))
    bad_row = copy.deepcopy(row)
    bad_row['source_implies_lean'] = 'no'
    rejects('released checker rejects changed implication', lambda: helper.require(
        not checker.row_artifact_defects(bad_row, 1, context, helper.G.parent, set(), location='synthetic'), 'subject defect'))
    reader.unchanged()
    receipt = {'schema': 1, 'status': 'PASS', 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
               'scope': 'Fixtures and read-only captured inputs only; no helper.main, Git, gate write, audit rerun, or native Lean rerun.',
               'helper_sha256': helper.digest((H / 'rebind-unchanged-closed-rows.py').read_bytes()),
               'fixture_script_sha256': helper.digest(Path(__file__).read_bytes()),
               'tests': results, 'test_count': len(results), 'captured_closed_rows': 32,
               'captured_native_declarations': 41, 'captured_payloads': payloads,
               'sealed_file_reference_checks': pinned_reference_count,
               'source_paths_requiring_staged_bytes_at_operational_preflight': sorted(staged_candidates),
               'staged_bytes_check_executed': False,
               'files_read': [{'path': str(path), 'sha256': sha} for path, sha in reader.observed.items()]}
    helper.immutable(fixture_dir / 'receipt.json', helper.encode(receipt))
    print(json.dumps({'status': 'PASS', 'test_count': len(results), 'sealed_file_reference_checks': pinned_reference_count,
                      'receipt': str(fixture_dir / 'receipt.json'),
                      'receipt_sha256': helper.digest((fixture_dir / 'receipt.json').read_bytes())}))


if __name__ == '__main__':
    main()
