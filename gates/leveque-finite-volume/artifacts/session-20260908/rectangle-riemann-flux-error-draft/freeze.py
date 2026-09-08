"""Freeze the three compiled conditional interface-error results and scoped reuse evidence."""
from pathlib import Path
import hashlib,json,re,subprocess
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,obj):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(obj,indent=2)+'\n')
queries=[['rg','-n','rectangleRiemannInterfaceFlux.*error|PhysicalTrace|norm_oneDimensionalCellAverage_sub_le','ComputationalMathematics/Analysis/PartialDifferentialEquations'],['rg','-n','norm_sub_le_norm_sub_add_norm_sub','--glob','*.lean','.lake/packages/mathlib/Mathlib/Analysis/Normed'],['rg','-n','theorem integral_const|theorem intervalIntegrable_const','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean']]
searches=[]
for i,argv in enumerate(queries,1):
 run=subprocess.run(argv,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert run.returncode in (0,1) and not run.stderr
 out=P/f'search-{i}-output.txt';err=P/f'search-{i}-stderr.txt'
 with out.open('xb') as f:f.write(run.stdout)
 with err.open('xb') as f:f.write(run.stderr)
 searches.append({'argv':argv,'exit_code':run.returncode,'stdout':bind(out),'stderr':bind(err)})
receipt=S/'rectangle-riemann-flux-draft-v2-exit.json';output=S/'rectangle-riemann-flux-draft-v2-output.txt'
rec=read(receipt);assert rec['exit_code']==0 and rec['output_sha256']==sha(output)
assert rec['argv']==['lake','env','lean',(P/'Candidate.lean').relative_to(R).as_posix()]
text=output.read_text(encoding='utf-8-sig');assert not re.search(r'\b(?:error|warning):|sorryAx',text)
names=['NumStability.RectangleFluxErrorDraft.'+n for n in ['interface_error_le','update_error_le','block_mass_error_le']]
axioms=[]
for n in names:
 found=re.search(re.escape("'"+n+"' depends on axioms:")+r'\s*\[([^\]]*)\]',text);assert found,n
 values=[x.strip() for x in found.group(1).split(',') if x.strip()]
 assert set(values)<=set(['propext','Classical.choice','Quot.sound'])
 axioms.append({'declaration':n,'axioms':values})
files=['RectangleRiemannInterface','RiemannInterface','CellAverageEstimates','CellAverage','FluxUpdateErrorBounds','FluxUpdateError','PhysicalFluxAverage','LocalFluxBalance','FluxDifference']
deps=[bind(R/('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'+n+'.lean')) for n in files]
deps.append(bind(R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean'))
record={'schema':1,'candidate':bind(P/'Candidate.lean'),'native_receipt':bind(receipt),'native_output':bind(output),'native_actual':rec,'declarations':axioms,'unchanged_existing_dependencies':deps,'reuse_searches':searches,'selected_producers':['norm_oneDimensionalCellAverage_sub_le','riemannFiniteVolumeUpdate_error_le','riemannFiniteVolumeUpdate_block_mass_error_le','CertifiedRectangleRiemannSolution.solves','intervalIntegral.integral_const','intervalIntegrable_const','norm_sub_le_norm_sub_add_norm_sub'],'rejected_candidates':['LinearRiemannFluxAverage already proves the exact selected linear method case; it does not cover arbitrary nonlinear law and admitted method with independently bounded numerical-flux error.','Constant-state consistency gives no bound for unequal data. It is not used to discharge either error premise.'],'scope':'Generic conditional estimates only, partial solver domain explicit, time step positive, independent global rectangle-conservative field, pointwise solver/trace error premises. Block conclusion is norm of total mass error, not sum of cellwise norms. No order, CFL, convergence, positivity or solvability theorem.','development_note':'v1 actual successful receipt is retained as development history; the final frozen source adds the block-mass result and is bound only to the v2 actual receipt. No v1 source hash is inferred.','source_acceptance':False}
write(P/'manifest.json',record)
print(json.dumps({'manifest':bind(P/'manifest.json'),'candidate':bind(P/'Candidate.lean'),'actual_exit':rec['exit_code'],'declarations':len(names)}))
