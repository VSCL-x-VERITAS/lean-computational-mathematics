/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CFLPrincipleFiniteVectorTarget

/-!
# The qualified finite-vector CFL principle

The two concrete data classes use their own fixed-mesh essential domains.
The stability clause composes the actual execution/error identities with either
of the two declared stability estimates and the compatible bounded observation.
The scalar advection consequence retains its separate physical cell-mean norm
hypotheses; no finite-p to point-observation implication is inserted.
-/

universe uE uG uH

namespace NumStability

/-- The exact finite-vector target, with both qualified necessity clauses and
the subordinate all-p physical advection realization. -/
theorem leveque04_cflPrincipleFiniteVector :
    Leveque04CFLPrincipleTargetFiniteVector.{uE, uG, uH} := by
  refine ⟨?_, ?_, ?_⟩
  · intro E _ _ _ _ G update initial observe steps exactValue
    dsimp only
    constructor
    · intro hconverges
      exact boundedContinuous_convergence_essential_lowerLimit exactValue
        (fun n f => observe n
          (representedGridEvolution (update n) (initial n f) (steps n))) hconverges
    · intro hconverges
      exact smoothCompact_convergence_essential_lowerLimit exactValue
        (fun n f => observe n
          (representedGridEvolution (update n) (initial n f) (steps n))) hconverges
  · intro E _ _ _ _ G H _ _ _ _ admissible J hJ update initial reference
      error defect steps dt weight rate horizon hdt hweight hclock hconsistent
      hstable observe exactValue B amplification hobserve hbound hreference
    exact (representedStableEvolution_observation_and_essential_lowerLimits
      admissible J hJ update initial reference error defect steps dt weight rate
      horizon hdt hweight hclock hconsistent hstable observe exactValue B
      amplification hobserve hbound hreference).2
  · exact advectionRefinement_courant_le_of_cellMeanConsistency_stability

end NumStability
