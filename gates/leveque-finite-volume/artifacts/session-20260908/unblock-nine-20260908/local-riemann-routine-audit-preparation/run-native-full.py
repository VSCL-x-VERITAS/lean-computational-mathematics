"""Print complete native types from already built, frozen Routine owners."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess,sys,time
D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
P=D.parent/'riemann-routine-production'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((P/'manifest.json').read_bytes())
assert sha(P/'manifest.json')=='54942e13c3f38db8e467a5bbd0eab9c3bd919bcf3638d2a146d92f3a650321c0'
pins=[]
for item in manifest['files']+manifest['production_compiled']:
    p=R/item['path'];assert sha(p)==item['sha256'];pins.append({'path':item['path'],'sha256':item['sha256']})
for p in [D/'CompleteTypesFull.lean',R/'lean-toolchain',R/'lake-manifest.json']:
    pins.append({'path':p.relative_to(R).as_posix(),'sha256':sha(p)})
cmd=[str(Path.home()/'.elan/bin/lake.exe'),'env','lean',(D/'CompleteTypesFull.lean').relative_to(R).as_posix()]
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with (D/'native-full-output.txt').open('xb') as o,(D/'native-full-stderr.txt').open('xb') as e:
    p=subprocess.run(cmd,cwd=R,stdout=o,stderr=e)
rec={'schema':1,'command':cmd,'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
    'elapsed_seconds':time.monotonic()-tick,'exit_code':p.returncode,
    'stdout_sha256':sha(D/'native-full-output.txt'),'stderr_sha256':sha(D/'native-full-stderr.txt'),
    'input_pins':pins,'inputs_unchanged':all(sha(R/x['path'])==x['sha256'] for x in pins),
    'runner_sha256':sha(Path(__file__)),'git_invocations':0,'model_role_invocations':0}
with (D/'native-full-exit.json').open('xb') as h:h.write((json.dumps(rec,indent=2)+'\n').encode())
print(json.dumps({k:v for k,v in rec.items() if k!='input_pins'},indent=2))
assert rec['inputs_unchanged']
raise SystemExit(p.returncode)
