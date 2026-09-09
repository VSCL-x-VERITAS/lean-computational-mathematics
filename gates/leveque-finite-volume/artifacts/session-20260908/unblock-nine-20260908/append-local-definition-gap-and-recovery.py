"""Append observed local audit and execution outcomes; preserve ledger history."""
from pathlib import Path
import hashlib, json
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
loc = lambda p: p.relative_to(R).as_posix() + ' SHA256 ' + sha(p)
T = S / 'audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908'
decision_path = T / 'faithfulness/decision.json'
decision = json.loads(decision_path.read_bytes())
assert sha(decision_path) == '7f05c038afd7d1bf13c969e6db6f5c4f7735a0aabd04fe856fd7e35585cdda54'
assert decision['classification'] == 'undetermined' and decision['accepted'] is False
run = json.loads((T / 'role-run-receipt.json').read_bytes())
assert run['exit_code'] == 0 and run['decision_sha256'] == sha(decision_path)
for name in ['prepare-exit.json', 'prepared-validation-exit.json']:
    assert json.loads((T / name).read_bytes())['exit_code'] == 0
checks = ['unblock-nine-local-organization-layout-02', 'unblock-nine-local-complete-declarations-02', 'unblock-nine-local-final-full-02']
for name in checks:
    receipt = json.loads((S / (name + '-exit.json')).read_bytes())
    assert receipt['exit_code'] == 0 and receipt['output_sha256'] == sha(S / (name + '-output.txt'))
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
entries = {
    book: ['| LEV-C1-NATIVE-DEFINITION-GAP-100 | LEV-CH01-FINITE-VOLUME-FLUX-UPDATE | exact integral identification | The fresh local target audit resolves measure normalization and accepts the intended algebra, but cannot identify the wrapped integral from the supplied declaration packet | Prepare a fresh same-target audit with the existing checked Bochner integral operator evidence and exact finite-vector specialization | IN_PROGRESS; undetermined is preserved, not a demonstrated false target | ' + loc(decision_path) + ' | Q7 and the inherited rectangle interpretation remain scoped and unchanged; no new norm formula is required by the decision. |'],
    process: [
        '| LEV-SKILL-LONG-PATH-RECOVERY-079 | codex-start-1-v5-0-1-20260908 | native filesystem transport | The recorded FV preparation failure occurred before released preparation or role launch | An additive extended-path helper preserved the two existing files and exact recovery manifest, then ran preparation and prepared validation | Both actual exits zero; subsequent roles completed and returned their independent undetermined decision | ' + loc(T / 'prepared-validation-exit.json') + ' | The original failed attempt and source bytes remain unchanged. |',
        '| LEV-SKILL-LOCAL-ORGANIZATION-080 | codex-start-1-v5-0-1-20260908 | reusable module census and umbrella reachability | Nine new reusable leaves needed explicit reviewed tier rules and Analysis umbrella imports | Add exact tier classifications and sorted canonical imports, then rerun layout and the full build | Current layout and full build actual zero; no source-wrapper or target bytes changed | ' + loc(S / 'unblock-nine-local-organization-layout-02-exit.json') + ' | Earlier census/layout failures remain recorded; gate worktree bindings must refresh after the aggregate edit. |',
        '| LEV-SKILL-NATIVE-ARGV-081 | codex-start-1-v5-0-1-20260908 | exact final evidence command | The first complete native declaration check succeeded with an absolute file argument, whereas the final projection contract specifies the repository-relative argument | Replay the same unchanged check file using the exact required relative argument | Actual zero and byte-identical output; all 41 target declarations resolve | ' + loc(S / 'unblock-nine-local-complete-declarations-02-exit.json') + ' | This records command-shape compatibility, not an additional mathematical judgment. |'
    ]}
receipt = {'schema': 1, 'audit_decision': loc(decision_path), 'ledgers': []}
for path, additions in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n')
    assert all(row.split('|')[1].strip().encode() not in raw for row in additions)
    before = sha(path)
    with path.open('ab') as out:
        out.write(('\n'.join(additions) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    receipt['ledgers'].append({'path': path.relative_to(R).as_posix(), 'before_sha256': before, 'after_sha256': sha(path), 'appended_entries': len(additions)})
with (D / 'local-definition-gap-and-recovery-ledger-receipt.json').open('xb') as out:
    out.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
