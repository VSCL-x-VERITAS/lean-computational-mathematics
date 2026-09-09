from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[5]
assert (R/'lean-toolchain').exists()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
seen={};count=0
def pin(name,h):
 global count
 assert sha(R/name)==h,name
 if name in seen:assert seen[name]==h
 seen[name]=h;count+=1
def walk(v):
 if isinstance(v,list):
  for x in v:walk(x)
 elif isinstance(v,dict):
  if 'path' in v and 'sha256' in v:pin(v['path'],v['sha256'])
  for k,x in v.items():
   if k=='input_files':
    for n,h in x.items():pin(n,h)
   else:walk(x)
for name in ['final-receipt.json','manifest.json','producer-map.json','check-01-receipt.json','build-01-receipt.json']:walk(json.loads((P/name).read_bytes()))
plan=json.loads((P/'native-plan.json').read_bytes());raw=(P/'check-01-output.txt').read_text(encoding='utf-8')
assert not re.search(r'warning:|error:|sorryAx',raw)
matches=list(re.finditer(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",raw,re.S))
assert len(matches)==40 and {m.group(1) for m in matches}==set(plan['expected_axiom_declarations'])
for m in matches:assert {x.strip() for x in (m.group(2) or '').split(',') if x.strip()}<={'propext','Classical.choice','Quot.sound'}
assert all(sha(R/n)==h for n,h in seen.items())
out=P/'verification.json';assert not out.exists()
v=dict(schema=1,status='PASS',binding_occurrences=count,unique_paths=len(seen),native_axiom_reports=40,inputs_unchanged=True,manifest_sha256=sha(P/'manifest.json'),final_receipt_sha256=sha(P/'final-receipt.json'),source_acceptance=False)
out.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(json.dumps(v))
