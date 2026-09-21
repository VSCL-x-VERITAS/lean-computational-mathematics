/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CombinedAdvectionDiffusionFluxTarget

/-!
# LeVeque's combined advection-diffusion flux
-/

namespace NumStability.Leveque02Tracer

/-- The integrated advective and diffusive producers combine to the flux stated
immediately before equation (2.23). -/
theorem combinedAdvectionDiffusionFluxFormula :
    combinedAdvectionDiffusionFluxTarget := by
  intro velocity coefficient state gradient
  simp [combinedAdvectionDiffusionFlux, stateFlux, fickFlux, sub_eq_add_neg]

end NumStability.Leveque02Tracer
