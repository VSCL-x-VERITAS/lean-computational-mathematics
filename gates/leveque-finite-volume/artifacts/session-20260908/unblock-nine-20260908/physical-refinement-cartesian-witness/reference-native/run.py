"""Capture native canonical-import Lean checks; append-only attempts."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,shutil,subprocess,sys,time
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
U=P.parent.parent
exec(compile((U/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
def native(p):return '\\\\?\\'+str(p.resolve())
def ref(p):
 b=p.read_bytes();return {'path':str(p.resolve()),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def put(p,x):
 b=x if isinstance(x,bytes) else (json.dumps(x,indent=2,ensure_ascii=False)+'\n').encode()
 with p.open('xb') as f:f.write(b)
 return ref(p)
attempt=sys.argv[1];assert re.fullmatch('native-[0-9]{2}',attempt)
A=P/attempt
def capture(name,command):
 start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
 out=A/(name+'-output.txt');err=A/(name+'-stderr.txt')
 with out.open('xb') as o,err.open('xb') as e:r=subprocess.run(command,cwd=R,stdout=o,stderr=e)
 item={'command':command,'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
  'elapsed_seconds':time.monotonic()-tick,'exit_code':r.returncode,'stdout':ref(out),'stderr':ref(err)}
 put(A/(name+'-receipt.json'),item)
 print(json.dumps({'name':name,'exit_code':r.returncode,'elapsed_seconds':item['elapsed_seconds']}),flush=True)
 if r.returncode:print(out.read_text(encoding='utf-8')[-14000:],flush=True)
 return item
if '--child' not in sys.argv:
 A.mkdir()
 result=capture('lake',[str(Path.home()/'.elan/bin/lake.exe'),'env',sys.executable,'-X','utf8','-B',native(P/'run.py'),attempt,'--child'])
 raise SystemExit(result['exit_code'])
assert os.environ.get('LEAN_PATH') and 'overlay' not in os.environ['LEAN_PATH']
candidate=A/'Candidate.lean';put(candidate,(P/'Candidate.lean').read_bytes())
pins=[ref(candidate),ref(P/'Candidate.lean'),ref(P/'run.py'),ref(R/'lean-toolchain'),ref(R/'lake-manifest.json')]
seen=set()
def imports(raw):return re.findall(r'(?m)^import (ComputationalMathematics(?:\.[A-Za-z_0-9]+)+)',raw.decode())
def visit(mod):
 if mod in seen:return
 seen.add(mod);p=R/(mod.replace('.','/')+'.lean');pins.append(ref(p))
 pins.append(ref(R/'.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')))
 for child in imports(p.read_bytes()):visit(child)
for mod in imports(candidate.read_bytes()):visit(mod)
lean=Path(shutil.which('lean'));pins.append(ref(lean))
put(A/'environment.json',{'LEAN_PATH':os.environ['LEAN_PATH'],'lean':ref(lean),'overlay':False,'canonical_imports':True})
dep=capture('deps',[str(lean),'--deps',native(candidate)])
assert dep['exit_code']==0
for line in (A/'deps-output.txt').read_text().splitlines():
 if line.strip():pins.append(ref(Path(line.strip())))
put(A/'input-pins.json',{'inputs':pins,'canonical_project_owners':len(seen)})
result=capture('lean',[str(lean),native(candidate)])
for pin in pins:assert ref(Path(pin['path']))==pin
put(A/'receipt.json',{'candidate':ref(candidate),'native':ref(A/'lean-receipt.json'),
 'input_pins':ref(A/'input-pins.json'),'exit_code':result['exit_code'],'inputs_unchanged':True,
 'canonical_imports':True,'source_judgment':False,'production_changes':False})
raise SystemExit(result['exit_code'])
