"""Verify actual native declaration/axiom output for all current row producers."""
from pathlib import Path
import hashlib, json, re
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
manifest_path = S / 'chapter01-current-producer-inputs.json'
manifest = json.loads(manifest_path.read_text())
check = S / 'chapter01-current-producer-checks.lean'
output_path = S / 'chapter01-current-producer-checks-output.txt'
exit_path = S / 'chapter01-current-producer-checks-exit.json'
receipt = json.loads(exit_path.read_text(encoding='utf-8-sig'))
assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
assert receipt['command'] == 'lake env lean ' + check.relative_to(R).as_posix()
assert sha(check.read_bytes()) == manifest['check_file_sha256']
output = output_path.read_text(encoding='utf-8-sig')
assert not re.search(r'(?m)^.*\.lean:\d+:\d+: error:', output)
checks = []
for f in manifest['files']:
    assert sha((R / f['path']).read_bytes()) == f['sha256'], f['path']
    name = f['declarations'][0]
    match = re.search(re.escape("'" + name + "' depends on axioms:") + r'\s*\[([^\]]*)\]', output)
    assert match, name
    axioms = sorted({a.strip() for a in match.group(1).split(',') if a.strip()})
    assert set(axioms) <= {'propext', 'Classical.choice', 'Quot.sound'}
    checks.append({'row': f['row'], 'name': name, 'axioms': axioms, 'path': f['path'], 'target_sha256': f['sha256']})
assert len(checks) == 41 and len({x['name'] for x in checks}) == 41
result = {'schema': 1, 'exit_code': 0, 'count': 41, 'checks': checks,
    'input_manifest_sha256': sha(manifest_path.read_bytes()),
    'native_output_sha256': sha(output_path.read_bytes()), 'native_exit_receipt_sha256': sha(exit_path.read_bytes()),
    'scope': 'Every current formalizable-row producer resolves through canonical and compatibility chapter imports with only allowed axioms. Compilation does not confer semantic audit acceptance.'}
destination = S / 'chapter01-current-producer-verification.json'
assert not destination.exists()
destination.write_text(json.dumps(result, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
print(json.dumps({'checked_producers': 41, 'receipt_sha256': sha(destination.read_bytes()), 'native_output_sha256': result['native_output_sha256']}))

