"""Record the completed DIM placement and the actual unresolved Routine adjudication."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
loc = lambda p: p.relative_to(R).as_posix() + ' SHA256 ' + sha(p)
decision = S / 'audits/LEV-CH01-LOCAL-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908/faithfulness/decision.json'
assert sha(decision) == 'd2e90d3fcab20d8f6a367c0ee0ed9263cf90439fdb7b806825a21b9561ae8e05'
assert read(decision)['classification'] == 'undetermined' and read(decision)['accepted'] is False
recovery = D / 'adjudicator-transport-recovery-v4-retry-lineage/info-a2/execution-receipt.json'
rec = read(recovery)
assert rec['exit_code'] == rec['released_complete_validation_exit_code'] == 0
assert len(rec['steps']) == 4 and all(x['exit_code'] == 0 for x in rec['steps'])
assert rec['decision']['sha256'] == sha(decision) and rec['original_role_run_exit_code'] == 1
production = D / 'directional-high-resolution-production/final-receipt.json'
assert sha(production) == 'a55bfd9c81215f00ecbc21fa24a03f12d6e6c3c47d50cd0cc107cc1cea26f87d'
assert read(production)['actual_exit_code'] == 0 and read(production)['authored_declarations'] == 150
placement = D / 'organization-high-resolution/receipt.json'
assert read(placement)['counts']['production_modules'] == 6008
assert len(read(placement)['staged_exact_paths']) == 19
for label in ['unblock-nine-high-resolution-organization-placement', 'unblock-nine-high-resolution-organization-preflight']:
    path = S / (label + '-exit.json')
    assert read(path)['exit_code'] == 0
    assert read(path)['output_sha256'] == sha(S / (label + '-output.txt'))
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == '18a4c5abfd08c7e1603e642ed03b296d37e42798450ba489cd894a9ea895bca9'
assert sha(process) == '1859054b8540234f480f8bb2435102fef638498645bbab37499055fbb9a3f47f'
entries = {
    book: ['| LEV-C1-ROUTINE-SOLVING-LINKAGE-107 | LEV-CH01-RIEMANN-INTERFACE-FLUX | completed unrestricted Routine audit | Exact norms, integrals, signs, local error propagation and nonvacuity are verified, but an unrestricted information routine has no required exact-or-approximate Riemann-solving relation | Add a supplied per-admitted-problem existential physical Reference and numerical-flux accuracy property, preserving information-only outputs and allowing nonzero certified error; do not weaken Q7 to justify arbitrary routines | IN_PROGRESS; actual adjudicated decision undetermined, implications unclear/yes | ' + loc(decision) + ' | The new property reuses Method.accurate and the existing biased scalar transport reference, without the old mandatory exact consistency condition. No additional user interpretation has been inferred. |'],
    process: [
        '| LEV-SKILL-INFO-RETRY-ADJUDICATION-090 | codex-start-1-v5-0-1-20260908 | separate schema and native input-capacity recovery | The valid fresh roundtrip required adjudication, whose first unstarted attempt exceeded the native input limit | Execute the reviewed exact five-entry retry-lineage V4 plan and preserve every original failure | Native adjudicator, collector, finalizer and complete validator exited zero; the resulting source decision remains undetermined | ' + loc(recovery) + ' | Successful transport is not semantic acceptance. Six actual completed runtime entries preserve the original invalid roundtrip and its valid fresh retry. |',
        '| LEV-SKILL-HIGH-RESOLUTION-PLACEMENT-091 | codex-start-1-v5-0-1-20260908 | complete method and measured geometry production increment | Fifteen reusable owners and one source wrapper require explicit canonical placement, import exposure and classification | Freeze 150 authored declarations, verify 149 transported declaration types and 25 nominal bridges, check the full source-level joint application, then stage exactly sixteen leaves plus two aggregates and the tier manifest | Native production checks, exact placement and organization preflight exited zero; census is 6008 modules | ' + loc(production) + '; ' + loc(placement) + '; ' + loc(S / 'unblock-nine-high-resolution-organization-preflight-exit.json') + ' | All earlier import and comparison failures remain. Reusable690/source1525/aggregate449/compatibility3334/internal5/upstream5; exact4994/prefix27; no unclassified or mixed modules or absent exact-rule files. Source audit and final complete-library evidence remain pending. |'
    ]
}
result = {'schema': 1, 'recorder': loc(Path(__file__)), 'source_acceptance': False, 'ledgers': []}
for path, additions in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and all(row.split('|')[1].strip().encode() not in raw for row in additions)
    before = sha(path)
    with path.open('ab') as stream:
        stream.write(('\n'.join(additions) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    result['ledgers'].append({'path': path.relative_to(R).as_posix(), 'before_sha256': before,
                             'after_sha256': sha(path), 'entries_appended': len(additions)})
with (D / 'high-resolution-and-routine-finding-ledger-receipt.json').open('xb') as stream:
    stream.write((json.dumps(result, indent=2) + '\n').encode())
print(json.dumps(result))
