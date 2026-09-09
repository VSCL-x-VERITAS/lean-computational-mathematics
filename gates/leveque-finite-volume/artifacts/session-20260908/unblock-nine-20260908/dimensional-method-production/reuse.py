from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest())
commands=[['rg','-n','^(theorem|def|noncomputable def) (cellVolumeAverage_Ioc|cellVolumeAverage_congr|advance_mass_balance|finite_line_mass_balance|advance_line_local|cartesian_full_line_update|reference_rectangle|left_two_stage_nonvacuity|hyperbolicConservationLaw_isHyperbolicFluxAt)', 'ComputationalMathematics/Analysis/PartialDifferentialEquations'],['rg','-n','theorem (ceil_eq_iff|closure_Ioc|integral_dirac)|lemma integrable_dirac', '.lake/packages/mathlib/Mathlib/Algebra/Order/Floor/Ring.lean','.lake/packages/mathlib/Mathlib/Topology/Order/DenselyOrdered.lean','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/Bochner/Basic.lean','.lake/packages/mathlib/Mathlib/MeasureTheory/Function/L1Space/Integrable.lean']]
records=[]
for i,command in enumerate(commands):
 out=P/f'reuse-{i+1}.txt';assert not out.exists()
 run=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);out.write_bytes(run.stdout)
 records.append(dict(command=command,actual_exit_code=run.returncode,output=ref(out)));assert run.returncode==0
record=dict(prior_preimplementation_search=ref(P.parent/'dimensional-method-repair/reuse-search-receipt.json'),current_focused_search=records,
selected=[
 dict(producer='CoordinateLineBalance.advance_mass_balance, finite_line_mass_balance, advance_line_local, sweep',decision='Reuse actual executor and shared-face cancellation; no duplicated executor/locality API.'),
 dict(producer='CartesianCoordinateUpdate.cartesian_full_line_update and CartesianGrid measured volume/face theorems',decision='Reuse actual full-line consumer and measured realization; no new Cartesian grid definition.'),
 dict(producer='cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage',decision='Reuse exact normalization bridge; do not reprove integral basics.'),
 dict(producer='StationaryRiemannField.reference_rectangle',decision='Reuse actual translated-step conservation and identity hyperbolicity. Do not mistake the intentionally stationary inexact field for a conserved solution.'),
 dict(producer='Int.ceil_eq_iff; closure_Ioc; integral_dirac',decision='Actual real topology/measure proof of the unit-interval witness; no artificial topology.'),
 dict(producer='prior frozen DirectionalMethodRepair declarations',decision='Exact generic type/computation preservation through explicit nominal PhysicalData transport; old outputs unchanged.')],
rejections=[dict(candidate='old arbitrary-rule CoordinateSplittingBalance source contract',reason='Conservation/locality alone do not link a numerical method to a physical directional law; historical rejection retained.'),dict(candidate='global OneDimensionalHyperbolicConservationLaw as mandatory law domain',reason='Unnecessary global differentiability/hyperbolicity and all-state restriction; use actual flux functions hyperbolic only on supplied admissible states.')])
(P/'reuse-review.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(ref(P/'reuse-review.json')))
