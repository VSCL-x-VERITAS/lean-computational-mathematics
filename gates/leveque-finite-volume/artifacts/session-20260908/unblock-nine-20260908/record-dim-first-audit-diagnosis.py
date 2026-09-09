"""Record actual first-run transport failure and open semantic findings."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
task = S / 'audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
orch = task / 'faithfulness/orchestration'
original = read(task / 'role-run-receipt.json')
assert original['exit_code'] == 1
prompt = orch / 'd_input.txt'
assert sha(prompt) == '75b4f0d1728d1f55a608088eb421f3a5fab3f1e0b3555b7acf6940c0817cd53a'
text = prompt.read_text(encoding='utf-8')
assert len(text) == 1442614
events = [json.loads(line) for line in (orch / 'd_events.jsonl').read_text(encoding='utf-8').splitlines() if line.strip()]
assert not any(event.get('type') == 'turn.started' for event in events)
assert not (orch / 'd_final.json').exists()
roundtrip = read(orch / 'r_final.json')
assert roundtrip['classification'] == 'undetermined' and roundtrip['accepted'] is False
source = R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/LocalRectangleReference.lean'
defs = R / '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff/Defs.lean'
assert sha(source) == 'ae786e24dc4689fd996b6ed1a868f143e307d32e6b3c2bce8fc3998fd7794067'
assert source.read_text(encoding='utf-8').count('ContDiffOn ℝ ⊤') == 2
assert 'we denote `(⊤ : ℕ∞) : WithTop ℕ∞` with `∞`, and `⊤ : WithTop ℕ∞` with `ω`' in defs.read_text(encoding='utf-8')
out = D / 'dim-first-audit-diagnosis'
out.mkdir()
for name, path in [('LocalRectangleReference.audited.lean', source), ('roundtrip-original-final.json', orch / 'r_final.json')]:
    with (out / name).open('xb') as stream:
        stream.write(path.read_bytes())
record = {
    'format': 'dim-first-audit-open-findings-1', 'recorder': ref(Path(__file__)),
    'original_wrapper': ref(task / 'role-run-receipt.json'), 'original_wrapper_exit_code': 1,
    'direct_prompt': ref(prompt), 'direct_input_characters': len(text),
    'native_input_limit': 1048576, 'direct_turn_started': False,
    'direct_events': ref(orch / 'd_events.jsonl'),
    'roundtrip_native_final': ref(orch / 'r_final.json'),
    'roundtrip_classification': 'undetermined', 'final_task_decision': None,
    'audited_definition': ref(source), 'pinned_mathlib_definition': ref(defs),
    'independent_root_observation': 'Both smooth-reference predicates use outer-top WithTop ENat, which pinned Mathlib defines as analytic-strength omega. The adopted smooth-solution convention did not impose analyticity. Minimal smooth-infinity repair is under independent review.',
    'other_open_findings': ['Elided stability witness in blind evidence', 'Effective geometry-domain coverage', 'Conditional accuracy scope'],
    'recovery_scope': 'Lossless direct transport with fresh stateless role; preserve failed originals and complete current audit honestly before successor acceptance.',
    'source_acceptance': False, 'production_modified': False,
    'gate_rows_closed_by_this_record': 0,
}
with (out / 'diagnosis.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2, ensure_ascii=False) + '\n').encode())
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == '55db0509b8eadc5a9904df5f1022c7ca593a7bc8e215173a82f15a64d9b6eea5'
assert sha(process) == '583bb6b480eb9ebeb12a35a284b37824041033ad46149d318ea87266e0e0dbce'
loc = (out / 'diagnosis.json').relative_to(R).as_posix() + ' SHA256 ' + sha(out / 'diagnosis.json')
entries = {
    book: '| LEV-C1-HIGH-RESOLUTION-SMOOTH-DOMAIN-109 | LEV-CH01-DIMENSIONAL-SPLITTING | interpreted smooth-reference domain | Original round-trip result is undetermined; current smooth-reference predicates use analytic-strength outer top in pinned Mathlib | Diagnose and repair smooth-infinity meaning; resolve effective geometry and stability evidence under the recorded convention | IN_PROGRESS; no accepted final task decision | ' + loc + ' | This is a formalization/domain issue, not a claim that the printed book is false. The user high-resolution adoption remains unchanged; original source ambiguity and all audit inputs are retained. |',
    process: '| LEV-SKILL-DIM-DIRECT-INPUT-CAPACITY-094 | codex-start-1-v5-0-1-20260908 | native direct-role input capacity | The original direct prompt has 1442614 characters above the 1048576 native limit; no direct turn started, and original wrapper exited 1 | Prepare lossless evidence transport with exact reconstruction and fresh stateless direct role; retain original events and receipt | Recovery preparation in progress; no semantic verdict inferred from transport failure | ' + loc + ' | Source and blind collection completed; native round-trip output is undetermined and remains to be collected through the proper continuation. No audit acceptance or gate closure is fabricated. |'
}
receipt = {'diagnosis': ref(out / 'diagnosis.json'), 'ledgers': []}
for path, entry in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and entry.split('|')[1].strip().encode() not in raw
    with path.open('ab') as stream:
        stream.write((entry + '\n').encode())
    assert path.read_bytes().startswith(raw)
    receipt['ledgers'].append({'before_sha256': hashlib.sha256(raw).hexdigest(), 'after': ref(path), 'entries_appended': 1})
with (out / 'receipt.json').open('xb') as stream:
    stream.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
