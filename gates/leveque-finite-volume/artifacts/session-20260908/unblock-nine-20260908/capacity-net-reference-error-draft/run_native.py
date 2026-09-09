"""Immutable native Lean attempt capture, with the exact frozen capacity bridge."""
import hashlib,json,os,re,shutil,subprocess,sys,time
from pathlib import Path
R=Path(r'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
D=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908'
P=D/'capacity-net-reference-error-draft'
native=lambda p:str(p) if str(p).startswith('\\\\?\\') else '\\\\?\\'+os.path.abspath(p)
def raw(p):
 with open(native(p),'rb') as stream:return stream.read()
def ref(p):
 data=raw(p)
 try:name=Path(p).relative_to(R).as_posix()
 except ValueError:name=str(p)
 return {'path':name,'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
def put(p,data):
 os.makedirs(native(p.parent),exist_ok=True)
 if not isinstance(data,bytes):data=(json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode()
 with open(native(p),'xb') as stream:stream.write(data)
 return ref(p)
def capture(label,command,cwd):
 out=A/(label+'-output.txt');err=A/(label+'-stderr.txt');start=time.monotonic()
 with open(native(out),'xb') as stdout,open(native(err),'xb') as stderr:
  proc=subprocess.run(command,cwd=cwd,stdout=stdout,stderr=stderr)
 rec={'command':command,'cwd':str(cwd),'exit_code':proc.returncode,'elapsed_seconds':time.monotonic()-start,
      'stdout':ref(out),'stderr':ref(err)}
 put(A/(label+'-receipt.json'),rec)
 print(json.dumps({'label':label,'exit_code':proc.returncode,'elapsed_seconds':rec['elapsed_seconds']}),flush=True)
 if proc.returncode:
  print(raw(out).decode('utf-8',errors='replace')[-14000:]);print(raw(err).decode('utf-8',errors='replace')[-4000:])
 return rec

attempt=sys.argv[1];assert re.fullmatch(r'native-\d{2}',attempt)
A=P/attempt
if '--child' not in sys.argv:
 os.makedirs(native(A),exist_ok=False)
 result=capture('lake',[r'C:\Users\qed_s\.elan\bin\lake.exe','env',sys.executable,'-X','utf8','-B',str(P/'run_native.py'),attempt,'--child'],R)
 raise SystemExit(result['exit_code'])

bridge=D/'physical-capacity-line-bridge/PhysicalCapacityBridge.lean'
bridge_ref=ref(bridge);assert bridge_ref['sha256']=='c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc'
fragment_ref=ref(P/'NetError.lean.fragment')
put(A/'NetError.lean.fragment',raw(P/'NetError.lean.fragment'))
source= b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError\n'+raw(bridge)+b'\n'+raw(P/'NetError.lean.fragment')
candidate=A/'Candidate.lean';candidate_ref=put(candidate,source)
pins=[bridge_ref,fragment_ref,candidate_ref,ref(P/'run_native.py'),ref(R/'lean-toolchain'),ref(R/'lake-manifest.json')]
seen=set()
def project_imports(data):
 return re.findall(r'(?m)^\s*(?:public\s+)?import\s+(ComputationalMathematics(?:\.[A-Za-z_0-9]+)+)',data.decode('utf-8'))
def visit(mod):
 if mod in seen:return
 seen.add(mod);path=R/(mod.replace('.','/')+'.lean');pins.append(ref(path))
 pins.append(ref(R/'.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')))
 for dep in project_imports(raw(path)):visit(dep)
for mod in project_imports(source):visit(mod)
lean=shutil.which('lean');assert lean
put(A/'environment.json',{'LEAN_PATH':os.environ.get('LEAN_PATH'),'lean':ref(Path(lean)),
                         'overlay':False,'production_build':False})
deps=capture('deps',[lean,'-R',native(R),'--deps',native(candidate)],R)
assert deps['exit_code']==0
for line in raw(R/deps['stdout']['path']).decode('utf-8').splitlines():
 if line.strip():pins.append(ref(Path(line.strip().removeprefix('\\\\?\\'))))
put(A/'input-pins.json',{'inputs':pins,'bridge_embedded_byte_exact':True,'project_import_owners':len(seen)})
result=capture('lean',[lean,'-R',native(R),native(candidate)],R)
for item in pins:
 path=Path(item['path']);path=path if path.is_absolute() else R/path
 assert ref(path)['sha256']==item['sha256'],('input changed',item['path'])
put(A/'receipt.json',{'input':candidate_ref,'input_pins':ref(A/'input-pins.json'),
                    'lean_receipt':ref(A/'lean-receipt.json'),'exit_code':result['exit_code'],
                    'inputs_unchanged':True,'source_acceptance':False})
raise SystemExit(result['exit_code'])
