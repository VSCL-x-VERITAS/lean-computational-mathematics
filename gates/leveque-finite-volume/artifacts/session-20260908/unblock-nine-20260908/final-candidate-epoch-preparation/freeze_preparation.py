"""Freeze preparation artifacts only; never execute candidate or organization commands."""
from pathlib import Path
import ast
import hashlib
import json

P = Path(__file__).resolve().parent
R = P.parents[5]
sha = lambda data: hashlib.sha256(data).hexdigest()
read = lambda p: json.loads(p.read_bytes())

for path in P.glob('*.py'):
    ast.parse(path.read_text(encoding='utf-8'), filename=path.name)
last = read(P / 'tests-04-receipt.json')
assert last['exit_code'] == 0
assert last['output_sha256'] == sha((P / 'tests-04-output.txt').read_bytes())
for item in last['inputs']:
    assert sha((P / item['path']).read_bytes()) == item['sha256'], item['path']
failed = read(P / 'tests-01-receipt.json')
assert failed['exit_code'] == 1
assert failed['output_sha256'] == sha((P / 'tests-01-output.txt').read_bytes())
old = next(x['sha256'] for x in failed['inputs'] if x['path'] == 'candidate_checks.py')
assert sha((P / 'candidate_checks-attempt01.py').read_bytes()) == old
for item in read(P / 'reviewed-inputs.json')['files']:
    raw_path = item['path']
    if raw_path.startswith('/c/'):
        path = Path('C:/' + raw_path[3:])
    else:
        path = R / raw_path
    assert sha(path.read_bytes()) == item['sha256'], raw_path
for item in read(P / 'candidate-replay-inputs.template.json')['tools'].values():
    assert sha((R / item['path']).read_bytes()) == item['sha256'], item['path']
assert read(P / 'candidate-replay-inputs.template.json')['gate'] is None
assert read(P / 'assembly-inputs.template.json')['status'] is None
assert read(P / 'organization-inputs.template.json')['ratchet_owner'] is None
manifest = {'schema_version': 1, 'kind': 'candidate-epoch-preparation-frozen',
    'scope': 'Additive candidate-local replay, organization preparation and schema-bound epoch assembly. No operational execution.',
    'files': [{'path': p.relative_to(R).as_posix(), 'sha256': sha(p.read_bytes()), 'bytes': p.stat().st_size}
              for p in sorted(P.iterdir()) if p.is_file() and p.name not in ('manifest.json', 'final-receipt.json')],
    'tests': {'actual_exit_code': 0, 'test_methods': 11,
              'receipt': 'tests-04-receipt.json', 'output_sha256': last['output_sha256']},
    'preserved_failure': {'receipt': 'tests-01-receipt.json', 'actual_exit_code': 1,
                          'source_snapshot': 'candidate_checks-attempt01.py'},
    'operational_actions_performed': [],
    'unfilled_dependencies': ['Actual final PASS gate and require-pass receipt', 'Actual final v6 complete-validation receipt for all41',
        'Completed candidate-local replay manifest and reviewed committed evidence closure',
        'Actual current organization source-scope/applicability reviews and measurement',
        'Actual final committed graph pair', 'Actual refreshed lane inventories and reviewed final mapping',
        'Actual request/CANDIDATE status/commit/tree', 'Actual eight candidate receipts',
        'Explicit current affected-book records, collisions and transports', 'Released full pristine validation and exact PASS checkpoint']}
with (P / 'manifest.json').open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(json.dumps(manifest, indent=2) + '\n')
receipt = {'schema_version': 1, 'kind': 'preparation-only-final-receipt',
    'manifest_sha256': sha((P / 'manifest.json').read_bytes()), 'test_exit_code': 0, 'test_methods': 11,
    'candidate_created': False, 'epoch_created': False, 'organization_measurement_executed': False,
    'gate_or_ref_changed': False, 'semantic_roles_launched': False,
    'script_hashes': {name: sha((P / name).read_bytes()) for name in
        ('candidate_checks.py', 'capture_checks.py', 'assemble_epoch.py', 'prepare_organization.py')},
    'review_sha256': sha((P / 'REVIEW.md').read_bytes())}
with (P / 'final-receipt.json').open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(json.dumps(receipt, indent=2) + '\n')
print(json.dumps({'manifest_sha256': receipt['manifest_sha256'],
    'final_receipt_sha256': sha((P / 'final-receipt.json').read_bytes()), **receipt['script_hashes'],
    'review_sha256': receipt['review_sha256'], 'files': len(manifest['files']), 'tests': 11}, indent=2))
