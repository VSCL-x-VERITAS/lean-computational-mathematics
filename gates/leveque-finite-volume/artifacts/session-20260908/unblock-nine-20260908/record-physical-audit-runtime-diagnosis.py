"""Append the tested audit-runtime diagnosis without claiming source acceptance."""
from pathlib import Path
import hashlib
import json
import os

assert os.name == 'posix'
D = Path(__file__).resolve().parent
S = D.parent
R = next(p for p in D.parents if (p / 'lakefile.toml').exists())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
pins = {
    D / 'physical-dim-overlay-diagnostic/overlay01/receipt.json': '3b93bf6c23856bab231e1a15f239c07598208c948ba575370671e0d876f396d7',
    D / 'physical-dim-overlay-diagnostic/closure01/receipt.json': 'f69ea636a2cd52e61c9d2657fe4cd4ee14d3827589f408a0cfb8d52175126086',
    D / 'physical-dim-package-command-preparation/diagnostic-receipt.json': '5a87a723bca4b8fef7fbd68b9c611eb498fa6fba0ad8ec8cdc0fa025a994da0e',
    D / 'physical-failed-preparation-module-order.json': '182e24a56efb9d11e1dbc69611a9e86b2ec46222845e977471902e7a173d64c1',
    S / 'audits/LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908/prepare-stderr.txt': 'dc09b60e53e497aa1874b6924dd1bc02da5c8c793c073c1e2c9ffb39e839c4d3'}
for p, h in pins.items():
    assert sha(p) == h, p.name
overlay = json.loads((D / 'physical-dim-overlay-diagnostic/overlay01/receipt.json').read_bytes())
assert overlay['canonical_pins_unchanged'] and overlay['dossier_helper_unchanged']
assert [r['exit_code'] for r in overlay['records']] == [0, 0, 0, 0, 1, 1]
assert not overlay['official_preparation'] and not overlay['audit_roles'] and not overlay['source_acceptance']
ledger = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(ledger) == 'bf0602ffa0ac56921080c8e7a3eb07216c0eb23f6d56820df4b842b829dbea0c'
gate = R / 'gates/leveque-finite-volume/chapter-01.json'
assert sha(gate) == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
out = D / 'physical-audit-runtime-diagnosis'
out.mkdir(exist_ok=False)
diagnosis = {
    'kind': 'actual-physical-audit-runtime-diagnosis',
    'evidence': [ref(p) for p in pins],
    'failure': 'The fresh released preparation failed while compiling the exact FTaylor source outside its Mathlib package options. Lake also placed cached package roots ahead of the injected audit build root.',
    'tested_repair': 'Use the pinned native Lean executable with the actual package options only for the two pinned Mathlib modules, and a complete actual compiled Mathlib closure overlay ahead of cached roots. Detach temporary hardlinks for every output sibling before compiling.',
    'actual_validation': 'Exact Defs, FTaylor, consumer and unchanged dossier all exit zero in the released module order. Two missing-overlay-artifact dossier probes each exit one on the exact temporary module path. All 9508 canonical artifact hashes and source/binary pins remain unchanged.',
    'limits': 'The supported command adapter and fresh official audit still require execution. This successful runtime diagnostic is neither a source-faithfulness judgment nor closure.',
    'private_evidence': 'The raw complete environment capture remains private and is exactly excluded by publication policy; no contents reproduced here.',
    'released_validators_changed': False, 'source_rows_closed': 0, 'gate': ref(gate)}
def create(p, obj):
    with p.open('xb') as f:
        f.write((json.dumps(obj, indent=2) + '\n').encode())
create(out / 'diagnosis.json', diagnosis)
entry = '| LEV-SKILL-PHYSICAL-AUDIT-RUNTIME-101 | codex-start-1-v5-0-1-20260908 | Exact Mathlib audit snapshot runtime | Released preparation did not supply package options; Lake prioritized cached package roots over the injected audit root | Preserve the failure and limited diagnostics; exact package options plus direct pinned Lean and a complete temporary dependency overlay pass positive and negative dossier tests, with all canonical cache pins unchanged | Runtime repair TESTED; supported adapter and independent audit remain IN_PROGRESS | ' + ref(out / 'diagnosis.json')['path'] + ' SHA256 ' + sha(out / 'diagnosis.json') + ' | No released validator, production source or audit verdict changed; raw full environment evidence stays private. |\n'
prior = ledger.read_bytes()
assert prior.endswith(b'\n') and b'LEV-SKILL-PHYSICAL-AUDIT-RUNTIME-101' not in prior
with ledger.open('ab') as f:
    f.write(entry.encode())
assert ledger.read_bytes().startswith(prior) and sha(gate) == diagnosis['gate']['sha256']
create(out / 'receipt.json', {'diagnosis': ref(out / 'diagnosis.json'),
    'ledger_before_sha256': hashlib.sha256(prior).hexdigest(), 'ledger_after': ref(ledger),
    'gate_unchanged': ref(gate)})
print(json.dumps({'receipt': ref(out / 'receipt.json'), 'ledger': ref(ledger)}))
