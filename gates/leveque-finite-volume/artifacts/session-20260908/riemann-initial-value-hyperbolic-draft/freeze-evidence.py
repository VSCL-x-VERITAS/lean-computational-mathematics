"""Freeze scratch proof, exact source provenance and read-only reuse searches."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess
def xp(p):
 p=str(p);prefix=chr(92)*2+'?'+chr(92)
 return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
P=xp(Path(__file__).resolve().parent);R=P.parents[4]
S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_bytes())
def write(p,v):
 assert not p.exists(),p
 p.write_text(json.dumps(v,indent=2,ensure_ascii=True)+'\n',encoding='utf-8',newline='')
def binding(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
taskdir=S/'audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908'
task=read(taskdir/'audit-task.json');out=taskdir/'faithfulness'
assert sha(out/'decision.json')=='5bcb31b0d05629a35f39086f22f044187188ad043dd38ebebdc8518b6987b825'
assert sha(R/task['source']['path'])==task['source']['sha256']
transport=read(out/'orchestration/a_transport.json')
images=[]
for item in transport['inputs']:
 if item['label'].startswith('primary source image page '):
  p=Path(item['path']);assert sha(p)==item['sha256'];images.append({'label':item['label'],'sha256':item['sha256'],'bytes':len(p.read_bytes())})
assert len(images)==5
searches=[
 ['rg','-n','OneDimensionalHyperbolicConservationLaw|HyperbolicRiemannProblem|IsRiemannInitialValueSolution|IsRealHyperbolicMatrix','ComputationalMathematics','--glob','*.lean'],
 ['rg','-n','RiemannProblem|Riemann problem|quasilinear.*system|hyperbolic.*PDE|IsRealHyperbolicMatrix','.lake/packages/mathlib/Mathlib','--glob','*.lean'],
 ['rg','-n','IsHyperbolic|discr','.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/GeneralLinearGroup/FinTwo.lean'],
 ['rg','-n','IsConstantCoefficientLinearSystemSolutionAt|IsQuasilinearConservationLawSolutionAt|conservationLaw_iff_quasilinearAt|isRiemannData_iff_exists_valueAtOrigin|exists_rectangle_riemann_solution','ComputationalMathematics/Analysis/PartialDifferentialEquations','--glob','*.lean']]
searchrecords=[]
for i,cmd in enumerate(searches,1):
 raw=P/f'search-{i}-output.txt';err=P/f'search-{i}-stderr.txt';assert not raw.exists() and not err.exists()
 with raw.open('xb') as of,err.open('xb') as ef:result=subprocess.run(cmd,cwd=R,stdout=of,stderr=ef)
 assert result.returncode in (0,1)
 searchrecords.append({'command':cmd,'exit_code':result.returncode,'output':binding(raw),'stderr':binding(err)})
selected=[
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/Hyperbolicity.lean','reuse_existing','Real eigenbasis criterion for the actual principal matrix.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean','reuse_existing','Strict initial half-lines and free-origin characterization.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/Riemann.lean','use_as_premise','Generic equation-predicate constructor does not certify hyperbolicity; reuse its underlying data semantics only.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/ConstantCoefficientLinearSystem.lean','reuse_existing','Actual classical derivative residual; exact constant-system bridge.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw.lean','reuse_existing','Actual quasilinear/flux derivative semantics and chain-rule bridge.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean','bridge_or_adjudicate','Real flux derivative and spectral qualification; conservation-law subclass cannot replace all first-order hyperbolic problem data.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RectangleRiemannInterface.lean','reuse_existing','Separate optional rectangle solution relation for the conservation subclass.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean','use_as_premise','Actual eigenbasis solution/existence producer inspected; not needed for the definition target.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRectangleRiemannInterface.lean','use_as_premise','Certified linear solver inspected; no solver premise added to problem classification.'),
 ('.lake/packages/mathlib/Mathlib/LinearAlgebra/Matrix/GeneralLinearGroup/FinTwo.lean','bridge_or_adjudicate','Different GL(2) discriminant classification, not a general PDE governing object.')]
write(P/'reuse-search.json',{'schema':1,'input_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip(),'requested_contract':'A genuine first-order hyperbolic governing equation plus strict two-state initial problem data; no arbitrary solution predicate or hidden framework choice.','searches':searchrecords,'candidates':[{'file':binding(R/p),'disposition':d,'reason':why} for p,d,why in selected],'remaining_prerequisite':'A general concrete first-order equation/initial-data object was not found by these searches; this is recorded search evidence, not a claim of global absence.'})
receipt=read(P/'final-02-exit.json');assert type(receipt['exit_code']) is int and receipt['exit_code']==0
assert sha(P/'GeneralFirstOrder.lean')==sha(P/'final-02-input.lean')==receipt['source_sha256']
assert sha(P/'final-02-output.txt')==receipt['raw_output_sha256']
native=(P/'final-02-output.txt').read_text(encoding='utf-8-sig')
assert re.search(r'\b(?:error|warning):|sorryAx',native) is None
checks=re.findall(r'^#check (\S+)$',(P/'GeneralFirstOrder.lean').read_text(encoding='utf-8'),re.M)
assert len(checks)==13
axioms={}
for name in checks:
 assert re.search(r'^'+re.escape(name)+r'(?:\.\{[^}]*\})?(?:\s|:)',native,re.M)
 lists=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',native)
 assert len(lists)==1
 actual=sorted(x.strip() for x in lists[0].split(',') if x.strip());assert set(actual)<={'propext','Classical.choice','Quot.sound'}
 axioms[name]=actual
record={'schema':1,'frozen_at_utc':datetime.now(timezone.utc).isoformat(),'scope':'Scratch repair/evidence only. No production, gate, ledger, audit, Git index or commit changes; no semantic CLI/model role or subagent.','source':binding(R/task['source']['path']),'source_images_viewed':images,'rejected_task':binding(taskdir/'audit-task.json'),'rejected_decision':binding(out/'decision.json'),'rejected_report':binding(out/'report.md'),'draft':binding(P/'GeneralFirstOrder.lean'),'native_exit':binding(P/'final-02-exit.json'),'native_output':binding(P/'final-02-output.txt'),'actual_exit_code':0,'checked_declarations':axioms,'source_faithfulness':'Not audited or claimed. Problem-data classification makes no solution-framework choice; equal-side naming ambiguity is exposed by distinct broad/jump families.','remaining_interpretation':'Whether the source calls equal-side data a degenerate Riemann problem remains unselected. No solution-theory choice is needed for the problem-data target.','reuse_record':binding(P/'reuse-search.json'),'review':binding(P/'REVIEW.md'),'files':[binding(p) for p in sorted(P.iterdir()) if p.is_file()]}
write(P/'final-evidence.json',record)
print(json.dumps({'status':'scratch-compiled-frozen','source_sha256':receipt['source_sha256'],'native_output_sha256':receipt['raw_output_sha256'],'native_exit_sha256':sha(P/'final-02-exit.json'),'declarations':len(checks),'evidence_sha256':sha(P/'final-evidence.json'),'reuse_sha256':sha(P/'reuse-search.json')}))
