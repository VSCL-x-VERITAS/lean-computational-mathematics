"""Freeze the actual final native receipt for a later all-closed row rebind."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
manifest_path = D / 'final-certified-complete-declarations/manifest.json'
assert sha(manifest_path) == '55f80b2eb6dadf90a68c6a5857db326882954b24d908b5b13524bb8228e69f59'
manifest = json.loads(manifest_path.read_bytes())
receipt_path = S / 'unblock-nine-final-current-declarations-exit.json'
output = S / 'unblock-nine-final-current-declarations-output.txt'
receipt = json.loads(receipt_path.read_bytes())
assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
assert receipt['argv'] == ['lake', 'env', 'lean', manifest['check_file']]
assert sha(output) == receipt['output_sha256'] == 'ea279f27dcb48b2897ad8d11c55b714be4bdfdff9fab90dd9613dbe99b9acf0a'
assert len(manifest['rows']) == len(manifest['declarations']) == 41
assert sha(R / manifest['check_file']) == manifest['check_file_sha256']
for item in manifest['files']:
    assert sha(R / item['path']) == item['sha256']
bundle = {'format': 'explicit-current-chapter-one-checks-1',
    'declaration_manifest': ref(manifest_path),
    'evidence': {'declarations': {'receipt': ref(receipt_path), 'output': ref(output)}}}
path = D / 'final-current-native-bundle.json'
with path.open('xb') as stream:
    stream.write((json.dumps(bundle, indent=2) + '\n').encode())
print(json.dumps({'bundle': ref(path), 'native_declarations': 41, 'source_acceptance': False,
                  'all_closed_rebind_not_invoked': True}))
