"""Bind the two independently reviewed production packets into one exposure inventory."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
a=S/'root-information-method-production-verification.json';b=S/'root-information-coordinate-production-verification.json'
assert sha(a)=='c3c9d7120d9e2976c3f7743b58546701b379331f67d07dbad801384b415289e4'
for p in [a,b]:
 v=read(p);assert v['status']=='PASS' and v['source_acceptance'] is False
assert read(b)['all_axiom_reports']==199 and read(b)['native_exit']==0
mp=S/'information-method-production/placement-map.json';cp=S/'information-coordinate-production/normalized-files.json'
assert sha(mp)==read(a)['placement_map_sha256']
assert sha(cp)=='adf2b7741f00bba2aa3c9dd48b37e6729c4613346081a3011325666d1a95751c'
files=[]
for f in read(mp)['new_files']:
 path=Path(f['path']).relative_to(R).as_posix()
 files.append(dict(path=path,module=path[:-5].replace('/','.'),sha256=f['sha256'],declarations=f['declarations'],lines=f['lines']))
files+=read(cp)['files']
assert len(files)==len({f['path'] for f in files})==9
assert sum(len(f['declarations']) for f in files)==65
for f in files:
 p=R/f['path'];assert sha(p)==f['sha256']
 assert len(p.read_text(encoding='utf-8').splitlines())==f['lines']
 assert f['module']==f['path'][:-5].replace('/','.')
 assert b'\r' not in p.read_bytes()
v=dict(schema=1,status='PASS',source_acceptance=False,reviewed_at_utc=datetime.now(timezone.utc).isoformat(),files=files,public_declarations=65,lines=sum(f['lines'] for f in files),root_verifications=[bind(a),bind(b)],inventories=[bind(mp),bind(cp)],review='All nine complete production files and explicit preservation comparisons reviewed. The five coordinate leaves preserve recursive sweep admission by compiled propositional transport and old grid observations at their axis projection. The information core has no returned-field requirement; field obligations occur in the explicit adapter. Full-line Cartesian flux processing and measured balances are generic; examples show positive finite-step nonvacuity only. No source choice, global completion or source acceptance is inferred.')
p=S/'root-batch10-production-placement-verification.json'
with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(v,f,indent=2);f.write('\n')
print(json.dumps(dict(status='PASS',sha256=sha(p),files=9,declarations=65,lines=v['lines'])))

