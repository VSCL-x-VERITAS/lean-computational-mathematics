"""Focused non-mutating guards using actual completed receipts plus marked synthetic rows."""
from pathlib import Path
import ast
import copy
import hashlib
import importlib.util
import json
from types import SimpleNamespace

HERE = Path(__file__).resolve().parent
S = HERE.parents[1]
R = S.parents[3]
spec = importlib.util.spec_from_file_location('final_global_binder_fixtures', HERE / 'bind-final-global-evidence.py')
b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(b)
passed = []

def test(name, action, rejects=False):
    try:
        action()
    except (ValueError, KeyError, TypeError, AssertionError):
        if not rejects:
            raise
    else:
        if rejects:
            raise AssertionError('Guard accepted invalid input: ' + name)
    passed.append(name)

labels = {'source-inventory': 'unblock-nine-final-source-inventory',
          **{n: 'unblock-nine-organization-' + n for n in ('layout', 'tiers', 'compatibility', 'hygiene')},
          'declarations': 'unblock-nine-complete-declarations',
          'focused-build': 'unblock-nine-final-focused-build',
          'full-build': 'unblock-nine-initial-full-build'}
commit = '5e3f63594aa964263469ada134aee2809559d50d'
receipts, outputs = {}, {}
for name, label in labels.items():
    receipt = b.read(S / (label + '-exit.json'))
    output = (S / (label + '-output.txt')).read_bytes()
    test('actual successful ' + name, lambda: b.verify_receipt(receipt, output, commit, name))
    receipts[name], outputs[name] = receipt, output

receipt = receipts['declarations']
data = outputs['declarations']
for name, patch in [('boolean exit', {'exit_code': False}), ('failed exit', {'exit_code': 1}),
                    ('wrong commit', {'input_commit': '0' * 40}), ('boolean elapsed', {'elapsed_ms': False}),
                    ('negative elapsed', {'elapsed_ms': -1}), ('stale output digest', {'output_sha256': '0' * 64}),
                    ('conflicting secondary digest', {'raw_output_sha256': '0' * 64})]:
    invalid = {**receipt, **patch}
    test(name, lambda: b.verify_receipt(invalid, data, commit, name), True)
test('changed output bytes', lambda: b.verify_receipt(receipt, data + b'changed', commit, 'declarations'), True)

scripts = {'source-inventory': S / 'verify-reviewed-source-coverage.py',
           'layout': R / 'tools/architecture/check_layout.py',
           'tiers': R / 'tools/architecture/check_tiers.py',
           'compatibility': R / 'tools/architecture/check_compatibility.py',
           'hygiene': R / 'tools/architecture/check_placeholders.py'}
for name, script in scripts.items():
    test('actual checker argv ' + name, lambda: b.python_command(R, receipts[name]['command'], script))
validator = HERE / 'synthetic-validator-not-executed.py'
cmd = ['/usr/bin/python3', '-B', str(validator), '--validate', '--require-all-closed']
test('configured validator command', lambda: b.python_command(R, cmd, validator, ['--validate', '--require-all-closed']))
test('missing all-closed flag', lambda: b.python_command(R, cmd[:-1], validator, ['--validate', '--require-all-closed']), True)
test('inventory invocation rejected', lambda: b.python_command(R, cmd[:3], validator, ['--validate', '--require-all-closed']), True)
test('wrong validator path', lambda: b.python_command(R, cmd, HERE / 'other.py', ['--validate', '--require-all-closed']), True)
test('extra validator switch', lambda: b.python_command(R, cmd + ['--force'], validator, ['--validate', '--require-all-closed']), True)
test('shell command rejected', lambda: b.python_command(R, ' '.join(cmd), validator, ['--validate', '--require-all-closed']), True)

manifest = b.read(S / 'unblock-nine-20260908/complete-declaration-manifest.json')
checkfile = manifest['check_file']
test('actual declaration native argv', lambda: b.native_command(receipt, ['lake', 'env', 'lean', checkfile], 'declarations'))
test('native text/argv disagreement', lambda: b.native_command({**receipt, 'command': 'lake build'}, receipt['argv'], 'declarations'), True)
test('missing native identity', lambda: b.native_command({**receipt, 'native_lake': ''}, receipt['argv'], 'declarations'), True)
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
native_text = data.decode('utf-8-sig')
test('all 41 actual type and axiom reports', lambda: b.read_axioms(native_text, manifest['declarations'], allowed))
name = manifest['declarations'][0]
test('duplicate axiom report', lambda: b.read_axioms(native_text + "\n'" + name + "' depends on axioms: []\n", [name], allowed), True)
test('unapproved axiom', lambda: b.read_axioms(native_text.replace('propext', 'forbiddenAxiom'), manifest['declarations'], allowed), True)
test('missing declaration report', lambda: b.read_axioms(native_text, ['Missing.fixture'], allowed), True)
test('native error', lambda: b.read_axioms(native_text + '\nfixture.lean:1:2: error: synthetic\n', manifest['declarations'], allowed), True)
test('duplicate exact type report', lambda: b.read_axioms(native_text + '\n' + name + ' : True\n', [name], allowed), True)

# These synthetic cases stop before any file lookup; no synthetic audit is accepted.
rows = [{'id': f'fixture-{i:02}'} for i in range(41)]
records = [{'row': r['id']} for r in rows]
test('audit inventory-only mode', lambda: b.validate_audit_records(
    {'mode': 'inventory-only-not-validation', 'closed_rows': 41, 'records': records}, rows, R, {}), True)
test('only 40 audit records', lambda: b.validate_audit_records(
    {'mode': 'released-complete-validation', 'closed_rows': 41, 'records': records[:-1]}, rows, R, {}), True)
test('41 records wrong order', lambda: b.validate_audit_records(
    {'mode': 'released-complete-validation', 'closed_rows': 41, 'records': records[::-1]}, rows, R, {}), True)
test('missing inner actual success', lambda: b.validate_audit_records(
    {'mode': 'released-complete-validation', 'closed_rows': 41, 'records': records}, rows, R, {}), True)
test('duplicate JSON key', lambda: b.decode(b'{"a":1,"a":2}'), True)
test('repository path traversal', lambda: b.repository_path(R, '../outside'), True)
test('absolute repository path', lambda: b.repository_path(R, 'C:/outside'), True)
test('changed pinned file', lambda: b.bound_file(R, {'path': checkfile, 'sha256': '0' * 64}, {}), True)
test('invalid hash reference', lambda: b.bound_file(R, {'path': checkfile, 'sha256': 'not-a-hash'}, {}), True)

# Evaluate only literal payload/count/source-map assignments from v3 and this successor.
# No mutation entry, dynamic checker import or operational context call is invoked.
def assigned(tree, key):
    found = [node for node in ast.walk(tree) if isinstance(node, ast.Assign)
             and any(isinstance(t, ast.Name) and t.id == key for t in node.targets)]
    if len(found) != 1:
        raise AssertionError('Expected one assignment: ' + key)
    return compile(ast.Expression(found[0].value), '<payload-comparison>', 'eval')

def compare_payloads():
    original = ast.parse((S / 'bind-final-gate-evidence-v3.py').read_text(encoding='utf-8'))
    successor = ast.parse((HERE / 'bind-final-global-evidence.py').read_text(encoding='utf-8'))
    row = {'id': 'fixture-row', 'printed_page': 1, 'pdf_page': 23,
           **{k: 'fixture-' + k for k in ('contract_hash', 'source_contract_sha256', 'blind_sha256',
               'direct_sha256', 'round_trip_sha256', 'adjudication_sha256')}}
    env = dict(g={'rows': [row]}, context={'printed_range': [1, 11], 'pdf_range': [23, 33],
               'bindings': {'unit_audit_epoch': 'fixture', 'unit_index_sha256': 'fixture'},
               'lean_changed_paths': ['fixture.lean']},
               organization={'unclassified': 0}, G=R / 'gates/leveque-finite-volume/chapter-01.json',
               R=R, root=R, paths=['fixture-gate'], checker=SimpleNamespace(text=lambda r, k: r[k]),
               closed=[row], names=['fixture-declaration'], axioms=[{'name': 'fixture', 'axioms': []}],
               state={'axioms': [{'name': 'fixture', 'axioms': []}]})
    for key in ('payloads', 'counts', 'primary'):
        if eval(assigned(original, key), env) != eval(assigned(successor, key), env):
            raise AssertionError('Changed v3 evidence projection: ' + key)

test('all eight v3 payloads/counts/receipt roles preserved', compare_payloads)
print(json.dumps({'status': 'PASS', 'fixture_checks': len(passed), 'checks': passed,
                  'actual_receipts': 8, 'actual_native_declarations': 41,
                  'audit_record_tests': 'synthetic rejection only; final 41-row validation not available',
                  'gate_written': False, 'operational_validate_or_execute_run': False}, indent=2))
