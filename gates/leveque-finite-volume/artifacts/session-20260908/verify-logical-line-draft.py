"""Root verification of the frozen supplied-volume line mathematics, without source acceptance."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3];D=S/'logical-line-balance-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
assert sha(D/'final-receipt.json')=='a6f2a094d7d249dce20807a68b9a223c97dd5e2246297ce86a69add8f188ca04'
assert sha(D/'manifest.json')=='da2e2007fcd6028e2b33da22996dd809409930ec0d4788cec50cd1e901df9fe0'
assert sha(D/'candidate.lean')=='527aa742c248431fb1b73c93d1efc8f602e160c9a83d2d9c880bd17768e1150f'
seen=set();count=0
def walk(obj):
 global count
 if isinstance(obj,dict):
  if 'path' in obj and 'sha256' in obj:
   p=R/obj['path'];assert sha(p)==obj['sha256'],str(p)
   seen.add(str(p.resolve()));count+=1
  for value in obj.values():walk(value)
 elif isinstance(obj,list):
  for value in obj:walk(value)
for p in [D/'final-receipt.json',D/'manifest.json',D/'reuse-provenance.json']:walk(read(p))
m=read(D/'manifest.json');native=read(D/'final-05-exit.json')
assert native['exit_code']==0 and native['input_commit']=='1039d1b103f71c63052002803e46e779776b067d'
assert native['argv'][1:3]==['env','lean'] and native['argv'][0].lower().endswith('lake.exe')
assert (R/native['argv'][3]).resolve()==(D/'final-05-input.lean').resolve()
assert native['input_sha256']==sha(D/'final-05-input.lean') and native['output_sha256']==sha(D/'final-05-output.txt')
assert type(native['elapsed_ms']) is int and native['elapsed_ms']>=0
checks=(D/'final-05-input.lean').read_text(encoding='utf-8-sig').splitlines()
out=(D/'final-05-output.txt').read_text(encoding='utf-8-sig')
assert not re.search(r'\b(?:error|warning):|sorryAx',out)
decls=m['new_axiom_checks']+m['reused_axiom_checks'];assert len(decls)==21
for item in decls:
 name=item['name'];assert '#check '+name in checks and '#print axioms '+name in checks
 found=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',out);assert len(found)==1
 actual={x.strip() for x in found[0].split(',') if x.strip()}
 assert actual==set(item['axioms']) and actual<={'propext','Classical.choice','Quot.sound'}
record={'schema':1,'receipt_sha256':sha(D/'final-receipt.json'),'bound_occurrences':count,'unique_artifacts':len(seen),'actual_native_exit':0,'declaration_axiom_checks':21,'root_review':'Actual coordinate-line restriction, one shared oriented integrated face value, arbitrary supplied positive volumes, existing mass and telescoping producers, actual sequential intermediate state. Example uses volumes 1 and 2 and nonzero update. Generic placement is authorized; no source interpretation, physical geometry, Riemann method certification or high-resolution conclusion is inferred. Cosmetic scratch doc-header marker must be corrected in any new production copy, preserving this frozen source.','source_acceptance':False}
p=S/'root-batch8-logical-line-verification.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'verification_sha256':sha(p)}))
