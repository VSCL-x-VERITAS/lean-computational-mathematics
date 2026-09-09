"""Clean only the exactly recognized leftover synthetic fixture trees."""
from pathlib import Path
import hashlib
import json
import os
import shutil
H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\'+str(H0.resolve())) if os.name == 'nt' else H0.resolve()
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
allowed = {'book.pdf', 'extension.json', 'literal.json', 'page.png', 'prior-config.json', 'selection.json',
           's/unblock-nine-20260908/prepare-successor-audit-with-source-context.py'}
records = []
for path in sorted(H.glob('ctx-*')):
    assert path.resolve().parent == H.resolve() and path.is_dir() and path.name.startswith('ctx-')
    files = [p for p in path.rglob('*') if p.is_file()]
    names = {p.relative_to(path).as_posix() for p in files}
    assert names in (allowed, allowed | {'dup.json'})
    assert (path/'s/unblock-nine-20260908/prepare-successor-audit-with-source-context.py').read_bytes().replace(b'\r\n', b'\n') == b'# SYNTHETIC TEST FIXTURE\n'
    assert (path/'book.pdf').read_bytes() in (b'%PDF SYNTHETIC GUARD FIXTURE; NOT SOURCE EVIDENCE', b'changed source')
    assert (path/'page.png').read_bytes() == b'\x89PNG\r\n\x1a\nSYNTHETIC'
    assert json.loads((path/'literal.json').read_text())['question'] == 'SYNTHETIC QUESTION'
    assert json.loads((path/'prior-config.json').read_text()) == {'synthetic': True}
    assert json.loads((path/'extension.json').read_text())['source']['path'] == 'book.pdf'
    if 'dup.json' in names: assert (path/'dup.json').read_bytes() == b'{"x":1,"x":2}'
    records.append({'directory': path.name, 'files': [{'path': f.relative_to(path).as_posix(), 'sha256': sha(f)} for f in files]})
with (H/'source-context-fixture-cleanup-v2-inputs.json').open('xb') as handle:
    handle.write((json.dumps(records, indent=2)+'\n').encode())
for record in records:
    path = H/record['directory']
    assert path.resolve().parent == H.resolve()
    assert all(sha(path/item['path']) == item['sha256'] for item in record['files'])
    shutil.rmtree(path)
    assert not path.exists()
with (H/'source-context-fixture-cleanup-v2-receipt.json').open('xb') as handle:
    handle.write((json.dumps({'actual_success': True, 'removed_count': len(records),
        'input_sha256': sha(H/'source-context-fixture-cleanup-v2-inputs.json'),
        'first_cleanup_attempt': 'Actual exit 1: expected a single marker; actual leftover set contained the verified synthetic top-level files too. No deletion occurred in that attempt.',
        'original_gate_or_audit_files_touched': False}, indent=2)+'\n').encode())
print(json.dumps({'verified_synthetic_directories_removed': len(records)}))
