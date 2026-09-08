"""Root verifies the frozen draft bytes and successful actual native checks."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3];D=S/'finite-volume-flux-error-estimate'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def nativepath(s):
 s=s.replace('\\','/')
 if re.match(r'^[A-Za-z]:/',s):s='/'+s[0].lower()+s[2:]
 return Path(s)
receipt=D/'final-receipt.json';assert sha(receipt)=='8dea7888d0a07cc3d5b448229aa344a358bd8cb3e0d69f009687c034f49be8b9'
data=json.loads(receipt.read_bytes());count=0
def walk(v):
 global count
 if isinstance(v,dict):
  if 'path' in v and 'sha256' in v:
   p=nativepath(v['path']);assert sha(p)==v['sha256'],str(p)
   if 'bytes' in v:assert p.stat().st_size==v['bytes']
   count+=1
  for x in v.values():walk(x)
 elif isinstance(v,list):
  for x in v:walk(x)
walk(data)
assert (D/'frozen-base.lean').read_bytes()==(S/'finite-volume-flux-update-repair/candidate.lean').read_bytes()
assert data['native_runs'][-2]['exit_code']==data['native_runs'][-1]['exit_code']==0
for source,log,run in [(D/'combined-check.lean',D/'combined-v3-output.txt',data['native_runs'][-2]),(D/'declaration-checks.lean',D/'declarations-output.txt',data['native_runs'][-1])]:
 assert sha(source)==run['source_sha256'] and sha(log)==run['output_sha256']
 assert nativepath(run['source']).resolve()==source.resolve()
 assert run['argv'][1:3]==['env','lean'] and nativepath(run['argv'][3]).resolve()==source.resolve()
 assert not re.search(r'\b(?:error|warning):|sorryAx',log.read_text(encoding='utf-8-sig'))
output=(D/'declarations-output.txt').read_text(encoding='utf-8-sig');check=(D/'declaration-checks.lean').read_text(encoding='utf-8-sig').splitlines()
assert len(data['axiom_checks'])==35
for item in data['axiom_checks']:
 name=item['declaration'];assert '#check '+name in check and '#print axioms '+name in check
 matches=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',output);assert len(matches)==1
 actual={v.strip() for v in matches[0].split(',') if v.strip()}
 assert actual==set(item['axioms']) and actual<={'propext','Classical.choice','Quot.sound'}
record={'schema':1,'receipt_sha256':sha(receipt),'bound_artifact_occurrences_verified':count,'unique_artifacts':len(data['artifacts']),'native_successes_verified':2,'exact_declaration_axiom_checks':35,'source_acceptance':False,'review_sha256':sha(D/'source-and-reuse-review.md')}
p=S/'root-batch6-fv-estimate-verification.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'verification_sha256':sha(p)}))
