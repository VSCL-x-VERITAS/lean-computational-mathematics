from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
frozen=S/'information-coordinate-sweep-draft/placement-reuse.json';prior=json.loads(frozen.read_bytes())
for b in prior['existing_owners']:assert sha(R/b['path'])==b['sha256'],b['path']
cmd=['rg','-n',r'^(?:noncomputable )?(?:def|theorem|structure) (?:advance_line_local|advance_mass_balance|finite_line_mass_balance|sweep|sweep_cons|sweep_two|cellVolume_smul_finiteVolumeCellAverageUpdate|riemannFiniteVolumeUpdate|volume_pi_Ico_toReal|ofField|RiemannInformationFluxMethod)\b','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume','.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean','-g','*.lean']
out=P/'reuse-search-final.txt';assert not out.exists()
with out.open('xb') as stream:r=subprocess.run(cmd,cwd=R,stdout=stream,stderr=subprocess.STDOUT)
assert r.returncode==0
base='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
choices=[
 ('CoordinateLineBalance.lean',['normalFaceFlux','advance','advance_mass_balance','advance_line_local','finite_line_mass_balance'],'Reuse the existing shared-face executor, locality and telescoping balance; no new executor or locality alias.'),
 ('CoordinateLineSweep.lean',['sweep','sweep_cons','sweep_two','sweep_two_mass_balance'],'Reuse exact ordered intermediate-state execution.'),
 ('RiemannInformationFluxMethod.lean',['RiemannInformationFluxMethod','selectedResult','interfaceFlux','interface_execution','interfaceFlux_constant'],'Use the frozen information-only domain/solve/extract/flux contract; add actual-face and stage admission only.'),
 ('RiemannFieldFluxMethodInformation.lean',['ofField','ofField_solve','ofField_interfaceFlux'],'Retain field specialization through the existing adapter and the unchanged frozen explicit specialization checks.'),
 ('RiemannInterface.lean',['OneDimensionalFiniteVolumeGrid','adjacentCellRiemannProblem','riemannFiniteVolumeUpdate'],'Reuse actual ordered local problems, measured one-dimensional cell data and finite-volume update.'),
 ('Examples/LeftStateInformationFlux.lean',['OrderedResult','method'],'Reuse the ordered-pair information-only witness. No field is required and no additional hyperbolicity helper is authored.')]
records=[dict(owner=bind(R/base/path),reviewed_identifiers=names,decision=reason) for path,names,reason in choices]
packet=dict(schema=1,prior_review=bind(frozen),prior_searches=prior['searches'],existing_owners=prior['existing_owners'],current_search=dict(command=cmd,exit_code=r.returncode,output=bind(out)),decisions=records,mathlib=bind(R/'.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean'),mathlib_reuse='Real.volume_pi_Ico_toReal and existing finite product/positive-width identities; no new integration basics.',rejected_duplication=['TensorGrid nominal wrapper','Cell/line aliases','method-family and stripe aliases','advance_line_local forwarding alias','total exact time-one LineSolver restriction'],preserved_boundaries=['No numerical reconstruction algorithm is introduced.','No accuracy/consistency conclusion for arbitrary full-line rules.','No logical-geometry interpretation or source-wrapper selection.'])
target=P/'reuse-review.json';assert not target.exists();target.write_bytes((json.dumps(packet,indent=2)+'\n').encode());print(json.dumps(bind(target)))
