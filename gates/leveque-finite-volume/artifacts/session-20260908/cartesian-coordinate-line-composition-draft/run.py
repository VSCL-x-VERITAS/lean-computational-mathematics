"""Native composition checks with exact frozen prerequisite and retained attempts."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,re,subprocess,sys,time
sys.stdout.reconfigure(encoding='utf-8')
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
label=sys.argv[1];assert re.fullmatch('[a-z0-9-]+',label)
source,out,receipt=[P/(label+x) for x in ['-input.lean','-output.txt','-exit.json']]
assert not any(p.exists() for p in [source,out,receipt])
base=S/'dimensional-splitting-lines-draft/final-05-input.lean'
assert sha(base)=='51d5b881df63950ebcbfc3e1d2f51fb8b66d3c4ac9d730dd167b5545f65f0e33'
fragment=P/'Composition.lean.fragment'
decls=re.findall(r'^(?:noncomputable )?(?:def|theorem)\s+(\w+)',fragment.read_text(encoding='utf-8'),re.M)
qualified=['NumStability.CartesianLineCompositionDraft.'+x for x in decls]
prefix=b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep\n\n'
checks='\n'.join(f'#check {x}\n#print axioms {x}' for x in qualified).encode()
assembled=prefix+base.read_bytes()+b'\n\n'+fragment.read_bytes()+b'\n\n'+checks+b'\n'
source.write_bytes(assembled)
modules=re.findall(r'^import ([\w.]+)',assembled.decode(),re.M)
inputs=[base,fragment,P/'run.py',R/'lean-toolchain',R/'lake-manifest.json']
compiled=[]
for module in sorted(set(modules)):
 rel=Path(*module.split('.'))
 if module.startswith('Mathlib.'):
  owner=R/'.lake/packages/mathlib'/rel.with_suffix('.lean')
  olean=R/'.lake/packages/mathlib/.lake/build/lib/lean'/rel.with_suffix('.olean')
 else:
  owner=R/rel.with_suffix('.lean');olean=R/'.lake/build/lib/lean'/rel.with_suffix('.olean')
 assert owner.is_file() and olean.is_file(),module
 inputs.append(owner);compiled.append(olean)
inputs += [R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CoordinateLineBalance.lean',
 R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalFluxBalance.lean',
 R/'.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean']
hashes={p.relative_to(R).as_posix():sha(p) for p in inputs}
oleans={p.relative_to(R).as_posix():sha(p) for p in compiled}
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
assert next(x for x in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if x['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
cmd=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',source.relative_to(R).as_posix()]
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with out.open('xb') as f:run=subprocess.run(cmd,cwd=R,stdout=f,stderr=subprocess.STDOUT)
unchanged=all(sha(R/x)==h for x,h in (hashes|oleans).items())
record=dict(command=cmd,cwd=str(R),started_at_utc=start,completed_at_utc=datetime.now(timezone.utc).isoformat(),
 elapsed_ms=int(1000*(time.monotonic()-tick)),exit_code=run.returncode,input_files=hashes,
 compiled_imports=oleans,inputs_unchanged=unchanged,exact_frozen_base=True,
 assembled_input_sha256=sha(source),output_sha256=sha(out),checked_declarations=qualified)
receipt.write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(dict(receipt=str(receipt),exit_code=run.returncode,elapsed_ms=record['elapsed_ms'],
 checked_declarations=len(qualified),output_sha256=record['output_sha256'])),flush=True)
if run.returncode:
 lines=out.read_text(encoding='utf-8').splitlines();print('\n'.join(x for x in lines if 'error:' in x))
 print('\n'.join(lines[-110:]))
assert unchanged
sys.exit(run.returncode)
