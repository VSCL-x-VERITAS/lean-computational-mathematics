"""Relocate the checked witness and record the exact prospective capstone inputs."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=S/'finite-volume-flux-update-repair/witness-fragment.lean'
w=old.read_text(encoding='utf-8')
changes=[
 ('NumStability.FVFluxUpdateDraft.Witness','NumStability.FVUpdateCapstoneDraft.Witness'),
 ('physicalFaceAverage','timeAveragedPhysicalFaceFlux'),
 ('numericalUpdate_weighted_error','riemannFiniteVolumeUpdate_weighted_error'),
 ('numericalUpdate grid rule 0 1 old 0','riemannFiniteVolumeUpdate grid (1 - 0) old (rule 0 1 old) 0')]
for a,b in changes:
 assert a in w,a;w=w.replace(a,b)
(P/'witness-fragment.lean').write_text(w,encoding='utf-8',newline='')
candidate=(P/'capstone-fragment.lean').read_text(encoding='utf-8')+'\n'+w
names=['NumStability.FVUpdateCapstoneDraft.finiteVolumeUpdate_capstone']
names+=['NumStability.FVUpdateCapstoneDraft.Witness.'+n for n in re.findall(r'^(?:noncomputable )?(?:def|theorem) (\w+)',w,re.M)]
assert len(names)==10,names
(P/'Candidate.lean').write_text(candidate,encoding='utf-8',newline='')
checks=candidate+'\n'+''.join('#check '+n+'\n#print axioms '+n+'\n' for n in names)
(P/'Checks.lean').write_text(checks,encoding='utf-8',newline='')
owners=[
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/PhysicalFluxAverage.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxUpdateError.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxUpdateErrorBounds.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TravelingWaveCharacterization.lean',
 '.lake/packages/mathlib/Mathlib/Analysis/SpecialFunctions/Integrals/Basic.lean',
 'lean-toolchain','lake-manifest.json']
record={'old_witness':old.relative_to(R).as_posix(),'old_witness_sha256':sha(old),'changes':changes,
 'names':names,'files':[{'path':p.relative_to(R).as_posix(),'sha256':sha(p)} for p in [P/'Candidate.lean',P/'Checks.lean']+[R/p for p in owners]],
 'pending_question':'call_1UY4fVuKrjpIIQfhLdeuFoRH','source_acceptance':False}
(P/'inputs-v1.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'declarations':len(names),'candidate_sha256':sha(P/'Candidate.lean'),'checks_sha256':sha(P/'Checks.lean'),'inputs_sha256':sha(P/'inputs-v1.json')}))

