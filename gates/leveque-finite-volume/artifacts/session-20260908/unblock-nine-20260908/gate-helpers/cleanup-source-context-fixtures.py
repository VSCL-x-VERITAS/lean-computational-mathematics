"""Remove only verified leftover synthetic-test marker directories after Win32 cleanup failure."""
from pathlib import Path
import hashlib
import json
import os
import shutil
H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\'+str(H0.resolve())) if os.name == 'nt' else H0.resolve()
records = []
for path in sorted(H.glob('ctx-*')):
    assert path.resolve().parent == H.resolve() and path.is_dir() and path.name.startswith('ctx-')
    files = [p for p in path.rglob('*') if p.is_file()]
    assert len(files) == 1
    file = files[0]
    assert file.relative_to(path).as_posix() == 's/unblock-nine-20260908/prepare-successor-audit-with-source-context.py'
    assert file.read_bytes() == b'# SYNTHETIC TEST FIXTURE\n'
    records.append({'directory': path.name, 'file': file.relative_to(path).as_posix(),
                    'sha256': hashlib.sha256(file.read_bytes()).hexdigest()})
for record in records:
    path = H/record['directory']
    assert path.resolve().parent == H.resolve()
    shutil.rmtree(path)
    assert not path.exists()
with (H/'source-context-fixture-cleanup.json').open('xb') as handle:
    handle.write((json.dumps({'scope': 'only leftover synthetic marker files', 'removed': records,
        'original_gate_or_audit_files_touched': False}, indent=2)+'\n').encode())
print(json.dumps({'verified_synthetic_directories_removed': len(records)}))
