"""Verify the frozen review packet without operating on runtime or refs."""
from pathlib import Path
import hashlib, json
P = Path(__file__).resolve().parent
def hashfile(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p, v): p.write_text(json.dumps(v, indent=2) + '\n', encoding='utf-8', newline='\n')
receipt = json.loads((P / 'final-receipt.json').read_bytes())
bindings = json.loads((P / 'observed-bindings.json').read_bytes())
checked = []
for pin in receipt['artifacts'] + bindings['released_and_preparation_inputs']:
    p = Path(pin['path'])
    assert hashfile(p) == pin['sha256'], p
    assert p.stat().st_size == pin['bytes'], p
    checked.append(pin)
assert receipt['help_commands_actual_exit_codes'] == [0, 0, 0, 0]
assert not receipt['candidate_created'] and not receipt['epoch_validated']
assert not receipt['gate_mutated'] and not receipt['protected_ref_changed']
assert not receipt['acceptance_or_promotion_claimed']
# Preserve the frozen review bytes and correct only two nonsemantic line locators.
corrections = {
    'review_sha256': hashfile(P / 'REVIEW.md'),
    'changes': [
        {'reported': 'build-reconciliation-asset-inventory.py, lines 30-31',
         'correct': 'build-reconciliation-asset-inventory.py, lines 27-28',
         'meaning_unchanged': 'Inspection head must equal shared anchor; actual assertion is false for the observed topology.'},
        {'reported': 'reconciliation.py, lines 726-729, 882-894 and 897-919',
         'correct': 'reconciliation.py, lines 723-726, 883-895 and 905-918',
         'meaning_unchanged': 'Both external receipt checks receive the current epoch topology hash.'},
    ],
}
assert not (P / 'code-locator-corrections.json').exists()
dump(P / 'code-locator-corrections.json', corrections)
result = {
    'status': 'PASS-READ-ONLY-REVIEW-VERIFICATION', 'binding_occurrences': len(checked),
    'unique_paths': len({p['path'] for p in checked}),
    'final_receipt_sha256': hashfile(P / 'final-receipt.json'),
    'review_sha256': hashfile(P / 'REVIEW.md'),
    'commands_sha256': hashfile(P / 'commands.review-only.json'),
    'code_locator_corrections_sha256': hashfile(P / 'code-locator-corrections.json'),
    'verification_script_sha256': hashfile(Path(__file__)),
    'help_actual_exit_codes': [0, 0, 0, 0],
    'live_runtime_state_not_asserted_current': True,
    'candidate_epoch_or_admission_executed': False,
}
assert not (P / 'verification.json').exists()
dump(P / 'verification.json', result)
print(json.dumps(result))
