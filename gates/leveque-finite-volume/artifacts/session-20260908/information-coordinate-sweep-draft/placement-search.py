from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4]
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest())
commands=[['rg','-n',r'\b(TensorGrid|CartesianGrid|CartesianFiniteVolumeGrid|cellBox_volume|tangentialFaceBox_volume|cellVolume_eq_width_mul_area)\b','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean'],['rg','-n',r'^structure OneDimensionalFiniteVolumeGrid|^def OneDimensionalFiniteVolumeGrid\.|^theorem OneDimensionalFiniteVolumeGrid\.|^theorem volume_pi_Ico_toReal|^theorem volume_pi_Ico','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean','.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean']]
items=[]
for i,cmd in enumerate(commands):
 r=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);assert r.returncode==(1 if i==0 else 0)
 p=P/f'placement-search-{i+1}.txt';assert not p.exists();p.write_bytes(r.stdout)
 items.append(dict(command=cmd,exit_code=r.returncode,output=bind(p)))
owners=[R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'/name for name in ['RiemannInterface.lean','CoordinateLineBalance.lean','CoordinateLineSweep.lean','RiemannInformationFluxMethod.lean','RiemannFieldFluxMethodInformation.lean','RiemannInformationFluxError.lean','Examples/LeftStateInformationFlux.lean']]
owners.append(R/'.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean')
p=P/'placement-reuse.json';assert not p.exists();p.write_bytes((json.dumps(dict(searches=items,existing_owners=[bind(x) for x in owners],finding='No named Cartesian/TensorGrid aggregate or selected geometry theorem was found in the current project/Mathlib term search. Canonical one-dimensional grid, product-Lebesgue-volume, and generic coordinate-line update/sweep producers exist; measured Cartesian composition remains in frozen scratch.'),indent=2)+'\n').encode());print(bind(p))
