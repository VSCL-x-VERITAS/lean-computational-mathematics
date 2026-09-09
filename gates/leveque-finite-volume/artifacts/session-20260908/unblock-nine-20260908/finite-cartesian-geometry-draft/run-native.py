"""Append-only native scratch compilation; exact frozen finite base plus geometry fragment."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,shutil,subprocess,sys,time
F=Path(__file__).resolve().parent;D=F.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name=='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
label=sys.argv[1];assert re.fullmatch(r'[a-z]+[0-9]+',label)
base=D/'directional-reference-repair/Finite.lean'
frozen=D/'directional-reference-repair/execution07-Execution.lean'
assert sha(base)=='e9a5e7ef93ff71d8c9ecc39449cb741f2d400d684d2d78893b5884f8bf80054c'
assert sha(frozen)=='84336c591b80a110c053dd170481dcb4d783af7ea8e0d7818d4597bf508836f0'
base_raw=base.read_bytes();text=base_raw.decode()
body=text[text.index('namespace NumStability.FiniteDirectionalRepair'):text.index('end NumStability.FiniteDirectionalRepair')+len('end NumStability.FiniteDirectionalRepair')]
assert body in frozen.read_text(encoding='utf-8')
fragment=F/'Cartesian.lean.fragment'
prefix=('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry\n'
 'import Mathlib.MeasureTheory.Integral.Pi\n')
input_path=F/(label+'-Input.lean')
with input_path.open('xb') as f:f.write(prefix.encode()+base_raw+b'\n'+fragment.read_bytes())
pins={str(p):ref(p) for p in [base,frozen,fragment,input_path,R/'lean-toolchain',R/'lake-manifest.json',Path(__file__)]}
queue=re.findall(r'^import\s+(\S+)',input_path.read_text(encoding='utf-8'),re.M)
seen=set()
while queue:
 module=queue.pop()
 if module in seen:continue
 seen.add(module)
 if module.startswith('ComputationalMathematics.'):
  p=R/(module.replace('.','/')+'.lean')
  queue+=re.findall(r'^import\s+(\S+)',p.read_text(encoding='utf-8'),re.M)
  for item in [p,R/'.lake/build/lib/lean'/(module.replace('.','/')+'.olean')]:pins[str(item)]=ref(item)
 elif module.startswith('Mathlib.'):
  for item in [R/'.lake/packages/mathlib'/(module.replace('.','/')+'.lean'),R/'.lake/packages/mathlib/.lake/build/lib/lean'/(module.replace('.','/')+'.olean')]:pins[str(item)]=ref(item)
lake=shutil.which('lake');assert lake
argv=[lake,'env','lean',input_path.relative_to(R).as_posix()]
output=F/(label+'-output.txt');start=datetime.now(timezone.utc).isoformat();timer=time.monotonic()
with output.open('xb') as out:p=subprocess.run(argv,cwd=R,stdout=out,stderr=subprocess.STDOUT)
unchanged=all(sha(Path(path))==pin['sha256'] for path,pin in pins.items())
receipt=dict(command=argv,cwd=str(R),exit_code=p.returncode,started_at_utc=start,
 completed_at_utc=datetime.now(timezone.utc).isoformat(),elapsed_seconds=time.monotonic()-timer,
 output=ref(output),input=ref(input_path),inputs=list(pins.values()),inputs_unchanged=unchanged,
 immutable_finite_body_match=True,no_source_gate_or_git_mutation=True)
with (F/(label+'-receipt.json')).open('x',encoding='utf-8') as f:json.dump(receipt,f,indent=2);f.write('\n')
print(json.dumps({'receipt':ref(F/(label+'-receipt.json')),'exit_code':p.returncode,'inputs_unchanged':unchanged}))
print(output.read_text(encoding='utf-8'));assert unchanged
raise SystemExit(p.returncode)
