"""Append final source/process ledger records without modifying the installed gate."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
G=R/'gates/leveque-finite-volume/chapter-01.json'
expected='e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0'
assert sha(G)==expected
T=S/'blocked-gate-binding-transcript-order-v2/runs/final-80f5/root-final-80f5-terminal.json'
t=read(T);assert t['derived_verdict']=='BLOCKED' and t['actionable_rows']==0 and t['exit_code']==0 and t['gate_sha256']==expected
log=T.with_name('root-final-80f5-checker-output.txt');assert sha(log)==t['output_sha256']
assert t['output_sha256']=='4e44f911e22da48fe40a8e37fc9207ce974dc59caa02d78cd34338b31596ada4'
g=read(G);blocked=[r for r in g['rows'] if r['status']=='HARD_BLOCKED'];assert len(blocked)==9
review=read(S/'final-material-choice-independent-review-80f5/review.json')
reviews={r['row_id']:r for r in review['rows']};assert set(reviews)=={r['id'] for r in blocked}
ledger=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
clean=lambda v:str(v).replace('|','/').replace('\n',' ')
entries=[]
for n,row in enumerate(blocked,71):
 ident='LEV-C1-MATERIAL-CHOICE-'+str(n).zfill(3)
 entries.append('| '+ ' | '.join(map(clean,[ident,row['id'],'reviewed nonlocal source-interpretation boundary',row['obstruction'],reviews[row['id']]['assessment'],'HARD_BLOCKED; material-user-choice; local work complete','installed released checker exit 0; gate '+expected+'; root review 95c545d068c981abb9e48d95c553fc1a0091c39670b96a8f917ea429ef34ce59',row['resume_condition']]))+' |')
pid='codex-start-1-v5-0-1-20260908'
raw=[
['LEV-SKILL-FINAL-NATIVE-ORDERING-063',pid,'final current declaration check','The first declaration invocation began before the asynchronous input generator actually exited and found no check file','Retain actual failure and await the generator completion before the fresh retry','resolved','first actual exit 1; generator actual 0; retry actual 0 with 32 declarations and allowed axioms, receipt 29252f36bb73a15b9d36c550f0661b964e4e6ee1d3adc4447febd5656f607f19','No successful receipt was inferred from an active native session.'],
['LEV-SKILL-FINAL-REQUEST-SCHEMA-064',pid,'root material-choice request preparation','The initial root builder used the CLI display key state instead of the actual durable status key current_state','Preserve failed V1; additive V2 checks the actual status schema and exact request and checkpoint pins','resolved','V1 exit 1 before dossier output; V2 exit 0; request constructor exit 0; prepared proposal c12dc8ca1662acd5a024188a1124e58d9f4a8f7c6882d6520c4d42254461f41e','No released schema or original evidence was edited.'],
['LEV-SKILL-FINAL-REVIEW-PATHS-065',pid,'independent final local-completion evidence check','The first path formatter assumed a pinned source-page image was inside the Lean repository although its exact locator was elsewhere in the workspace','Retain actual failed script and receipt; additive V2 accepts the exact original absolute workspace path','resolved','V2 actual exit 0; 661 byte pins; receipt f52a89d24fe4ea78581a1ccea0d0ab978592c43ab217ad057d8809186002ca8e','No evidence mismatch, source adoption or terminal authority followed from this review.'],
['LEV-SKILL-FINAL-INSTALLED-BOUNDARY-066',pid,'reviewed installed gate and distinct terminal obligations','A prepared or mechanically reviewed BLOCKED proposal alone is not an installed released verdict','Root verified 999 independent bindings, executed exact installer V3 and then the separate released installed check with live question provenance','installed gate certified; durable reconciliation still separate','installer actual 0, receipt 62ecd701ca99b402f1979bb3eba7afb823221db06296c7a78fe235edb1f95c96; installed check actual 0, raw '+t['output_sha256'],'All eight globals verified and zero actionable rows. Nine source rows await eight distinct choices; Q11 remains unmapped. No PASS candidate, external acceptance or campaign integration is asserted.']
]
pentries=['| '+' | '.join(map(clean,row))+' |' for row in raw]
output=S/'root-final-ledger-records-80f5.json';assert not output.exists()
prepared=[]
for tag,path,new in [('book',ledger,entries),('process',process,pentries)]:
 old=path.read_bytes()
 for line in new:assert line.split('|')[1].strip().encode() not in old
 backup=S/('root-final-before-'+tag+'-ledger-'+sha(path)+'.bin');assert not backup.exists()
 payload=old+(b'' if old.endswith(b'\n') else b'\n')+('\n'.join(new)+'\n').encode()
 assert payload.startswith(old)
 prepared.append((tag,path,old,backup,payload,new))
for tag,path,old,backup,payload,new in prepared:
 assert path.read_bytes()==old
 with backup.open('xb') as f:f.write(old)
 path.write_bytes(payload)
 assert path.read_bytes().startswith(old)
assert sha(G)==expected
result={'kind':'append-only-final-ledger-records','gate_sha256':expected,'terminal_receipt_sha256':sha(T),'entries':[{'scope':tag,'path':path.relative_to(R).as_posix(),'before_sha256':sha(backup),'after_sha256':sha(path),'added_ids':[line.split('|')[1].strip() for line in new]} for tag,path,old,backup,payload,new in prepared],'gate_mutated':False}
with output.open('xb') as f:f.write((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps({'status':'APPENDED','book_added':9,'process_added':4,'receipt_sha256':sha(output),'gate_sha256':sha(G)}))
