"""Place seven checked mathematical owners and two source correspondences in one increment."""
from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip()=='d4c16cc8dd687e5797e4f3c19f3875f1d23b91e4'
P=S/'characteristic-converse-draft/EigenbasisPropagationFinal.lean'
W=S/'discontinuity-general-capstone/candidate.lean'
assert sha(P.read_bytes())=='6364aa0ed693f0de98ea2471c3859bdf76a8971067f86fc99a22b5160f468dc1'
assert sha(W.read_bytes())=='478d5069f3ef5651d80897f0b3a013bb4c38fb8b374e360acdf28a23f23ad855'
assert sha((S/'characteristic-converse-draft/final-receipt.json').read_bytes())=='eb442eb1ee9672f0e46487219d04abc274c9b0a65c8879d8bc48809f0d286c54'
assert sha((S/'general-discontinuity-root-verification.json').read_bytes())=='2bf69f335b7b2fa8331c128335d8157c857dada11a89b8aeb77539dfb29b7e6a'
assert sha((S/'user-discontinuity-interpretation-20260908.json').read_bytes())=='b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
query=['rg','-n','^theorem (linearAdvection_hasDerivAt_characteristic|linearAdvection_eq_travelingWave_of_differentiable|constantCoefficientSystem_characteristicPropagation|stationaryField_constantFlux_residual|vectorStep_not_continuousAt_jump|vectorStep_rectangle_and_discontinuity|exists_discontinuous_rectangle_field|discontinuous_stationary_conservative_residual|not_conservationLawSolutionAt_of_flux_not_continuousAt)|^theorem riemannData_intervalIntegrable|^theorem travelingWave_isRectangleConservationLawSolution|^theorem IsRiemannData.not_continuousAt_zero','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean']
run=subprocess.run(query,cwd=R,capture_output=True);assert run.returncode==0
(S/'general-propagation-discontinuity-placement-search.json').write_text(json.dumps({'schema':1,'argv':query,'exit_code':run.returncode,'stdout':run.stdout.decode(),'stderr':run.stderr.decode(),'selection':'Reuse exact eigenbasis coordinate PDE equivalence, Mathlib chain rule and zero-derivative constancy; generic rectangle mass a.e. theorem, derivative continuity, Riemann-data jump/integrability and translated rectangle solution. These are recorded in the two frozen draft search/review packets. New source wrappers compose these producers.','absence_claim':'Current bounded lexical search only.'},indent=2)+'\n',encoding='utf-8')
prefix='ComputationalMathematics/Analysis/PartialDifferentialEquations/'
ptext=P.read_text();pnames=['linearAdvection_hasDerivAt_characteristic','linearAdvection_eq_travelingWave_of_differentiable','constantCoefficientSystem_characteristicPropagation','leveque01_eigenvalues_completeWavePropagation']
pstarts=[ptext.index('theorem '+n) for n in pnames]+[ptext.index('\nend NumStability')]
ps={n:ptext[pstarts[i]:pstarts[i+1]].strip() for i,n in enumerate(pnames)}
wtext=W.read_text();wnames=['rectangleSolution_discontinuity_comparison','not_conservationLawSolutionAt_of_flux_not_continuousAt','stationaryField_constantFlux_residual','vectorStep_not_continuousAt_jump','vectorStep_rectangle_and_discontinuity','exists_discontinuous_rectangle_field','discontinuous_stationary_conservative_residual']
wstarts=[]
for n in wnames:
 i=wtext.index('theorem '+n);start=wtext.rfind('/--',0,i)
 if n=='vectorStep_not_continuousAt_jump':start=wtext.rfind('omit [Fintype ι] in',0,start)
 wstarts.append(start)
wstarts.append(wtext.index('\nend NumStability.DiscontinuityComparisonDraft'))
ws={n:wtext[wstarts[i]:wstarts[i+1]].strip() for i,n in enumerate(wnames)}
ws[wnames[0]]=ws[wnames[0]].replace('theorem rectangleSolution_discontinuity_comparison','theorem IsRectangleConservationLawSolution.discontinuity_comparison')
classical=prefix+'Transport/ClassicalCharacteristics.lean'
system=prefix+'LinearSystems/CharacteristicPropagation.lean'
disc=prefix+'ConservationLaws/Discontinuity.lean'
moving=prefix+'ConservationLaws/Examples/MovingRiemannJump.lean'
stationary=prefix+'ConservationLaws/Examples/StationaryJump.lean'
mod=lambda path:path[:-5].replace('/','.')
V='variable {ι : Type*} [Fintype ι]\n\n'
common='This correspondence preserves the original printed ambiguity and is subject\nto independent statement auditing; proof compilation alone is not acceptance.'
sourcebody="""theorem leveque01_discontinuity_generalIntegralComparison :
    (∀ (m : ℕ) (q : ℝ → ℝ → Fin m → ℝ)
      (flux : (Fin m → ℝ) → Fin m → ℝ) (x t : ℝ),
      IsRectangleConservationLawSolution q flux →
      ¬ ContinuousAt (fun ξ => q ξ t) x →
      (∀ a b, ∀ᵐ τ, HasDerivAt (fun s => ∫ ξ in a..b, q ξ s)
        (flux (q a τ) - flux (q b τ)) τ) ∧
      (∀ qx, ¬ HasDerivAt (fun ξ => q ξ t) qx x) ∧
      (¬ DifferentiableAt ℝ (fun ξ => q ξ t) x) ∧
      (∀ fluxDerivative : (Fin m → ℝ) → ((Fin m → ℝ) →L[ℝ] (Fin m → ℝ)),
        ¬ IsQuasilinearConservationLawSolutionAt q fluxDerivative x t)) ∧
    (∃ (q : ℝ → ℝ → Fin 1 → ℝ) (flux : (Fin 1 → ℝ) → Fin 1 → ℝ)
      (x t : ℝ), IsRectangleConservationLawSolution q flux ∧ 0 < t ∧
        ¬ ContinuousAt (fun ξ => q ξ t) x) := by
  exact ⟨fun _ _ _ _ _ hrectangle hjump =>
    hrectangle.discontinuity_comparison hjump, exists_discontinuous_rectangle_field⟩
"""
entries=[
(classical,[mod(prefix+'LinearAdvectionGlobal.lean'),'Mathlib.Analysis.Calculus.Deriv.Prod','Mathlib.Analysis.Calculus.MeanValue'],
 'Classical transport along characteristics','For a jointly differentiable field, the advection PDE forces constancy along\neach characteristic and determines the field from its initial profile.\nThe joint differentiability hypothesis is explicit.','variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n'+ps[pnames[0]]+'\n\n'+ps[pnames[1]],pnames[:2]),
(system,[mod(classical),mod(prefix+'LinearSystems/EigenbasisCoordinates.lean')],
 'Propagation of the components of a linear hyperbolic system','An independently supplied jointly differentiable system solution has each\neigenbasis coordinate transported at its eigenvalue. Summing the coordinates\nreconstructs the entire state.',ps[pnames[2]],[pnames[2]]),
('ComputationalMathematics/Source/LeVeque/Chapter01/EigenvaluePropagation.lean',[mod(system)],
 'LeVeque Chapter 1, complete component-wave propagation','LeVeque, printed page 3 (raw PDF page 25), relates each eigenvalue to the\npropagation speed of the corresponding eigenbasis component. A complete basis\nand nonzero eigenvectors are explicit. The characteristic-evolution conclusion\nuses joint differentiability of the supplied field.\n\n'+common,ps[pnames[3]],[pnames[3]]),
(disc,[mod(prefix+'ConservationLaw.lean'),mod(prefix+'ConservationLaws/TemporalDerivative.lean')],
 'Discontinuity and classical conservation-law predicates','Rectangle conservation gives temporal mass differentiation almost everywhere\non each fixed interval. Spatial state discontinuity prevents state derivatives\nand quasilinear classical solutionhood. The conservative residual is excluded\nonly when the spatial composed flux is discontinuous.',V+ws[wnames[0]]+'\n\n'+ws[wnames[1]],['IsRectangleConservationLawSolution.discontinuity_comparison',wnames[1]]),
(moving,[mod(prefix+'FiniteVolume/LinearRiemannSolution.lean'),mod(prefix+'FiniteVolume/RiemannDataRegularity.lean')],
 'Moving vector Riemann jumps','Unequal Riemann states produce a discontinuity along the whole moving jump.\nTheir interval integrability supplies rectangle conservation at every speed,\nindependently of the chosen representative at the jump.',V+'\n\n'.join(ws[n] for n in wnames[3:6]),wnames[3:6]),
(stationary,[mod(prefix+'ConservationLaw.lean'),mod(moving)],
 'Stationary jumps with constant flux','The conservative residual differentiates temporal state and spatial flux.\nA stationary jump with constant flux can therefore satisfy this residual and\nrectangle balance while its spatial state is discontinuous.',V+ws[wnames[2]]+'\n\n'+ws[wnames[6]],[wnames[2],wnames[6]]),
('ComputationalMathematics/Source/LeVeque/Chapter01/DiscontinuityGeneralComparison.lean',[mod(disc),mod(moving)],
 'LeVeque Chapter 1, general discontinuity comparison','LeVeque, printed pages 4-5 (raw PDF pages 26-27), discusses integral balance\nand classical failure at discontinuities around equation (1.10). This theorem\nuses the interpretation adopted by the user on 2026-09-08: rectangle conservation,\nthe mass-rate identity almost everywhere for each fixed interval, and classical\nsolutionhood requiring spatial state differentiability. The exact instruction\nis recorded in user-discontinuity-interpretation-20260908.json in the Chapter 1\nsession artifacts. A genuine finite-vector jump establishes nonvacuity.\n\n'+common,sourcebody,['leveque01_discontinuity_generalIntegralComparison'])]
files=[]
for path,imports,title,doc,body,names in entries:
 dest=R/path;assert not dest.exists();dest.parent.mkdir(parents=True,exist_ok=True)
 text='/-\nSPDX-License-Identifier: MIT\n-/\n\n'+'\n'.join('import '+m for m in imports)+'\n\n/-!\n# '+title+'\n\n'+doc+'\n-/\n\n'
 if path not in [classical,system,'ComputationalMathematics/Source/LeVeque/Chapter01/EigenvaluePropagation.lean']:text+='open MeasureTheory\n\n'
 text+='namespace NumStability\n\n'+body.strip()+'\n\nend NumStability\n'
 dest.write_text(text,encoding='utf-8',newline='\n')
 files.append({'path':path,'sha256':sha(dest.read_bytes()),'declarations':['NumStability.'+n for n in names]})
assert len(files)==7 and sum(len(f['declarations']) for f in files)==12
aggregates=[]
for path,chosen in [('ComputationalMathematics/Analysis.lean',[f for f in files if '/Source/' not in f['path']]),('ComputationalMathematics/Source/LeVeque/Chapter01.lean',[f for f in files if '/Source/' in f['path']])]:
 dest=R/path;before=dest.read_bytes();lines=before.decode().splitlines();ids=[i for i,l in enumerate(lines) if l.startswith('import ')]
 assert ids==list(range(min(ids),max(ids)+1))
 imports={lines[i] for i in ids};added={'import '+mod(f['path']) for f in chosen};assert not imports&added
 lines[min(ids):max(ids)+1]=sorted(imports|added,key=str.casefold)
 dest.write_text('\n'.join(lines)+'\n',encoding='utf-8',newline='\n')
 aggregates.append({'path':path,'before_sha256':sha(before),'sha256':sha(dest.read_bytes())})
check=S/'general-propagation-discontinuity-checks.lean';assert not check.exists()
check.write_text('\n'.join('import '+mod(f['path']) for f in files)+'\n\n'+'\n'.join('#check '+d+'\n#print axioms '+d for f in files for d in f['declarations'])+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'files':files,'aggregates':aggregates,'check_file_sha256':sha(check.read_bytes()),'canonical_validation':'pending','source_acceptance':'Both new source correspondences require fresh independent audits; discontinuity is under exact recorded user interpretation.'}
p=S/'general-propagation-discontinuity-production-inputs.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
paths=[x['path'] for x in files+aggregates]
subprocess.run(['git','-c','core.longpaths=true','add','--',*paths],cwd=R,check=True)
for path in paths:assert subprocess.check_output(['git','cat-file','blob',':'+path],cwd=R)==(R/path).read_bytes()
print(json.dumps({'placed_files':len(files),'new_declarations':12,'manifest_sha256':sha(p.read_bytes()),'exact_staged_bytes':True}))

