"""Append actual audit findings and selected refinements without rewriting history."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
book=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
entries=[]
for number,name in [(89,'interpretation-refinement.json'),(90,'q6-interpretation-refinement.json')]:
 path=D/'riemann-definition-repair'/name
 ref=json.loads(path.read_bytes())
 ident='LEV-C1-INTERPRETATION-REFINED-'+str(number).zfill(3)
 assert ident.encode() not in book.read_bytes()
 entries.append('| '+ident+' | '+ref['scope_row']+' | exact analytic/model interpretation | Prior fresh audit remained undetermined because the original convention did not settle the full effective domain | '+ref['required_audit_qualification']+' | selected by coordinator under the user goal; fresh audit required | '+path.relative_to(R).as_posix()+' SHA256 '+sha(path)+' | Preserve original PDF, original selected receipt and all prior decisions. This record supplies no literal detailed user reply or independent acceptance. |')
process_entries=[
 '| LEV-SKILL-OPAQUE-DEPENDENCY-EVIDENCE-073 | codex-start-1-v5-0-1-20260908 | exact statement dependency coverage | One-level imported declarations exposed wrapped neighborhood and integration operators without enough semantics for independent comparison | Preserve both undetermined decisions; provide actual native definitions and characterization declarations in separately manifest-bound supplements | topology resolved by fresh accepted audit; material operator audit ongoing | material-interface topology decision 0074ffd53e7c86cf4400a53038e97e8430b90297860c831a1fe7ecbd73753425; operator packet 7cb6676ee8033a635c944eaca89a4deaf69fc1477a584e87b6b0214b106efd1e | No original kit, target proof or prior judgment was rewritten. Native definition evidence does not itself decide source faithfulness. |',
 '| LEV-SKILL-NATIVE-LONG-AUDIT-PATH-074 | codex-start-1-v5-0-1-20260908 | native transport preparation after successful POSIX audit preparation | Long audit IDs exceeded native Windows path limits when reading a blind packet or copying a page image, after released prepare and prepared validation both exited zero | Complete only missing transport preflight/image copying with extended Windows paths, then run fresh roles through an additive runner | transport recovered; original failures preserved | finish-prepared-transport.py and v2 verify existing successful preparation and unchanged generated role helpers; no released preparation was relabeled | Original input packets remain fixed, blind isolation is checked again, missing images are copied byte-for-byte, and no prior role output is reused. |'
]
for entry in process_entries:assert entry.split('|')[1].strip().encode() not in process.read_bytes()
before={}
for name,path,lines in [('book',book,entries),('process',process,process_entries)]:
 raw=path.read_bytes()
 before[name]=sha(path)
 with (D/(name+'-issues-before-audit-repairs.md')).open('xb') as f:f.write(raw)
 path.write_bytes(raw.rstrip(b'\r\n')+b'\n'+('\n'.join(lines)+'\n').encode())
record={'before_sha256':before,'after_sha256':{'book':sha(book),'process':sha(process)},
 'book_entries':2,'process_entries':2,'prior_entries_preserved':True}
with (D/'audit-repair-ledgers-receipt.json').open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(record))
