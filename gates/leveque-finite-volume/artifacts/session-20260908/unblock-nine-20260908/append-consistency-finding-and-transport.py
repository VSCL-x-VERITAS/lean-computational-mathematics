"""Preserve the completed restrictive-interface verdict and verified recovery history."""
from pathlib import Path
import hashlib, json
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
loc = lambda p: p.relative_to(R).as_posix() + ' SHA256 ' + sha(p)
decision_path = S / 'audits/LEV-CH01-LOCAL-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/decision.json'
assert sha(decision_path) == 'afc764d552b0f3ee9739eea5ec2a5377d1718635410c12bd957f444ac947178c'
decision = read(decision_path)
assert decision['classification'] == 'not-faithful-weaker' and not decision['accepted']
assert decision['implications']['lean_implies_source']['verdict'] == 'no'
assert decision['implications']['source_implies_lean']['verdict'] == 'yes'
recovery_path = D / 'adjudicator-transport-recovery/info-a2-v2/execution-receipt.json'
recovery = read(recovery_path)
assert recovery['exit_code'] == 0 and recovery['original_role_run_exit_code'] == 1
assert recovery['decision']['sha256'] == sha(decision_path)
assert [step['exit_code'] for step in recovery['steps']] == [0, 0, 0, 0]
assert recovery['released_complete_validation_exit_code'] == 0
plan_path = D / 'adjudicator-transport-recovery/info-a2-v2/plan.json'
plan = read(plan_path)
assert plan['mapping']['reconstruction_byte_equal']
assert plan['mapping']['compact_characters'] == 1020403
assert plan['mapping']['original_characters'] == 1284723
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
entries = {
    book: ['| LEV-C1-EXACT-CONSISTENCY-101 | LEV-CH01-RIEMANN-INTERFACE-FLUX | extra exact equal-state hypothesis | Completed independent adjudication rejects the Method target because exact consistency excludes a biased flux with finite permitted error | Add a Routine interface with optional consistency, direct independent physical-error bounds, local neighboring states and a separate conditional reference comparison | IN_PROGRESS; old not-faithful-weaker verdict retained | ' + loc(decision_path) + ' | The adjudicator accepts the conditional capability/domain interpretation under Q7; no unconditional physical-solution existence claim is required. |'],
    process: ['| LEV-SKILL-LOSSLESS-DOCUMENT-TRANSPORT-082 | codex-start-1-v5-0-1-20260908 | adjudicator input size | Actual native input exceeded 1048576 characters before any role turn; JSON whitespace compaction was insufficient | Replace only the duplicate direct-review packet by an exact internal reference to the same contiguous bytes already present in the complete declaration dossier | Exact original reconstruction verified; fresh adjudicator, collector, finalizer and released complete validation all exited zero | ' + loc(recovery_path) + ' | Both complete dossiers and all JSON remain verbatim; the original failed wrapper and attempt are unchanged. Semantic rejection was not altered by transport recovery. |']}
receipt = {'schema': 1, 'decision': loc(decision_path), 'recovery': loc(recovery_path), 'ledgers': []}
for path, additions in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n')
    assert all(row.split('|')[1].strip().encode() not in raw for row in additions)
    before = sha(path)
    with path.open('ab') as handle:
        handle.write(('\n'.join(additions) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    receipt['ledgers'].append({'path': path.relative_to(R).as_posix(), 'before_sha256': before, 'after_sha256': sha(path), 'appended_entries': len(additions)})
with (D / 'consistency-finding-and-transport-ledger-receipt.json').open('xb') as handle:
    handle.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
