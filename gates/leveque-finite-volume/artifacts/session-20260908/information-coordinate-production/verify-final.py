from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
seen={};count=0
def check(name,h):
 global count
 p=R/name;actual=sha(p);assert actual==h,(name,h,actual)
 if name in seen:assert seen[name]==h,name
 seen[name]=h;count+=1
def walk(v):
 if isinstance(v,list):
  for x in v:walk(x)
 elif isinstance(v,dict):
  if isinstance(v.get('path'),str) and isinstance(v.get('sha256'),str):check(v['path'],v['sha256'])
  for k,x in v.items():
   if k in ['dependency_pins','input_files','compiled_production','compiled_imports'] and isinstance(x,dict):
    for name,h in x.items():check(name,h)
   else:walk(x)
receipt=json.loads((P/'final-receipt.json').read_bytes());manifest=json.loads((P/'manifest.json').read_bytes());walk(receipt);walk(manifest)
native=json.loads((R/receipt['native_receipt']['path']).read_bytes());walk(native)
assert native['exit_code']==0 and native['inputs_unchanged']
raw=(R/receipt['native_output']['path']).read_text(encoding='utf-8')
assert not re.search(r'error:|warning:|sorryAx|Error pretty printing',raw)
matches=list(re.finditer(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",raw,re.S))
assert len(matches)==199 and len({m.group(1) for m in matches})==199
for m in matches:assert set(x.strip() for x in (m.group(2) or '').split(',') if x.strip())<={'propext','Classical.choice','Quot.sound'}
authored=[n for f in manifest['files'] for n in f['declarations']];assert len(authored)==len(set(authored))==41
assert set(authored)<={m.group(1) for m in matches}
for f in manifest['files']:
 p=R/f['path'];assert len(p.read_text(encoding='utf-8').splitlines())==f['lines']
 assert f['module']==f['path'][:-5].replace('/','.')
 assert b'\r' not in p.read_bytes()
frozen=(R/manifest['frozen_input']['path']).read_bytes();complete=(R/manifest['complete_input']['path']).read_bytes();assert complete.count(frozen)==1
assert all(sha(R/n)==h for n,h in seen.items())
out=P/'verification.json';assert not out.exists()
v=dict(schema=1,status='PASS',verified_at_utc=datetime.now(timezone.utc).isoformat(),binding_occurrences=count,unique_paths=len(seen),manifest_sha256=sha(P/'manifest.json'),final_receipt_sha256=sha(P/'final-receipt.json'),native_exit=0,all_axiom_reports=199,public_authored_declarations=41,inputs_unchanged=True,source_acceptance=False,verifier_sha256=sha(P/'verify-final.py'))
out.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(json.dumps(v))
