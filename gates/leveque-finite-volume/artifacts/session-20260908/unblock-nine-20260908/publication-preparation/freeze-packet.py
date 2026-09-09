"""Freeze only this completed read-only preparation packet; no repository operations."""
from pathlib import Path
import hashlib
import json
import os
from datetime import datetime, timezone

H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\' + str(H0)) if os.name == 'nt' else H0
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
snapshot = read(H / 'snapshot-current-02/inventory.json')
assert sha(H / 'snapshot-current-02/inventory.json') == 'd344540ff956f036e01bdd462e3e98ef795363a2c210d9fed1726bf84263b34f'
assert snapshot['counts'] == {'select': 2459, 'exclude': 14, 'hold': 0} and snapshot['issues'] == []
assert snapshot['head_before'] == snapshot['head_after'] and snapshot['index_sha256_before'] == snapshot['index_sha256_after']
for name, expected in [('run-policy-01', 1), ('run-policy-02', 0), ('run-tests-01', 1),
                       ('run-tests-02', 0), ('run-derive-checker-v2', 0), ('run-tests-03', 0),
                       ('run-snapshot-01', 0), ('run-snapshot-02', 0)]:
    receipt = read(H / name / 'receipt.json')
    assert receipt['exit_code'] == expected and receipt['output_sha256'] == sha(H / name / 'output.txt')
assert b'Ran 7 tests' in (H / 'run-tests-03/output.txt').read_bytes()
for archive in snapshot['archives']:
    path = archive['archive']['path']
    assert any(x['path'] == path and x['disposition'] == 'select' for x in snapshot['files'])
names = sorted(p.relative_to(H).as_posix() for p in H.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
assert not any(n in names for n in ('manifest.json', 'final-receipt.json'))
manifest = {'schema': 1, 'scope': 'publication staging preparation; live snapshot only',
            'publication_complete': False, 'source_acceptance': False,
            'files': [{'path': name, 'sha256': sha(H / name), 'bytes': (H / name).stat().st_size} for name in names]}
with (H / 'manifest.json').open('xb') as f: f.write((json.dumps(manifest, indent=2) + '\n').encode())
final = {'schema': 1, 'status': 'PREPARATION_CHECKED_NOT_STAGED_NOT_PUBLICATION_COMPLETE',
         'created_at_utc': datetime.now(timezone.utc).isoformat(),
         'helper': {'path': 'check-publication-allowlist-v2.py', 'sha256': sha(H / 'check-publication-allowlist-v2.py')},
         'policy': {'path': 'policy.json', 'sha256': sha(H / 'policy.json')},
         'snapshot': {'path': 'snapshot-current-02/inventory.json', 'sha256': sha(H / 'snapshot-current-02/inventory.json')},
         'actual_snapshot_exit': read(H / 'run-snapshot-02/receipt.json')['exit_code'],
         'actual_tests_exit': read(H / 'run-tests-03/receipt.json')['exit_code'], 'synthetic_test_methods': 7,
         'manifest_sha256': sha(H / 'manifest.json'), 'git_mutations': 0, 'gate_mutations': 0,
         'counts': snapshot['counts'], 'large_raw_files_excluded': 2, 'large_index_blobs': 0,
         'exact_archives_verified': 2, 'future_owned_receipt_additions_required': True}
with (H / 'final-receipt.json').open('xb') as f: f.write((json.dumps(final, indent=2) + '\n').encode())
print(json.dumps({'final_receipt_sha256': sha(H / 'final-receipt.json'), **final}, indent=2))
