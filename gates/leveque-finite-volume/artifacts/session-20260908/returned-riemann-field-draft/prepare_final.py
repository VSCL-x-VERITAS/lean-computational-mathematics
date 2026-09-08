"""Prepare real native declaration checks and snapshot their current inputs."""
from pathlib import Path
import hashlib, json, os, re, shutil, subprocess
D=Path(__file__).resolve().parent
R=D.parents[4]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def bound(p): return {'path':os.path.relpath(p,R).replace('\\','/'),'sha256':sha(p)}
def write(p,x):
    assert not p.exists()
    p.write_text(json.dumps(x,indent=2)+'\n',encoding='utf-8',newline='\n')
candidate=D/'Candidate.lean'
text=candidate.read_text(encoding='utf-8').split('\n#check ')[0].rstrip()+'\n'
names=[]
ns=[]
for line in text.splitlines():
    if line.startswith('namespace '): ns.append(line.split()[1])
    if line.startswith('end '): ns.pop()
    mt=re.match(r'(?:@\[[^\]]+\]\s*)?(?:noncomputable\s+)?(?:structure|def|theorem)\s+(\w+)',line)
    if mt: names.append('.'.join(ns+[mt[1]]))
assert len(names)==24
reused=[
 'NumStability.norm_oneDimensionalCellAverage_sub_le',
 'NumStability.riemannFiniteVolumeUpdate_error_le',
 'NumStability.rectangleRiemannInterfaceFlux_error_le',
 'NumStability.riemannData_isRiemannData',
 'NumStability.riemannData_intervalIntegrable',
 'NumStability.travelingWave_isRectangleConservationLawSolution',
 'NumStability.linearHyperbolicConservationLaw',
 'Matrix.one_mulVec', 'intervalIntegral.integral_const']
text+='\n-- Proof-free declaration signatures and exact foundational axiom checks.\n'
text+='#print NumStability.ReturnedRiemannDraft.FieldFluxMethod\n'
for name in names+reused: text+='#check '+name+'\n#print axioms '+name+'\n'
candidate.write_text(text,encoding='utf-8',newline='\n')
write(D/'declaration-list.json',{'authored':names,'reused_checks':reused})
F=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
dependencies=[F/(n+'.lean') for n in ['RectangleRiemannInterface','RiemannInterface',
 'CellAverageEstimates','CellAverage','FluxUpdateErrorBounds','FluxUpdateError',
 'PhysicalFluxAverage','RectangleRiemannFluxError','LinearRectangleRiemannInterface',
 'LinearRiemannSolution','RiemannData']]
dependencies += [R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean',
 R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/Hyperbolicity.lean',
 R/'.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean',
 R/'.lake/packages/mathlib/Mathlib/Topology/MetricSpace/Lipschitz.lean',
 R/'lean-toolchain',R/'lake-manifest.json']
S=D.parent
A=S/'audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908'
sources=[S/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf',
 A/'audit-task.json',A/'faithfulness/decision.json',A/'faithfulness/report.md',
 A/'faithfulness/orchestration/page-026.png',A/'faithfulness/orchestration/page-027.png',
 R.parent/'workflow-v5.0.1-local/chapter01-source-review/page-028.png']
write(D/'inputs-before-final.json',{'candidate':bound(candidate),'dependencies':list(map(bound,dependencies)),
 'source_and_context':list(map(bound,sources)),
 'selected_pages':'raw26-27/printed4-5; raw28/printed6 is additional immediate continuation context',
 'source_acceptance':'Not assessed; generic scratch mathematics only.'})
argv=[shutil.which('lake'),'env','lean','--version']
out=D/'runtime.txt'
assert not out.exists()
with out.open('wb') as f: run=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
write(D/'runtime.json',{'argv':argv,'cwd':str(R),'exit_code':run.returncode,'output':bound(out),
 'os_name':os.name,'python':os.sys.executable,
 'mathlib_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R/'.lake/packages/mathlib',text=True).strip()})
assert run.returncode==0
print(json.dumps({'declarations':len(names),'reused_checks':len(reused),'candidate':bound(candidate),'runtime':bound(out)}))
