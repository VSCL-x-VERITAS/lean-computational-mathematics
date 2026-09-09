"""Record actual canonical verification and measured exposure; do not close source rows."""
from pathlib import Path
import hashlib, json, os

assert os.name == 'posix', 'Run through the prepared workflow launcher'
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
pin = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
read = lambda p: json.loads(p.read_bytes())
def create(p, obj):
    with p.open('xb') as stream:
        stream.write((json.dumps(obj, indent=2, ensure_ascii=False) + '\n').encode())

bound = {
    'physical-production-promotion/owners-native-03-receipt.json': '662dfeb7725a719f41547caab64d62b321a4c6642ae4712fbd2d5de2b58d0abb',
    'physical-canonical-checks/verified-01/receipt.json': '9a02c5d4eb91932313056f2a2784ab245a7195aded551ff5cfcb79324426e05f',
    'physical-dim-canonical-comparisons/final-receipt.json': 'af3f15a66ff75022171e3c348e5b1d4aa866d56c8cd4577860bab7b1dfd29c9d',
    'physical-organization-exposure-preparation/applied-01/receipt.json': '4215fd02e7f28e1d94295bab2102c61239b360075490d23ccb8d8e306505b575',
    'physical-organization-exposure-preparation/stage-01/receipt.json': '70698c9a870f0e05527366fd1fe4f31f358a83788dde96faf7e74a6485c2ef15'}
for name, digest in bound.items():
    assert sha(D / name) == digest
build = read(D / 'physical-production-promotion/owners-native-03-receipt.json')
assert build['actual_exit_code'] == 0 and build['sources_unchanged']
for item in build['input_sources']:
    assert sha(R / item['path']) == item['sha256']
reports = read(D / 'physical-canonical-checks/verified-01/receipt.json')
assert reports['all_reports_permitted']
assert [x['verified_count'] for x in reports['checks']] == [169, 14, 10, 18]
comparison = read(D / 'physical-dim-canonical-comparisons/final-receipt.json')
assert [x['actual_exit_code'] for x in comparison['native_outcomes']] == [0, 0]
assert [x['declaration_count'] for x in comparison['native_outcomes']] == [56, 14]
checks = [S / ('unblock-nine-physical-current-' + label + '-exit.json')
          for label in ('tiers', 'organization-preflight', 'source-inventory')]
for path in checks:
    item = read(path)
    assert item['exit_code'] == 0
    assert sha(path.with_name(path.name.replace('-exit.json', '-output.txt'))) == item['output_sha256']
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(gate_path) == 'fa5e67b0b0052056c887d6f84a47119208503b755be6e646871d7ffaee9816c8'
assert sha(book) == '7298ceac66b944384ea051ab2b0114417474bdd13f23ea44de6e7167c753ef66'
assert sha(process) == '350cdb6ed3acb1c5004ba016174c2357e8f517399e3c5c876e74466f167c957b'
before = gate_path.read_bytes()
gate = json.loads(before)
old_rows = json.loads(json.dumps(gate['rows']))
out = D / 'canonical-physical-verification-milestone'
out.mkdir(exist_ok=False)
diagnosis = {
    'format': 'canonical-physical-verification-milestone-1',
    'evidence': [pin(D / name) for name in bound], 'mechanical_checks': [pin(p) for p in checks],
    'canonical_build': 'All sixteen physical owner modules compile after two direct-import repairs; old failed builds remain unchanged.',
    'public_declarations': '169 explicit current declarations and 14/10/18 narrow import checks have exact permitted axiom reports.',
    'nominal_transport': '56 explicit old/new scratch-to-canonical comparison declarations preserve field maps, C/N certificates, quality, methods and intermediate execution; complete specification producers transport the Prop contracts.',
    'canonical_joint': '14 canonical-only declarations instantiate the complete admitted source contract at every growing Cartesian level with a nonconstant genuine smooth reference and measured boundary means.',
    'exposure': 'Twelve new reusable leaves are actually staged, exposed by Analysis and classified; measured current tier census is 6024 modules, 705 reusable, 5009 exact/27 prefix rules, zero mixed/unclassified.',
    'parser_correction': 'Initial result validation mishandled displayed universe suffixes on permitted axiom names. Separate validation normalizes only those suffixes against saved actual exit-zero native outputs; all initial parser failures are preserved.',
    'source_acceptance': False, 'newly_closed_rows': 0,
    'pending_work': 'Current fingerprints, independent fresh source audit, full organization and final closure remain actionable. Riemann representative/certificate interpretation question remains unanswered.'}
create(out / 'diagnosis.json', diagnosis)
where = (out / 'diagnosis.json').relative_to(R).as_posix() + ' SHA256 ' + sha(out / 'diagnosis.json')
entries = {
    book: '| LEV-C1-CANONICAL-PHYSICAL-PRIMARY-114 | LEV-CH01-DIMENSIONAL-SPLITTING | Canonical admitted physical high-resolution contract | The former source audit is unaccepted and cannot close the revised physical contract | All canonical owners, nominal data/certificate transports and complete growing-family source application compile; original source ambiguity and adopted convention remain separate | IN_PROGRESS; fresh source acceptance pending | ' + where + ' | Preserve the actual measured-geometry Q10 scope and independent stability premise. Source faithfulness still requires a fresh audit of the current target and complete definition domains. |',
    process: '| LEV-SKILL-CANONICAL-PHYSICAL-VERIFICATION-099 | codex-start-1-v5-0-1-20260908 | Canonical relocation and result-parser repair | Extracted modules required direct Real and ContDiffOn imports; the report parser did not remove displayed axiom universe suffixes | Preserve both failed native builds and initial parser failures; actual native build0, 169 declarations, three import checks, 56 transport and 14 joint declarations verified with current pins | Native verification COMPLETE; fresh audit and final organization ACTIVE | ' + where + ' | No theorem placeholder was authored. Two comparison-only unused section-variable warnings are retained. Actual measured exposure is 6024 modules; no queued audit, checkpoint or source PASS is invented. |'}
result = {'diagnosis': pin(out / 'diagnosis.json'), 'ledgers': []}
for path, entry in entries.items():
    prior = path.read_bytes()
    assert prior.endswith(b'\n') and entry.split('|')[1].strip().encode() not in prior
    with path.open('ab') as stream:
        stream.write((entry + '\n').encode())
    assert path.read_bytes().startswith(prior)
    result['ledgers'].append({'before_sha256': hashlib.sha256(prior).hexdigest(), 'after': pin(path)})
for row in gate['rows']:
    if row['id'] == 'LEV-CH01-DIMENSIONAL-SPLITTING':
        assert row['status'] == 'IN_PROGRESS'
        row['current_target'] = 'Independently audit the verified canonical admitted physical high-resolution coordinate source contract under the recorded convention.'
        row['next_action'] = 'Freeze current structural fingerprints and proof-free native definition/domain evidence, prepare a fresh context-qualified audit with exact Mathlib smoothness definitions, complete independent roles, and bind only an accepted final decision.'
assert sum(row['status'] in {'PROVED', 'REUSED'} for row in gate['rows']) == 39
for old, new in zip(old_rows, gate['rows']):
    if old['id'] != 'LEV-CH01-DIMENSIONAL-SPLITTING':
        assert old == new
    else:
        assert {k: v for k, v in old.items() if k not in {'current_target', 'next_action'}} == {k: v for k, v in new.items() if k not in {'current_target', 'next_action'}}
with (out / 'gate-before.json').open('xb') as stream:
    stream.write(before)
after = (json.dumps(gate, indent=2, ensure_ascii=False) + '\n').encode()
with (out / 'gate-after.json').open('xb') as stream:
    stream.write(after)
assert gate_path.read_bytes() == before
temporary = gate_path.with_name('chapter-01.canonical-physical.tmp')
with temporary.open('xb') as stream:
    stream.write(after)
os.replace(temporary, gate_path)
result['gate'] = {'before_sha256': hashlib.sha256(before).hexdigest(), 'after': pin(gate_path),
                  'closed_rows_preserved': 39, 'newly_closed_rows': 0}
create(out / 'receipt.json', result)
print(json.dumps(result, indent=2))
