"""Extract the reviewed generic statement into a new explicit source specialization."""
from pathlib import Path
import hashlib
import json
H = Path(__file__).resolve().parent
R = H.parents[5]
generic = R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannRoutineUpdate.lean'
text = generic.read_text(encoding='utf-8')
start = text.index('    {Result : Problem law')
end = text.index(' := by', start)
contract = text[start:end]
contract = contract.replace('    {Result : Problem law', '    ∀ {Result : Problem law', 1)
contract = contract.replace('    (oldDensity newDensity : ℝ → Fin m → ℝ)\n    (physicalFlux : Face → ℝ → Fin m → ℝ)',
    '''    (q : ℝ → ℝ → Fin m → ℝ) (faceLocation : Face → ℝ)
    (hleftLocation : faceLocation leftFace = a) (hrightLocation : faceLocation rightFace = b)''', 1)
for before, after in [('oldDensity', '(fun x => q x s)'), ('newDensity', '(fun x => q x t)'),
                      ('physicalFlux leftFace', '(fun τ => law.flux (q a τ))'),
                      ('physicalFlux rightFace', '(fun τ => law.flux (q b τ))')]:
    contract = contract.replace(before, after)
contract = contract.replace(' :\n    let problem :=', ',\n    let problem :=', 1)
prefix = '''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutineUpdate

/-!
# Chapter 1: arbitrary Riemann information routines and local flux errors

An information routine is available for every law and ordered admissible
problem without asserting that a physical Riemann solution exists. For any
routine, only the two actual face problems need execution admission. Independent
physical face-flux bounds imply the update estimate directly, including biased
equal-state fluxes. A separate conditional comparison uses supplied same-law,
same-problem finite-time weak references. Exact consistency, returned fields,
global reference existence, entropy, uniqueness and a numerical tolerance are
not prerequisites of this contract. The recorded Q7 accuracy and inherited
rectangle conventions remain separate from printed-source assertions.
-/

open MeasureTheory

namespace NumStability
open LocalRiemannInformation

/-- Unconditional availability precedes the universally quantified execution
and conditional accuracy clauses. Reference existence is never assumed by the
direct physical error estimate; exact equal-state consistency is optional. -/
theorem leveque01_localRiemannRoutineInterface_sourceContract {m : ℕ}
    (law : Law m) (bias : Fin m → ℝ) :
    (∃ (available : Routine law (fun _ => (Fin m → ℝ) × (Fin m → ℝ))
        ((Fin m → ℝ) × (Fin m → ℝ))) (admitted : ∀ problem, available.domain problem),
      ∀ problem, available.extract (problem := problem) (available.solve problem (admitted problem)) =
        (problem.left, problem.right) ∧
        available.flux problem (admitted problem) = law.flux problem.left + bias) ∧
'''
proof = ''' := by
  refine ⟨exists_biasedRoutine law bias, ?_⟩
  intro Result Information routine Cell Face leftCell rightCell old hstates cell leftFace rightFace
    hleftCell hrightCell a b s t hab hst hleftDomain hrightDomain q faceLocation
    hleftLocation hrightLocation holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance
  simpa only [hleftLocation, hrightLocation] using
    (routine_local_interface_contract law routine leftCell rightCell old hstates
      cell leftFace rightFace hleftCell hrightCell hab hst hleftDomain hrightDomain
      (fun x => q x s) (fun x => q x t) (fun face τ => law.flux (q (faceLocation face) τ))
      holdDensity hnewDensity
      (by simpa only [hleftLocation] using hleftFlux)
      (by simpa only [hrightLocation] using hrightFlux)
      (by simpa only [hleftLocation, hrightLocation] using hphysicalBalance))

end NumStability
'''
out = R / 'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalRoutineInterface.lean'
with out.open('xb') as f: f.write((prefix + contract + proof).encode('utf-8'))
record = {'schema': 1, 'generic_path': generic.relative_to(R).as_posix(),
          'generic_sha256': hashlib.sha256(generic.read_bytes()).hexdigest(),
          'source_path': out.relative_to(R).as_posix(), 'source_sha256': hashlib.sha256(out.read_bytes()).hexdigest(),
          'source_acceptance': False, 'purpose': 'Explicit same-law physical specialization plus unconditional routine availability'}
with (H / 'source-initial-placement.json').open('xb') as f: f.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
