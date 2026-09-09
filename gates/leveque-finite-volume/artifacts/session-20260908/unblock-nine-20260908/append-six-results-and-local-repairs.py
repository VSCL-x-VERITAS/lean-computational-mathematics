"""Append verified audit outcomes and actual transport failures without changing history."""
from pathlib import Path
import hashlib, json
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
gate = json.loads(gate_path.read_bytes())
rows = {r['id']: r for r in gate['rows']}
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
entries = []
for number, spec_name, digest in [
    ('096', 'riemann-model-refined-audit-spec.json', '0fc55ff9712a2fa30b2066a36a84f62cf647f5d4d602230c90fb15d4ef24c609'),
    ('097', 'material-average-operators-audit-spec.json', '9058d347b84d927ed757bfd5a2585948e764b2d7d2e9e92689b29e4d3b0cc5b3'),
    ('098', 'source-slices-refined-audit-spec.json', 'c8248f7f09aef51647d52aa785fe601b383284b2e225f16099b604688b372c3d')]:
    spec = json.loads((D / spec_name).read_bytes())
    row = rows[spec['row_id']]
    p = R / row['faithfulness_decision']
    decision = json.loads(p.read_bytes())
    assert sha(p) == digest and row['status'] == 'PROVED'
    assert decision['accepted'] and decision['classification'] == 'faithful-equivalent'
    assert all(decision['implications'][k]['verdict'] == 'yes' for k in ('lean_implies_source', 'source_implies_lean'))
    entries.append('| LEV-C1-QUALIFIED-ACCEPTANCE-' + number + ' | ' + row['id'] + ' | source ambiguity retained | Fresh independent audit accepts both implications under the exact separately recorded interpretation and native definition evidence | Exact decision and native proof checks are bound in the row | PROVED; faithful-equivalent under the recorded interpretation | ' + p.relative_to(R).as_posix() + ' SHA256 ' + digest + ' | Historical undetermined entries remain provenance. Global source-context bindings require refresh after the subsequent production additions. |')
info = S / 'audits/LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/decision.json'
decision = json.loads(info.read_bytes())
assert not decision['accepted'] and rows['LEV-CH01-RIEMANN-INTERFACE-FLUX']['status'] == 'IN_PROGRESS'
entries.append('| LEV-C1-AUDIT-REPAIR-099 | LEV-CH01-RIEMANN-INTERFACE-FLUX | physical problem linkage and domain | The earlier primary admitted an arbitrary solver output without a physically constrained reference and imposed global admissibility | New local method interface binds each admitted ordered problem to a same-law rectangle reference over its positive duration, with conditional numerical error comparison | IN_PROGRESS; fresh independent source audit required | ' + info.relative_to(R).as_posix() + ' SHA256 ' + sha(info) + ' | Focused new source and producer builds exited zero; no entropy, uniqueness, convergence or source-selected tolerance is asserted. |')
validation = S / 'unblock-nine-interface-attempt2-complete-validation-02-exit.json'
vr = json.loads(validation.read_bytes())
assert vr['exit_code'] == 0
process_entries = [
    '| LEV-SKILL-ROLE-TRANSPORT-076 | codex-start-1-v5-0-1-20260908 | native role input limit | The earlier information-interface adjudicator input exceeded the native CLI character limit before a turn began | An additive retry compacted only JSON whitespace, verified parsed equality and retained all values, dossiers, images and original hashes | Fresh retry completed and released complete validation exited zero; semantic decision remained undetermined | lossless-adjudicator-transport-receipt.json; ' + validation.relative_to(R).as_posix() + ' SHA256 ' + sha(validation) + ' | No evidence was truncated or prior judgment changed. |',
    '| LEV-SKILL-FINALIZER-STATE-077 | codex-start-1-v5-0-1-20260908 | local retry assertion | The recovery wrapper incorrectly expected the manifest to remain byte-identical after the released finalizer legitimately updated completion fields | Preserve that wrapper failure and independently run released complete validation; preserve the initial incorrect native config-path attempt separately | Correct POSIX config-path validation exited zero | ' + validation.relative_to(R).as_posix() + ' SHA256 ' + sha(validation) + ' | Actual role and finalizer outcomes remain separate from the failing local wrapper exit. |',
    '| LEV-SKILL-LONG-PATH-PREPARATION-078 | codex-start-1-v5-0-1-20260908 | native Windows filesystem path | The fresh local FV preparation failed writing inherited-source-interpretation-packet.json because its native path exceeded the ordinary path limit | Derive extended-path filesystem transport and guarded append-only recovery; preserve the original helper, spec and two already written input files | Observed actual exit 1 before released prepare or any role launch; repair in progress | Tool output b83849; prepare-successor-audit-with-source-context.py SHA256 f0f27bc5757411a7363fcc70a18c78b2d5bf8011920f9e7c9ee2ebc2013f4ce2 | This is transport failure, not a mathematical or source verdict. |'
]
receipt = {'gate_sha256': sha(gate_path), 'ledgers': {}, 'source_audit_status': 'six accepted; three require fresh audits; global context refresh pending'}
for key, p, additions in [('book', book, entries), ('process', process, process_entries)]:
    raw = p.read_bytes()
    assert raw.endswith(b'\n')
    assert all(x.split('|')[1].strip().encode() not in raw for x in additions)
    with (D / (key + '-issues-before-six-results.md')).open('xb') as out:
        out.write(raw)
    before = sha(p)
    p.write_bytes(raw + ('\n'.join(additions) + '\n').encode())
    assert p.read_bytes().startswith(raw)
    receipt['ledgers'][key] = {'before_sha256': before, 'after_sha256': sha(p), 'appended_entries': len(additions)}
with (D / 'six-results-ledgers-receipt.json').open('xb') as out:
    out.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
