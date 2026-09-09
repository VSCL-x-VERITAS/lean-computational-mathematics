"""Append actual completed audit results; retain the prior ledgers byte for byte."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
gate = json.loads((R / 'gates/leveque-finite-volume/chapter-01.json').read_bytes())
rows = {r['id']: r for r in gate['rows']}
accepted = [
    ('091', 'LEV-CH01-EIGENVALUES-WAVE-SPEEDS', '6df1aad1b35d0ae178bb2796f82a72779c7af4958dfea85de99d3732585fdcb3'),
    ('092', 'LEV-CH01-ACOUSTICS-LEFT-MODE', 'b802ba73c56987b90d54b929f3a7c4e442e0e441eb6d331755b7f9497a6343c7'),
    ('093', 'LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA', '0074ffd53e7c86cf4400a53038e97e8430b90297860c831a1fe7ecbd73753425'),
]
lines = []
for number, row_id, digest in accepted:
    row = rows[row_id]
    decision_path = R / row['faithfulness_decision']
    decision = json.loads(decision_path.read_bytes())
    assert sha(decision_path) == digest
    assert row['status'] == 'PROVED' and decision['accepted'] is True
    assert decision['classification'] == 'faithful-equivalent'
    assert all(decision['implications'][direction]['verdict'] == 'yes'
               for direction in ('lean_implies_source', 'source_implies_lean'))
    lines.append('| LEV-C1-QUALIFIED-ACCEPTANCE-' + number + ' | ' + row_id
                 + ' | source ambiguity retained | Fresh independent audit completed under the separately recorded coordinator-selected convention | '
                 + 'Exact accepted decision and actual native proof checks are bound in the current gate | PROVED; faithful-equivalent under the recorded interpretation | '
                 + decision_path.relative_to(R).as_posix() + ' SHA256 ' + digest
                 + ' | Historical blocked and undetermined entries remain provenance; this does not assert an unqualified printed-source theorem. |')
repairs = [
    ('094', 'LEV-CH01-DIMENSIONAL-SPLITTING', 'LEV-CH01-COORDINATE-SPLITTING-INTERPRETED-PRODUCTION-20260908',
     '4dde8fca096bef0991e92c33df868619b73962d1b03c589e02175a70ac26f568',
     'The primary conservative sweep permits arbitrary rules without establishing their linkage to actual directional numerical problems; global line and schedule coverage also remains unresolved',
     'Develop a substantive primary contract connecting actual directional laws, intermediate states and independent reference comparisons; preserve generic logical geometry and explicit applicability'),
    ('095', 'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE', 'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908',
     '4fc5708b05008a032587c783539ca96ffc2e9982f1eddc779c24b15a20fd0f5f',
     'The conditional conservative error calculation is verified, but all-real-time rectangle and pointwise face-representative applicability is unresolved; inherited equation 1.10 was not visible in the permitted source image',
     'Supply the actual inherited source context and review a local-cell/time balance contract without assuming a global solution extension'),
]
for number, row_id, task_id, digest, problem, action in repairs:
    decision_path = S / 'audits' / task_id / 'faithfulness/decision.json'
    decision = json.loads(decision_path.read_bytes())
    assert sha(decision_path) == digest and decision['accepted'] is False
    assert rows[row_id]['status'] == 'IN_PROGRESS'
    lines.append('| LEV-C1-AUDIT-REPAIR-' + number + ' | ' + row_id + ' | source correspondence | '
                 + problem + ' | ' + action + ' | IN_PROGRESS; prior decision remains undetermined | '
                 + decision_path.relative_to(R).as_posix() + ' SHA256 ' + digest
                 + ' | Fresh statement and independent audit required; changing status or interpretation wording alone does not repair a mathematical gap. |')
process_lines = [
    '| LEV-SKILL-QUALIFICATION-PROJECTION-075 | codex-start-1-v5-0-1-20260908 | local gate projection guard | The completed Q5 decision explicitly qualified both implications and rationale but used different finding categories, so the first local preview rejected it | Additive V2 recognizes that explicit qualification while retaining complete sealed validation, exact interpretation and actual native evidence guards | Actual V2 preview and apply exited zero; prior failed preview preserved | qualified-refinement-v2-final-receipt SHA256 7674b804e9781ee0475f728f8a33e14204ecfdbcf1a1be65523748ad03abe009; material-interface apply output SHA256 444b256f425c831d12b84c2e7743211ee3e85c975576fd2638ced856c47c8e2f | No audit output, sealed kit or released gate checker was edited. |',
]
receipt = {'gate_sha256': sha(R / 'gates/leveque-finite-volume/chapter-01.json'), 'ledgers': {}}
for name, path, new_lines in [('book', book, lines), ('process', process, process_lines)]:
    raw = path.read_bytes()
    assert raw.endswith(b'\n')
    assert all(line.split('|')[1].strip().encode() not in raw for line in new_lines)
    with (D / (name + '-issues-before-first-three-results.md')).open('xb') as f:
        f.write(raw)
    before = sha(path)
    path.write_bytes(raw + ('\n'.join(new_lines) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    receipt['ledgers'][name] = {'before_sha256': before, 'after_sha256': sha(path), 'appended_entries': len(new_lines)}
with (D / 'first-three-results-ledgers-receipt.json').open('xb') as f:
    f.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
