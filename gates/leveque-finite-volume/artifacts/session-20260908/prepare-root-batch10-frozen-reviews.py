"""Root read-only verification of frozen coordinate and chronology preparations."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def put(p,o):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(o,indent=2)+'\n')
def bind(p):return dict(path=str(p),sha256=sha(p))
P=S/'information-coordinate-sweep-draft';src=P/'verify-final.py'
original=src.read_text(encoding='utf-8')
assert original.count("P=Path(__file__).resolve().parent; R=P.parents[4]")==1
body=original.replace("P=Path(__file__).resolve().parent; R=P.parents[4]","P=Path(__file__).resolve().parent/'information-coordinate-sweep-draft'; R=P.parents[4]")
body=body.replace("out=P/'verification.json'","out=P.parent/'root-information-coordinate-sweep-verification.json'")
body=body.replace("assert r['exit_code']==0 and r['inputs_unchanged']","assert type(r['exit_code']) is int and r['exit_code']==0 and r['inputs_unchanged']")
target=S/'verify-information-coordinate-sweep-root.py'
with target.open('x',encoding='utf-8',newline='') as f:f.write(body)
put(S/'information-coordinate-root-verifier-derivation.json',dict(source=bind(src),derived=bind(target),change='Fixed directory and new root output; strict integer final native exit; all existing assertions preserved.'))
P=S/'blocked-gate-binding-transcript-order-v2'
assert sha(P/'preparation-files.json')=='fce710b1f56dc1bce07c68fa4aba1b3a82844774bed0da4e99e045f01a6d5c25'
files=json.loads((P/'preparation-files.json').read_bytes())['files']
for x in files:assert sha(P/x['path'])==x['sha256'],x
inputs=json.loads((P/'inputs.json').read_bytes())
def visit(x):
 if isinstance(x,dict):
  if 'path' in x and 'sha256' in x:
   p=Path(x['path']);p=p if p.is_absolute() else R/p
   assert sha(p)==x['sha256'],p
  for v in x.values():visit(v)
 elif isinstance(x,list):
  for v in x:visit(v)
visit(inputs)
receipts=[]
for label in ['root-batch10-blocked-binder-v2-fixtures','root-batch10-blocked-binder-v2-projection']:
 rec=S/(label+'-exit.json');out=S/(label+'-output.txt');r=json.loads(rec.read_bytes())
 assert type(r['exit_code']) is int and r['exit_code']==0
 assert sha(out)==r['raw_output_sha256']
 receipts.append(dict(receipt=bind(rec),output=bind(out),actual_exit=0))
projection=json.loads((S/'root-batch10-blocked-binder-v2-projection-output.txt').read_bytes())
assert projection['questions']==11 and projection['replies']==2 and projection['no_later_user_messages'] is True
report=S/'root-blocked-binder-v2-review.json'
put(report,dict(status='PASS',scope='Root code/provenance/fixture review only; no prepare, install, blocker classification or source adoption',manifest=bind(P/'preparation-files.json'),protected_inputs=bind(P/'inputs.json'),actual_root_receipts=receipts,synthetic_tests=90,review='Reviewed V1-to-V2 chronology implementation, closed projection schema/docs and test diff. Complete original question/reply identities, prefix hashes, selected-event line order and disclosed clock regression retained. Later ordinary user messages force re-review; unrelated assistant/tool appends permitted. Existing row/native/audit/evidence guards unchanged. Root projection-only run confirms current 11 questions and 2 explicit replies; eight mapped pending choices, Q11 unmapped. Any future terminal claim still requires substantive route completion, current globals and released actual checker.'))
print(json.dumps(dict(status='PASS',binder_review_sha256=sha(report),coordinate_verifier=bind(target))))

