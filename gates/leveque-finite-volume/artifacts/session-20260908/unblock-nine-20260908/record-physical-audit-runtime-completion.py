"""Record actual successful snapshot preparation without projecting an audit verdict."""
from pathlib import Path
import hashlib
import json
import os

assert os.name == 'posix'
D = Path(__file__).resolve().parent
S = D.parent
R = next(p for p in D.parents if (p / 'lakefile.toml').exists())
T = S / 'audits/LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
pins = {
    T / 'route-exit.json': 'cdd178a09665171ec0c71942391029b678ee0831b4b2664c144cdc654f170670',
    T / 'prepare-exit.json': '3e004351792b1f78decf700fcb7c550615c26c6dc008ed42dc382a9d53ae89c5',
    T / 'prepared-validation-exit.json': '7a434e951e091473493204b877beb9c94318920ef5e2ae4191af23000ce06a22',
    D / 'prepare-successor-audit-with-package-command-v1.py': '1540dee9865e2f324ff4f2bf648464b21c827bbda4eccbb3e484d685aa7cdf49',
    D / 'physical-dim-package-runtime-preparation/lean_runtime.py': 'eb55c9b705eeb94a1dc956a667bba70f7ce065cfc0d3b0d6d9a5ed07469dd9a1',
}
for p, h in pins.items():
    assert sha(p) == h, p
for label in ('route', 'prepare', 'prepared-validation'):
    rec = json.loads((T / (label + '-exit.json')).read_bytes())
    assert rec['exit_code'] == 0
    assert sha(T / (label + '-output.txt')) == rec['stdout_sha256']
    assert sha(T / (label + '-stderr.txt')) == rec['stderr_sha256']
postchecks = sorted((T / 'compiler-command-records').rglob('*-postcheck.json'))
assert len(postchecks) == 43
finals = []
for p in postchecks:
    rec = json.loads(p.read_bytes())
    assert rec['completed'] is True and rec['native_exit_code'] == 0
    native = p.parent / rec['native_record']
    assert sha(native) == rec['native_record_sha256']
    if 'all_expected_snapshots_fresh' in rec:
        assert rec['all_expected_snapshots_fresh'] == 42
        assert rec['final_original_pins_unchanged'] is True
        finals.append(ref(p))
assert len(finals) == 1
ledger = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(ledger) == '9a970e1321ba4f5c132c6adc8bce7328bab06d777a6918d875a48ab727f62f04'
gate = R / 'gates/leveque-finite-volume/chapter-01.json'
assert sha(gate) == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
dest = D / 'physical-audit-runtime-completion'
dest.mkdir(exist_ok=False)
def create(p, obj):
    with p.open('xb') as f:
        f.write((json.dumps(obj, indent=2) + '\n').encode())
result = {
    'kind': 'actual-physical-audit-runtime-completion',
    'evidence': [ref(p) for p in pins],
    'final_compiler_postcheck': finals[0],
    'actual_successful_snapshot_compiles': 42,
    'actual_dossier_exit_code': 0,
    'actual_route_prepare_validation_exit_codes': [0, 0, 0],
    'all_original_compiler_pins_unchanged': True,
    'resolution': 'The supported native package-command adapter completed the official released preparation, including both exact Mathlib calculus sources, all local snapshots and the dossier. The released prepared validator also passed. The historical failing attempt and diagnostic limitations remain intact.',
    'limits': 'Source and blind roles have started separately. No semantic acceptance or source-row closure follows from this runtime result.',
    'released_validators_changed': False,
    'gate_unchanged': ref(gate),
}
create(dest / 'result.json', result)
entry = '| LEV-SKILL-PHYSICAL-AUDIT-RUNTIME-COMPLETION-102 | codex-start-1-v5-0-1-20260908 | Official audit snapshot runtime completion | Runtime repair in entry 101 still required execution through the released preparation and validation | The supported native command completed all 42 snapshot compilations and the dossier; original compiler pins remained unchanged; routing, preparation and prepared validation all returned zero | Runtime repair RESOLVED; independent semantic audit IN_PROGRESS | ' + ref(dest / 'result.json')['path'] + ' SHA256 ' + sha(dest / 'result.json') + ' | No released validator or mathematical source changed; no audit verdict inferred. |\n'
prior = ledger.read_bytes()
assert prior.endswith(b'\n') and b'LEV-SKILL-PHYSICAL-AUDIT-RUNTIME-COMPLETION-102' not in prior
with ledger.open('ab') as f:
    f.write(entry.encode())
assert ledger.read_bytes().startswith(prior) and sha(gate) == result['gate_unchanged']['sha256']
create(dest / 'receipt.json', {'result': ref(dest / 'result.json'), 'ledger_before_sha256': hashlib.sha256(prior).hexdigest(), 'ledger_after': ref(ledger), 'gate_unchanged': ref(gate)})
print(json.dumps({'receipt': ref(dest / 'receipt.json'), 'ledger': ref(ledger)}))
