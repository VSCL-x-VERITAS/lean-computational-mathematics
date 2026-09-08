"""Root verification of frozen FV placement and actual native checks."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3];D=S/'finite-volume-flux-production'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def nativepath(s):
 s=s.replace('\\','/')
 if re.match(r'^[A-Za-z]:/',s):s='/'+s[0].lower()+s[2:]
 return Path(s)
receipt=D/'final-receipt.json'
assert sha(receipt)=='7741b7ba11f0fdb4a559e2e36e5f0a6b7cd09a8a2c3b6654e42c894888dd89cb'
data=json.loads(receipt.read_bytes());manifest=json.loads((D/'placement-manifest.json').read_bytes())
count=0;unique=set()
def walk(v):
 global count
 if isinstance(v,dict):
  if 'path' in v and 'sha256' in v:
   p=nativepath(v['path']);assert sha(p)==v['sha256'],str(p)
   if 'bytes' in v:assert p.stat().st_size==v['bytes'],str(p)
   count+=1;unique.add(str(p))
  for x in v.values():walk(x)
 elif isinstance(v,list):
  for x in v:walk(x)
walk(data);walk(manifest)
for label in ['build-final','declarations-v2']:
 run=json.loads((D/(label+'-exit.json')).read_bytes())
 assert run['exit_code']==0
 assert run['output_sha256']==sha(D/(label+'-output.txt'))
 for f in run['inputs']:
  assert sha(nativepath(f['path']))==f['sha256']
  assert nativepath(f['path']).read_bytes()==nativepath(f['snapshot']).read_bytes()
 if label=='declarations-v2':
  assert run['argv'][1:]==['env','lean',(D/'declaration-contract-checks-v2.lean').relative_to(R).as_posix()]
output=(D/'declarations-v2-output.txt').read_text(encoding='utf-8-sig')
assert not re.search(r'\b(?:error|warning):|sorryAx',output)
assert output.count('TYPE_PRESERVED ')==14 and output.count('TYPE_BRIDGE_BELOW ')==1
assert 'CHECKED_CANONICAL_DECLARATIONS 15' in output
axioms=data['canonical_axiom_checks']+[data['normalization_bridge_axioms']]
assert len(axioms)==16
for item in axioms:
 name=item['name'];matches=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',output)
 assert len(matches)==1,name
 actual={x.strip() for x in matches[0].split(',') if x.strip()}
 assert actual==set(item['axioms']) and actual<={'propext','Classical.choice','Quot.sound'},name
full=json.loads((S/'fv-foundations-full-build-exit.json').read_bytes())
assert full['exit_code']==0 and full['output_sha256']==sha(S/'fv-foundations-full-build-output.txt')
assert full['argv']==['lake','--quiet','--log-level=error','build']
assert full['input_commit']=='c4bfd6deb756ba46184c9418edc83bda33084719'
agg=json.loads((S/'fv-foundations-analysis-imports.json').read_bytes())
assert sha(R/agg['path'])==agg['after_sha256']
record={'schema':1,'placement_receipt_sha256':sha(receipt),'manifest_sha256':sha(D/'placement-manifest.json'),'bound_artifact_occurrences_verified':count,'unique_bound_artifacts_verified':len(unique),'canonical_declarations':15,'public':13,'private':2,'definitional_type_comparisons':14,'kernel_checked_sub_zero_bridge':1,'allowed_axiom_checks':16,'final_focused_build_actual_exit':0,'declarations_actual_exit':0,'both_root_build_actual_exit':0,'full_build_receipt_sha256':sha(S/'fv-foundations-full-build-exit.json'),'aggregate_receipt_sha256':sha(S/'fv-foundations-analysis-imports.json'),'source_acceptance':False}
out=S/'root-batch7-fv-placement-verification.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'verification_sha256':sha(out)}))

