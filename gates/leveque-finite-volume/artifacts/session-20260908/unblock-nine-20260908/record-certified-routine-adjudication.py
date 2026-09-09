"""Retain genuine unaccepted adjudication and its transport recovery."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
task = S / 'audits/LEV-CH01-CERTIFIED-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908'
out = task / 'faithfulness'
recovery = D / 'adjudicator-transport-recovery-v3/certified-routine-plan-01'
actual = read(recovery / 'execution-receipt.json')
assert actual['exit_code'] == 0 and actual['original_role_run_exit_code'] == 1
assert actual['released_complete_validation_exit_code'] == 0
assert [step['name'] for step in actual['steps']] == ['native-adjudicator', 'collect', 'finalize', 'complete-validation']
assert all(type(step['exit_code']) is int and step['exit_code'] == 0 for step in actual['steps'])
decision = read(out / 'decision.json')
assert sha(out / 'decision.json') == '0ac08662a5a89231c70add2f6706e855f86704a7d57206cff558d8f2addd0308'
assert decision['classification'] == 'undetermined' and decision['accepted'] is False and decision['adjudicated'] is True
assert read(task / 'role-run-receipt.json')['exit_code'] == 1
folder = D / 'certified-routine-adjudication-diagnosis'
folder.mkdir()
record = {'format': 'completed-unaccepted-certified-routine-audit-1',
    'recorder': ref(Path(__file__)), 'decision': ref(out / 'decision.json'),
    'manifest': ref(out / 'manifest.json'), 'adjudicator': ref(out / 'agent_outputs/adjudicator.json'),
    'original_wrapper': ref(task / 'role-run-receipt.json'), 'original_wrapper_exit_code': 1,
    'recovery': ref(recovery / 'execution-receipt.json'), 'recovery_plan': ref(recovery / 'plan.json'),
    'root_transport_review': ref(recovery / 'ROOT-REVIEW.md'),
    'classification': 'undetermined', 'accepted': False,
    'mechanical_complete_validation_exit_code': 0, 'gate_rows_closed': 0,
    'open_findings': decision['remaining_uncertainties'],
    'next_work': ['Supply the actual earlier hyperbolicity definition as inherited source context.',
        'Obtain an explicit interpretation of representative and solver-certificate scope; preserve source ambiguity.',
        'Prepare and independently audit a successor only after the applicable interpretation is actually recorded.'],
    'pending_user_question': 'For the remaining Riemann-interface audit, should I explicitly interpret a certified approximate solver as providing, for every admitted problem, a reference representative that satisfies rectangle conservation using its actual endpoint flux values, together with a numerical-flux error bound? This is the concrete contract that now compiles. The independent adjudicator found that the printed source and earlier answers leave this representative and certificate convention unresolved; I would preserve that source ambiguity.',
    'user_answer_recorded': False,
}
with (folder / 'diagnosis.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2, ensure_ascii=False) + '\n').encode())
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == 'c868349f2cbae836b7a60b8978bf813ffc972467c7c1737968a5e1dd27f9180a'
assert sha(process) == '5294998179c020e6965b6b0a4f3d7a5ec680ba6176de561ec22c4fd297601a48'
loc = (folder / 'diagnosis.json').relative_to(R).as_posix() + ' SHA256 ' + sha(folder / 'diagnosis.json')
entries = {
    book: '| LEV-C1-CERTIFIED-ROUTINE-DOMAIN-110 | LEV-CH01-RIEMANN-INTERFACE-FLUX | completed independent adjudication | The repaired numerical-error contract passes native checks but its final source audit is undetermined on law/reference and certificate applicability | Add the earlier hyperbolicity definition as inherited context and obtain the explicit representative/certificate interpretation requested from the user | IN_PROGRESS; final accepted=false, both implications unclear | ' + loc + ' | The adjudicator resolved operator semantics and substantive nonvacuity. No error formula, convergence guarantee, universal solution existence or representative convention is silently attributed to the book. |',
    process: '| LEV-SKILL-CERTIFIED-ADJUDICATOR-CAPACITY-095 | codex-start-1-v5-0-1-20260908 | native adjudicator input capacity | Original 1532185-character adjudicator input exceeded the 1048576-character limit before a turn started | Root-reviewed unchanged V3 transport retains the full dossier and reconstructs all original bytes from exact duplicate references and JSON whitespace compaction; fresh a2 is stateless | Native adjudicator, collection, released finalization and complete validation all exited 0; final source decision remains unaccepted | ' + loc + ' | Original wrapper remains exit 1. Recovered input has 980780 characters. Technical completion is not source acceptance; all five original/final role histories and failed capacity attempt remain preserved. |'
}
receipt = {'diagnosis': ref(folder / 'diagnosis.json'), 'ledgers': []}
for path, entry in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and entry.split('|')[1].strip().encode() not in raw
    with path.open('ab') as stream:
        stream.write((entry + '\n').encode())
    assert path.read_bytes().startswith(raw)
    receipt['ledgers'].append({'before_sha256': hashlib.sha256(raw).hexdigest(), 'after': ref(path), 'entries_appended': 1})
with (folder / 'receipt.json').open('xb') as stream:
    stream.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
