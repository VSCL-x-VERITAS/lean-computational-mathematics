"""Append the actual certified-routine increment without asserting audit closure."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
loc = lambda p: p.relative_to(R).as_posix() + ' SHA256 ' + sha(p)
production = D / 'riemann-certified-production/receipt.json'
assert sha(production) == '6d60dbcaede51de0977f67d33f95e4da7c4717af52e8adac5c9aeba051e03fcd'
pr = read(production)
assert pr['actual_build_exit_code'] == pr['actual_declaration_exit_code'] == 0
assert pr['canonical_declarations'] == pr['separate_applicability_declarations'] == 7
assert pr['full_type_and_axiom_output_byte_equal'] and pr['old_owner_bytes_preserved']
placement = D / 'organization-certified-routine/receipt.json'
assert read(placement)['counts']['production_modules'] == 6012
assert len(read(placement)['staged_exact_paths']) == 7
for label in ['unblock-nine-certified-routine-organization-placement', 'unblock-nine-certified-routine-organization-preflight']:
    receipt = read(S / (label + '-exit.json'))
    assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
    assert receipt['output_sha256'] == sha(S / (label + '-output.txt'))
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == 'b536d6dff58d35a9aa2c96467a169aeb30f2627c9621f4e54f898fb50340d77f'
assert sha(process) == '65d699f8b3c4c33b02894a1bd8e748c22fbdf64bb9582e3d748de78772bd029c'
entries = {
    book: ['| LEV-C1-CERTIFIED-ROUTINE-PRODUCTION-108 | LEV-CH01-RIEMANN-INTERFACE-FLUX | explicit same-problem accuracy property | The completed prior Routine audit left the exact-or-approximate Riemann-solving relation unresolved | Require a supplied per-admitted-problem physical reference and numerical-flux error certificate; obtain both references for the actual ordered face problems | Native production build and fourteen complete type/axiom reports passed; source audit remains IN_PROGRESS | ' + loc(production) + ' | The two nonconstant problems use neighboring states 0,1,0, a half-unit biased routine on the proper domain, actual reference errors of one half and actual update error of one. References come from the actual primary application; exact consistency and returned full fields are not required. Old source ambiguity and audit history remain. |'],
    process: ['| LEV-SKILL-CERTIFIED-ROUTINE-PLACEMENT-092 | codex-start-1-v5-0-1-20260908 | additive certified routine organization | The repaired contract needs distinct canonical producers without changing frozen historical audit inputs | Place three reusable owners and one thin source wrapper, preserving seven authored production declarations and keeping seven joint checks as evidence; stage only the four leaves and three organization files | Native build, exact scratch-to-production output comparison, placement and organization preflight passed | ' + loc(production) + '; ' + loc(placement) + ' | Current census6012: reusable693,source1526,aggregate449,compatibility3334,internal5,upstream5;4997exact/27prefix,zero absent exact targets/unclassified/mixed. Final global checks and two independent source audits remain in progress. |']
}
record = {'schema': 1, 'recorder': loc(Path(__file__)), 'source_acceptance': False, 'ledgers': []}
for path, rows in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and all(row.split('|')[1].strip().encode() not in raw for row in rows)
    before = sha(path)
    with path.open('ab') as stream:
        stream.write(('\n'.join(rows) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    record['ledgers'].append({'path': path.relative_to(R).as_posix(), 'before_sha256': before,
                              'after_sha256': sha(path), 'entries_appended': len(rows)})
with (D / 'certified-routine-production-ledger-receipt.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
