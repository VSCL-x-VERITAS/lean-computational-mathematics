"""Freeze tested additive metadata guards; does not accept or modify any source row."""
from pathlib import Path
from datetime import datetime, timezone
import ast
import hashlib
import json

H = Path(__file__).resolve().parent
S = H.parents[1]
R = S.parents[3]
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
def ref(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
def read(path):
    return json.loads(path.read_bytes())
def write(path, data):
    with path.open('xb') as stream:
        stream.write((json.dumps(data, indent=2) + '\n').encode())

derivation = read(H / 'high-resolution-context-helper-derivation.json')
files = [H / 'high-resolution-context-helper-derivation.json',
         H / 'derive-high-resolution-context-helpers.py',
         H / 'high-resolution-context-validation.fragment.py',
         H / 'test-high-resolution-context-helpers.py',
         H / 'test-high-resolution-context-helpers-01.py.snapshot',
         H / 'source-context-v4-validator-dependencies.json', Path(__file__).resolve()]
for item in derivation['derivations']:
    parent, output = R / item['parent']['path'], R / item['output']['path']
    assert sha(parent) == item['parent']['sha256']
    text = parent.read_text(encoding='utf-8')
    for change in item['exact_replacements']:
        assert text.count(change['before']) == 1
        text = text.replace(change['before'], change['after'])
    assert output.read_bytes() == text.encode('utf-8')
    assert sha(output) == item['output']['sha256']
    compile(text, output.name, 'exec')
    files.append(output)
attempts = []
for number, expected in [(1, 1), (2, 0)]:
    label = f'unblock-nine-high-resolution-helper-tests-{number:02d}'
    receipt, output = S / (label + '-exit.json'), S / (label + '-output.txt')
    data = read(receipt)
    assert data['exit_code'] == expected
    assert data['output_sha256'] == sha(output)
    assert data['capture_script_sha256'] == 'db1280f152c591b72d6e8542c64f7f814ed5ab6a8dda8a88736e19227ace29a8'
    assert 'Ran 43 tests' in output.read_text(encoding='utf-8')
    if number == 2:
        assert output.read_text(encoding='utf-8').rstrip().endswith('OK')
    attempts.append({'receipt': ref(receipt), 'output': ref(output), 'actual_exit': expected})
    files.extend([receipt, output])
global_path = H / 'bind-final-global-evidence-v3.py'
values = {node.targets[0].id: ast.literal_eval(node.value)
          for node in ast.parse(global_path.read_text(encoding='utf-8')).body
          if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Name)
          and node.targets[0].id in ('FINAL_VALIDATOR_PIN', 'FINAL_VALIDATOR_DEPENDENCIES')}
global_deps_path = H / 'final-global-v3-validator-dependencies.json'
write(global_deps_path, {'audit_validator': values['FINAL_VALIDATOR_PIN'],
                         'validator_dependencies': values['FINAL_VALIDATOR_DEPENDENCIES']})
files.append(global_deps_path)
for item in [values['FINAL_VALIDATOR_PIN'], *values['FINAL_VALIDATOR_DEPENDENCIES']]:
    assert sha(R / item['path']) == item['sha256']
manifest = H / 'high-resolution-context-helper-manifest.json'
write(manifest, {'format': 'additive-literal-context-helper-manifest-1',
                 'files': [ref(path) for path in sorted(set(files))], 'source_acceptance': False})
final = {
    'format': 'additive-literal-context-helper-preparation-receipt-1',
    'status': 'PASS_HELPER_PREPARATION_ONLY', 'recorded_at_utc': datetime.now(timezone.utc).isoformat(),
    'manifest': ref(manifest), 'derivation': ref(H / 'high-resolution-context-helper-derivation.json'),
    'literal_receipt': ref(H.parent / 'user-high-resolution-interpretation-20260908.json'),
    'source_context': ref(H.parent / 'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json'),
    'actual_test_attempts': attempts, 'final_tests': 43, 'actual_final_exit': 0,
    'failed_test_resolution': 'The first test called a nonexistent fixture function name verify_audits. The actual function is validate_audit_records; the final test checks its sole changed version-label string. Helper bytes were unchanged.',
    'operational_validations': 0, 'gate_mutations': 0, 'model_roles': 0,
    'source_acceptance': False, 'sealed_protocol_unchanged': True,
    'scope': 'Allows the exact new literal answer only for the exact dimensional-splitting context. Preserves old single-receipt behavior, protected rows, native proof requirements and unchanged complete validation.'}
write(H / 'high-resolution-context-helper-final-receipt.json', final)
print(json.dumps({'receipt': ref(H / 'high-resolution-context-helper-final-receipt.json'), **final}, sort_keys=True))
