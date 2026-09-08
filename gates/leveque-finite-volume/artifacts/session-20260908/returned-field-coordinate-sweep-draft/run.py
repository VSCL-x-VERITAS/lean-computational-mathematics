from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys,time
sys.stdout.reconfigure(encoding='utf-8')
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
label,mode=sys.argv[1:3];assert re.fullmatch('[a-z0-9-]+',label) and mode in ['core','full']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
src=P/(label+'-input.lean');out=P/(label+'-output.txt');receipt=P/(label+'-exit.json')
assert not any(p.exists() for p in [src,out,receipt])
imports=['ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep','ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethod','ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField']
data=(''.join('import '+x+'\n' for x in imports)+'\n').encode()
inputs=[P/'run.py',P/'preparation.json',R/'lean-toolchain',R/'lake-manifest.json']
prep=json.loads((P/'preparation.json').read_bytes())
for b in prep['frozen_inputs']:
 p=R/b['path'];assert sha(p)==b['sha256'],p
 inputs.append(p)
if mode=='full':
 p=S/'cartesian-coordinate-line-composition-draft/final03-input.lean'
 assert sha(p)=='80c1f757cb9f214652494b6b7e4f8e6b962f3af16ea5f59ac955d2ad896d8c67'
 data+=p.read_bytes()+b'\n\n';inputs.append(p)
names=[]
for filename in ['Core.lean.fragment']+(['Specializations.lean.fragment'] if mode=='full' else []):
 p=P/filename;inputs.append(p);t=p.read_text(encoding='utf-8');data+=p.read_bytes()+b'\n\n'
 names+=['NumStability.ReturnedFieldCoordinateSweepDraft.'+x for x in re.findall(r'^(?:noncomputable )?(?:def|theorem)\s+(\w+)',t,re.M)]
data+=('\n'.join(f'#check {x}\n#print axioms {x}' for x in names)+'\n').encode();src.write_bytes(data);inputs.append(src)
compiled={}
for mod in sorted(set(re.findall(r'^import ([\w.]+)',data.decode('utf-8'),re.M))):
 rel=Path(*mod.split('.'));base=R/'.lake/packages/mathlib' if mod.startswith('Mathlib.') else R
 owner=base/rel.with_suffix('.lean');olean=base/'.lake/build/lib/lean'/rel.with_suffix('.olean')
 assert owner.is_file() and olean.is_file(),mod
 inputs.append(owner);compiled[olean.relative_to(R).as_posix()]=sha(olean)
for name in ['CoordinateLineBalance','LocalFluxBalance','RiemannInterface']:
 inputs.append(R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'/f'{name}.lean')
hashes={p.relative_to(R).as_posix():sha(p) for p in inputs}
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
assert next(x for x in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if x['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
cmd=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',src.relative_to(R).as_posix()]
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with out.open('xb') as f:r=subprocess.run(cmd,cwd=R,stdout=f,stderr=subprocess.STDOUT)
unchanged=all(sha(R/p)==h for p,h in (hashes|compiled).items())
rec=dict(schema=1,mode=mode,command=cmd,cwd=str(R),started_at_utc=start,completed_at_utc=datetime.now(timezone.utc).isoformat(),elapsed_ms=int(1000*(time.monotonic()-tick)),exit_code=r.returncode,input_files=hashes,compiled_imports=compiled,inputs_unchanged=unchanged,output_sha256=sha(out),checked_declarations=names)
receipt.write_bytes((json.dumps(rec,indent=2)+'\n').encode());print(json.dumps(dict(exit_code=r.returncode,elapsed_ms=rec['elapsed_ms'],declarations=len(names),output_sha256=rec['output_sha256'])),flush=True)
if r.returncode:print(out.read_text(encoding='utf-8')[-22000:])
assert unchanged
sys.exit(r.returncode)
