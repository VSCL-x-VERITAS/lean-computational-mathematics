"""Append actual audit/check results without rewriting earlier ledger history."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
loc = lambda p: p.relative_to(R).as_posix() + ' SHA256 ' + sha(p)
fv = S / 'audits/LEV-CH01-FV-LOCAL-FLUX-UPDATE-NORM-COMPLETE-PRODUCTION-20260908/faithfulness/decision.json'
dim = S / 'audits/LEV-CH01-COORDINATE-DIRECTIONAL-METHODS-INTERPRETED-PRODUCTION-20260908/faithfulness/decision.json'
assert sha(fv) == '224505f22f1a45b4b1f94db82acbf207fb883f3e0a5c11d4bae0c14af382142c'
assert read(fv)['accepted'] is True and read(fv)['classification'] == 'faithful-equivalent'
assert all(v['verdict'] == 'yes' for v in read(fv)['implications'].values())
assert sha(dim) == 'fc49c4f1f23dfd74c669b28030ab3e1a35fc6be890fe9bb9280bee06f03fc0a8'
assert read(dim)['accepted'] is False and read(dim)['classification'] == 'not-faithful-weaker'
recovery = D / 'adjudicator-transport-recovery-v3/dim-a2/execution-receipt.json'
record = read(recovery)
assert record['exit_code'] == 0 and record['released_complete_validation_exit_code'] == 0
assert record['original_role_run_exit_code'] == 1 and record['original_attempt_retained'] is True
assert record['decision']['sha256'] == sha(dim)
assert len(record['steps']) == 4 and all(x['exit_code'] == 0 for x in record['steps'])
labels = ['unblock-nine-fv-norm-complete-binding', 'unblock-nine-routine-organization-preflight',
          'unblock-nine-routine-full-build', 'unblock-nine-routine-layout',
          'unblock-nine-routine-complete-declarations']
for label in labels:
    check = read(S / (label + '-exit.json'))
    assert check['exit_code'] == 0 and check['input_commit'] == '5e3f63594aa964263469ada134aee2809559d50d'
    assert check['output_sha256'] == sha(S / (label + '-output.txt'))
gate = read(R / 'gates/leveque-finite-volume/chapter-01.json')
selected = next(row for row in gate['rows'] if row['id'] == 'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE')
assert selected['status'] == 'PROVED' and selected['faithfulness_decision'] == fv.relative_to(R).as_posix()
assert sum(row['status'] in ['PROVED', 'REUSED'] for row in gate['rows']) == 39
fingerprints = D / 'riemann-routine-fingerprints/final-receipt.json'
assert sha(fingerprints) == '31e2f2e33f774cc93475e74be8f2678bf1d626f9b4dbc4e842899740d0004b04'
assert read(fingerprints)['native_actual_exit'] == 0 and read(fingerprints)['parser_archive_actual_exit'] == 0
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == 'c0de867809349f2ed24fc96426960bc885c919508470b2f9de0051fae6595502'
assert sha(process) == 'c1a77289ef81fb1f50eb09e5fe64c31fe83499abbdb8fcd0c956ec94b2ca8ed6'
entries = {
    book: [
        '| LEV-C1-DIRECTIONAL-METHOD-REJECTION-104 | LEV-CH01-DIMENSIONAL-SPLITTING | completed historical method audit | The audited method contract did not require high resolution and its physical reference balance was restricted to stage endpoints; Cartesian scalar volume did not identify actual regions and face fluxes | Replace with quantified method quality, all local subrectangle balances and actual geometric identifications under the separately recorded convention | IN_PROGRESS; historical decision not-faithful-weaker, implications no/yes | ' + loc(dim) + ' | The audit predates the new literal high-resolution receipt. A nonvacuity sample alone cannot repair its universal domain. |',
        '| LEV-C1-FV-NORM-COMPLETE-ACCEPTANCE-105 | LEV-CH01-FINITE-VOLUME-FLUX-UPDATE | local numerical update comparison | The fresh sealed audit resolves the exact integral, measure and norm-instance gaps and accepts both implications | Bind the unchanged proved target with current native declarations and complete validated audit | RESOLVED under recorded Q7 interpretation; faithful-equivalent yes/yes | ' + loc(fv) + '; ' + loc(D / 'fv-norm-complete-binding-request.json') + '; ' + loc(S / 'unblock-nine-fv-norm-complete-binding-exit.json') + ' | Q7 remains a coordinator-selected local quantitative comparison; the source does not print that norm or bound. Seven of the original nine rows are now closed; two remain. |'
    ],
    process: [
        '| LEV-SKILL-LOSSLESS-ADJUDICATION-085 | codex-start-1-v5-0-1-20260908 | native adjudicator input capacity | The original DIM wrapper exited one before adjudicator execution because its complete prompt exceeded the input limit | Apply reviewed lossless transport V3 with exact reconstruction, whole-line reference spans and JSON whitespace preservation; retain the original attempt and all four completed roles | Actual native adjudicator, collector, finalizer and complete validator all exited zero; decision remains rejected | ' + loc(recovery) + '; ' + loc(D / 'adjudicator-transport-recovery-v3/receipt.json') + ' | Thirty transport tests passed. This is an input transport repair, not a changed protocol, source or verdict. |',
        '| LEV-SKILL-ROUTINE-ORGANIZATION-086 | codex-start-1-v5-0-1-20260908 | routine API material module increment | Four routine modules require current source-tier and aggregate coverage | Stage exact new leaves, preserve old import order, insert new imports beside their ordering predecessors and add exact reusable tier rules | Organization preflight, 5992-module layout, full library and all 41 selected declaration checks exited zero | ' + loc(D / 'organization-riemann-routine/receipt.json') + '; ' + loc(S / 'unblock-nine-routine-layout-exit.json') + '; ' + loc(S / 'unblock-nine-routine-full-build-exit.json') + '; ' + loc(S / 'unblock-nine-routine-complete-declarations-exit.json') + ' | The first attempt stopped before mutations on an untracked-file census; the second stopped after staging leaves because it assumed global import sorting. Both are retained; the third preserves existing order and succeeds. Global gate evidence remains open. |',
        '| LEV-SKILL-ROUTINE-EXPRESSION-COVERAGE-087 | codex-start-1-v5-0-1-20260908 | native producer inventory increment | Four new routine owner modules add 37 eligible constants, including 22 authored declarations | Use the unchanged native serializer and parser, verify prior pins and archive the exact raw expression stream losslessly | Native export and parser/archive exited zero; combined inventory 1126 constants across 151 owner modules | ' + loc(fingerprints) + ' | All 29 project closure owners are covered. The 282482918-byte raw stream stays local; exact 4795525-byte gzip is the publication artifact. Committed-blob verification remains pending. |'
    ]
}
result = {'schema': 1, 'recorder': loc(Path(__file__).resolve()), 'closed_rows': 39,
          'original_nine_closed': 7, 'gate_terminal_acceptance': False, 'ledgers': []}
for path, additions in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and all(row.split('|')[1].strip().encode() not in raw for row in additions)
    before = sha(path)
    with path.open('ab') as stream:
        stream.write(('\n'.join(additions) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    result['ledgers'].append({'path': path.relative_to(R).as_posix(), 'before_sha256': before,
                             'after_sha256': sha(path), 'entries_appended': len(additions)})
with (D / 'seventh-closure-and-method-recovery-ledger-receipt.json').open('xb') as stream:
    stream.write((json.dumps(result, indent=2) + '\n').encode())
print(json.dumps(result))
