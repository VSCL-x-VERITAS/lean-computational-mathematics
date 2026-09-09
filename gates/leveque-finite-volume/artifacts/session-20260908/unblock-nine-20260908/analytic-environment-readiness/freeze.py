"""Freeze this additive environment-only packet without any operational invocation."""
from pathlib import Path
import hashlib
import json
import os

H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\' + str(H0)) if os.name == 'nt' else H0
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
for label, exit_code in [('default-codepage', 1), ('utf8', 0)]:
    receipt = read(H / label / 'receipt.json')
    assert receipt['exit_code'] == exit_code and receipt['input_sha256'] == sha(H / 'prepare-companion-drafts.py')
    assert receipt['output_sha256'] == sha(H / label / 'output.txt')
report = read(H / 'readiness.json')
assert report['originals_unchanged'] and not report['active_audits_modified']
assert all(x['closed_loader_validation'] for x in report['results'])
files = sorted(p for p in H.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
manifest = {'schema': 1, 'source_acceptance': False, 'scope': 'environment-only additive draft preparation',
            'files': [{'path': p.relative_to(H).as_posix(), 'sha256': sha(p)} for p in files]}
with (H / 'manifest.json').open('xb') as f: f.write((json.dumps(manifest, indent=2) + '\n').encode())
final = {'schema': 1, 'status': 'INPUTS_AND_DRAFT_PACKET_BINDINGS_VERIFIED_NO_AUDIT_JUDGMENT',
         'readiness_sha256': sha(H / 'readiness.json'), 'manifest_sha256': sha(H / 'manifest.json'),
         'actual_check_exit': 0, 'existing_native_exit': report['existing_native_exit'],
         'new_native_runs': 0, 'audit_launches': 0, 'active_inputs_modified': False,
         'drafts': [{'label': x['label'], **x['draft']} for x in report['results']]}
with (H / 'final-receipt.json').open('xb') as f: f.write((json.dumps(final, indent=2) + '\n').encode())
print(json.dumps({'final_receipt_sha256': sha(H / 'final-receipt.json'), **final}, indent=2))
