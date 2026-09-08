from pathlib import Path
import hashlib
import json

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
ROOT = SESSION.parents[3]

def entry(path):
    return {'path': str(path), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
            'bytes': path.stat().st_size}

result = json.loads((HERE / 'read-only-check-result.json').read_text(encoding='utf-8'))
exit_record = json.loads((HERE / 'read-only-check-exit.json').read_text(encoding='utf-8-sig'))
assert exit_record['exit_code'] == 0
for item in result['syntax_files']:
    assert entry(Path(item['path']))['sha256'] == item['sha256']
assert len(result['negative_controls']) == 8 and all(item['rejected'] for item in result['negative_controls'])
original = SESSION / 'close-adjudicated-reused-row.py'
assert entry(original)['sha256'] == 'ae9e420839ba0d4561312c7579eecb9fe33004a88a269b48976cbd5d4b8ce76f'
audit = SESSION / 'audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness'
pinned = {
    audit / 'decision.json': '923861c4036334a4c9cff5e5ebb3f3ffc9329c40c1fab4f1f0ad9559a0c58b53',
    audit / 'manifest.json': '6698cd2c6c95a98f5b117005dcf11f9f2e0addb1dd79066e0c86751d2442720b',
    SESSION / 'smooth-bridge-strengthening-evidence.json': 'da9c905658fa2c02bf375df219fb7c9718fca8cc4c1c0e92b232da103f6274d7',
}
for path, expected in pinned.items():
    assert entry(path)['sha256'] == expected
excluded = {'final-receipt.json', 'freeze-output.txt', 'freeze-exit.json'}
receipt = {
    'scope': 'Additive strict smooth-bridge stronger adapter and local closed-row validator only',
    'scripts': result['syntax_files'],
    'unchanged_equivalent_adapter': entry(original),
    'pinned_inputs': [entry(path) for path in pinned],
    'original_validator': entry(HERE / 'validate-closed-row-audits-before.py'),
    'check_actual_exit_code': exit_record['exit_code'],
    'negative_controls_passed': 8,
    'adapter_main_invoked': False,
    'validator_main_invoked': False,
    'gate_or_audit_mutation_performed': False,
    'artifacts': [entry(path) for path in sorted(HERE.iterdir()) if path.is_file() and path.name not in excluded],
    'limits': 'Only read-only syntax/evidence/helper validation was run; root must execute complete validation and gate closure. Other stronger tasks are rejected.',
}
(HERE / 'final-receipt.json').write_bytes((json.dumps(receipt, indent=2) + '\n').encode('utf-8'))
print(json.dumps({'scripts': receipt['scripts'], 'receipt': entry(HERE / 'final-receipt.json'),
                  'review': entry(HERE / 'review.md')}, indent=2))
