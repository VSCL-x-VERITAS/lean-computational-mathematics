/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineInverse
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineInfluence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineStructure
import ComputationalMathematics.Source.LeVeque.Chapter04.ImplicitDomainFixedGridCorrectionIdentifiedTarget

/-!
# The identified fixed-grid implicit-domain countermodel

The constructed update is the unique bounded solution of the fixed CN step.
Its implicit coefficient graph connects all sites, while its solved map has
no self-influence. This proves the selected fixed-grid correction; the other
readings and the separate book discrepancy procedure remain unchanged.
-/

namespace NumStability

/-- The same solved CN map satisfies every clause of the frozen countermodel. -/
theorem leveque04_implicitDomainFixedGridCorrectionIdentified :
    Leveque04ImplicitDomainFixedGridCorrectionIdentifiedTarget := by
  refine ⟨?_, cnWholeLineStructurallyCoupled_all, ?_⟩
  · intro data hdata
    exact ⟨isBoundedWholeLineData_cnWholeLineUpdate data hdata,
      isCNWholeLineStep_update data hdata,
      fun after hafter hstep =>
        eq_cnWholeLineUpdate_of_isCNWholeLineStep data after hdata hafter hstep⟩
  · intro hall
    exact ((cnWholeLineCoordinateInfluences_iff 0 0).mp (hall 0 0)) rfl

end NumStability
