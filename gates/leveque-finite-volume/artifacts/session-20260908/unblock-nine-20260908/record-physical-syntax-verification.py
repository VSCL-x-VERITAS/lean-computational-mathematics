"""Append the actual syntax/checker finding without changing source acceptance."""
from pathlib import Path
import hashlib, json, os
assert os.name == 'posix'
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
read = lambda p: json.loads(p.read_bytes())
def create(p, obj):
    with p.open('xb') as f:
        f.write((json.dumps(obj, indent=2) + '\n').encode())
bound = {
 'physical-production-promotion/layout-rhs-parentheses-01/receipt.json': '43f3b06844b9d3c79f5189015c839575f4dcb5b15fc47f796f6f183574c09ab9',
 'physical-production-promotion/owners-native-04-receipt.json': '85cd930067a2e115ff1434ebbe633a09344332edf9e31b6708602537364b763c',
 'physical-syntax-fingerprints/final-receipt.json': '2b0b08ccf1fe57558f21263a28550ee5627c61c515ef96d805e7a74c59abaf3d',
 'physical-syntax-fingerprints/structural-equality.json': '6ae4fed4a81f835ae87257659c61b9b3df5af3df991da5e29dc6adfe9298097e',
 'physical-dim-audit-preparation/final-receipt.json': '1ddb1a6c2eb4efe6a1cf66c17e51ea77219c173f64a47b294daf86e9ec10ec28'}
for p, h in bound.items(): assert sha(D / p) == h
build = read(D / 'physical-production-promotion/owners-native-04-receipt.json')
assert build['actual_exit_code'] == 0 and build['sources_unchanged']
for item in build['input_sources']: assert sha(R / item['path']) == item['sha256']
fp = read(D / 'physical-syntax-fingerprints/final-receipt.json')
assert fp['record_list_exactly_unchanged'] and fp['all_source_olean_head_postchecks_passed']
checks = []
for label, expected in [('layout', 1), ('layout-02', 0), ('hygiene-02', 0), ('source-graphs', 0)]:
    p = S / ('unblock-nine-physical-current-' + label + '-exit.json')
    rec = read(p)
    assert rec['exit_code'] == expected
    output = p.with_name(p.name.replace('-exit.json', '-output.txt'))
    assert sha(output) == rec['output_sha256']
    checks.append({'receipt': ref(p), 'output': ref(output), 'actual_exit_code': expected})
ledger = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(ledger) == 'a46048d661a8300c87f11581e0f910f04c22ea1d36510d5c4f360837669aee63'
gate = R / 'gates/leveque-finite-volume/chapter-01.json'
assert sha(gate) == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
out = D / 'physical-syntax-verification-milestone'
out.mkdir(exist_ok=False)
diagnosis = {
 'format': 'physical-syntax-verification-milestone-1',
 'evidence': [ref(D / p) for p in bound], 'checks': checks,
 'finding': 'The unchanged layout checker matched a multiplication continuation beginning with the variable constant as if it were a Lean constant command.',
 'repair': 'Parenthesize exactly that right-hand-side expression; keep the released validator unchanged and preserve the original exit-one run.',
 'semantic_verification': 'Native build04 passes. All 83 eligible declarations in PhysicalRefinementQuality have exactly equal structural records before and after the parentheses; all 1688 consolidated records remain identical.',
 'current_checks': 'Layout02, placeholder hygiene02 and strict source graphs actually exit zero. The exact current inventory covers 1688 declarations and 183 owners.',
 'audit_preparation': 'Five current native probes and the pure POSIX audit-spec preflight exit zero; these establish no semantic role verdict.',
 'gate': ref(gate), 'closed_rows_unchanged': 39, 'newly_closed_rows': 0,
 'source_acceptance': False, 'released_validator_changes': False}
create(out / 'diagnosis.json', diagnosis)
evidence = ref(out / 'diagnosis.json')
entry = '| LEV-SKILL-PHYSICAL-LAYOUT-SYNTAX-100 | codex-start-1-v5-0-1-20260908 | Layout false positive on formula continuation | A line beginning with the variable constant matched the unchanged placeholder detector | Parenthesize the exact RHS; preserve the original failure; actual native build04 and layout02/hygiene02/source-graphs pass, with all 83 owner records and all 1688 consolidated records unchanged | Checker issue RESOLVED; independent source audit and closure remain ACTIVE | ' + evidence['path'] + ' SHA256 ' + evidence['sha256'] + ' | No released validator was changed, no axiom or placeholder was introduced, and no source row was closed by native or structural equality evidence. |\n'
prior = ledger.read_bytes()
assert prior.endswith(b'\n') and b'LEV-SKILL-PHYSICAL-LAYOUT-SYNTAX-100' not in prior
with ledger.open('ab') as f: f.write(entry.encode())
assert ledger.read_bytes().startswith(prior)
assert sha(gate) == diagnosis['gate']['sha256']
receipt = {'diagnosis': evidence, 'ledger_before_sha256': hashlib.sha256(prior).hexdigest(),
           'ledger_after': ref(ledger), 'gate_unchanged': ref(gate)}
create(out / 'receipt.json', receipt)
print(json.dumps(receipt))

