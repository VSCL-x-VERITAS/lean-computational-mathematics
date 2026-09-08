"""Verify frozen tensor-line evidence without asserting source acceptance."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent; R=S.parents[3]; D=S/'dimensional-splitting-lines-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt=D/'final-evidence.json'
assert sha(receipt)=='5f93ae364a761f61b73380ac9f29566a63939371c1e00cf263e6e50f8c84de47'
data=json.loads(receipt.read_bytes());count=0; unique=set()
def walk(v):
 global count
 if isinstance(v,dict):
  if 'path' in v and 'sha256' in v:
   p=R/v['path']; assert sha(p)==v['sha256'],str(p)
   count+=1;unique.add(v['path'])
  for x in v.values():walk(x)
 elif isinstance(v,list):
  for x in v:walk(x)
walk(data)
native=json.loads((D/'final-05-exit.json').read_bytes())
assert native['exit_code']==data['actual_exit_code']==0
assert native['input_commit']=='c4bfd6deb756ba46184c9418edc83bda33084719'
assert native['command'][1:]==['env','lean',str((D/'final-05-input.lean').relative_to(R))]
assert native['assembled_input_sha256']==sha(D/'final-05-input.lean')
assert native['raw_output_sha256']==sha(D/'final-05-output.txt')
for p,h in native['input_files'].items():assert sha(R/p)==h,p
assert sha(R/'lean-toolchain')==native['lean_toolchain_sha256']
assert sha(R/'lake-manifest.json')==native['lake_manifest_sha256']
output=(D/'final-05-output.txt').read_text(encoding='utf-8-sig')
checks=(D/'final-05-input.lean').read_text(encoding='utf-8-sig').splitlines()
assert not re.search(r'\b(?:error|warning):|sorryAx',output)
assert len(data['checked_declarations'])==24
assert set(native['checked_declarations'])==set(data['checked_declarations'])
for name,axioms in data['checked_declarations'].items():
 assert '#check '+name in checks and '#print axioms '+name in checks
 matches=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',output)
 assert len(matches)==1,name
 actual={x.strip() for x in matches[0].split(',') if x.strip()}
 assert actual==set(axioms) and actual<={'propext','Classical.choice','Quot.sound'},name
record={'schema':1,'frozen_receipt_sha256':sha(receipt),'bound_artifact_occurrences_verified':count,'unique_artifacts_verified':len(unique),'actual_native_exit_code':0,'exact_declaration_axiom_checks':24,'scope':'Cartesian tensor geometry and actual exact-interface ordered line updates; general logical geometry and method-class coverage are unresolved.','source_acceptance':False,'review_sha256':sha(D/'REVIEW.md')}
p=S/'root-batch7-tensor-lines-verification.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'verification_sha256':sha(p)}))

