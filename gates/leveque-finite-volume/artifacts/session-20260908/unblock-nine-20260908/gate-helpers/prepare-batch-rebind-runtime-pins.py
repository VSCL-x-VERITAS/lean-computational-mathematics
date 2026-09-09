"""Freeze installed sealed-validator script/schema bytes only; do not validate audits."""
from pathlib import Path
import hashlib
import json

H = Path(__file__).resolve().parent
R = H.parents[5]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(R/'.faithfulness-audit/scripts/validate_audit.py') == '98893aecc90f52c9b7a63dbf211db3da5e42f26ecb6f132fbfb5098a7bf2ad20'
files = [p for folder in (R/'.faithfulness-audit/scripts', R/'.faithfulness-audit/schemas')
         for p in folder.rglob('*') if p.is_file() and '__pycache__' not in p.parts]
value = {'schema': 1, 'scope': 'installed sealed validator scripts and schemas',
         'files': [{'path': p.relative_to(R).as_posix(), 'sha256': sha(p)} for p in sorted(files)],
         'operational_validation': False}
out = H/'batch-rebind-runtime-pins.json'
with out.open('xb') as handle: handle.write((json.dumps(value, indent=2)+'\n').encode())
print(json.dumps({'path': out.relative_to(R).as_posix(), 'sha256': sha(out), 'file_count': len(files)}))
