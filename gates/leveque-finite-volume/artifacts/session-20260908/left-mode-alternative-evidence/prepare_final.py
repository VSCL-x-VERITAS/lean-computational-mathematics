"""Append exact native checks and bind selected inputs before the final check."""
from pathlib import Path
import hashlib,json,os,re,shutil,subprocess
D=Path(__file__).resolve().parent
R=D.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bound(p):return {'path':os.path.relpath(p,R).replace('\\','/'),'sha256':sha(p)}
def write(p,x):
    assert not p.exists()
    p.write_text(json.dumps(x,indent=2)+'\n',encoding='utf-8',newline='\n')
fragment=D/'Fixtures.lean.fragment'
names=['NumStability.LeftModeAlternativeEvidence.'+n for n in
 re.findall(r'^(?:def|theorem)\s+(\w+)',fragment.read_text(encoding='utf-8'),re.M)]
assert len(names)==18
old='NumStability.LeftModeDomainsDraft.leftMode_solutionDomains'
reused=['NumStability.linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt',
 'NumStability.travelingWave_isLinearAdvectionSolution_iff',
 'NumStability.travelingWave_isRectangleConservationLawSolution_iff',
 'NumStability.travelingWave_hasDerivAt_characteristic',
 'not_differentiableAt_abs_zero','Continuous.intervalIntegrable',
 'contDiff_fst','contDiff_snd','ContDiff.add','ContDiff.neg']
candidate=D/'Candidate.lean'
assert sha(candidate)=='2f9aa5d76d9490c9056d3398b8e269210885eba3b94a8550667ddc824c27e03e'
tail='\n-- Exact proof-free signature and foundational axiom checks.\n'
tail+='#print NumStability.LinearAcousticsSolution\n#print NumStability.IsLinearAcousticsSolutionAt\n'
for n in names+reused:tail+='#check '+n+'\n#print axioms '+n+'\n'
candidate.write_bytes(candidate.read_bytes()+tail.encode('utf-8'))
write(D/'declaration-list.json',{'new_fixture_declarations':names,'reused_frozen_domain':[old],'canonical_and_mathlib_checks':reused})
S=D.parent
P=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations'
dependencies=[P/(n+'.lean') for n in ['LinearAcoustics','LinearAdvection','LinearAdvectionGlobal',
 'Transport/Characteristics','ConservationLaws/TravelingWaveCharacterization','ConservationLaws/Rectangle']]
M=R/'.lake/packages/mathlib/Mathlib'
dependencies += [M/(n+'.lean') for n in ['Analysis/Calculus/Deriv/Abs',
 'Analysis/Calculus/Deriv/Add','Analysis/Calculus/ContDiff/Operations',
 'Analysis/Calculus/ContDiff/Comp','MeasureTheory/Integral/IntervalIntegral/Basic','Data/Real/Sqrt']]
dependencies += [R/'lean-toolchain',R/'lake-manifest.json',P.parents[1]/'Source/LeVeque/Chapter01/AcousticsModes.lean']
A=S/'audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908'
sources=[S/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf',
 A/'audit-task.json',A/'faithfulness/decision.json',A/'faithfulness/report.md',
 A/'faithfulness/orchestration/page-024.png',
 S/'left-mode-domain-draft/candidate.lean',S/'left-mode-domain-draft/final-receipt.json']
write(D/'inputs-before-final.json',{'candidate':bound(candidate),'fragment':bound(fragment),
 'dependencies':list(map(bound,dependencies)),'source_and_frozen_evidence':list(map(bound,sources)),
 'source_location':'printed Chapter 1 p2 / raw PDF24; left w2 formula and printed q2 profile sentence',
 'pending_interpretation_call':'call_ctzCZ7YK8zbx2yUzmX59YBdC',
 'interpretation_status':'Unanswered. No adoption or source-faithfulness verdict.'})
out=D/'runtime.txt'
argv=[shutil.which('lake'),'env','lean','--version']
assert not out.exists()
with out.open('wb') as f:run=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
write(D/'runtime.json',{'argv':argv,'cwd':str(R),'exit_code':run.returncode,'output':bound(out),
 'os_name':os.name,'python':os.sys.executable,
 'mathlib_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R/'.lake/packages/mathlib',text=True).strip()})
assert run.returncode==0
print(json.dumps({'candidate':bound(candidate),'new_declarations':len(names),'all_unique_checks':1+len(names)+len(reused)}))
