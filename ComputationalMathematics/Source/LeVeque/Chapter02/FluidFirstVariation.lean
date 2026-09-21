/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidFirstVariationTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FirstVariation

/-!
# Linearized fluid equation at a constant background
-/

namespace NumStability.Leveque02Tracer

/-- The first variation gives the fixed-background system in equation (2.44). -/
theorem fluidFirstVariation : fluidFirstVariationTarget := by
  intro admissibleStates densityBackground velocityBackground _hDensity hBackground
  intro flux derivative perturbation x t qx hflux hqx
  exact (firstVariation 2 admissibleStates
    ⟨fluidConservedState densityBackground velocityBackground, hBackground⟩
    flux derivative perturbation x t qx hflux hqx).2

end NumStability.Leveque02Tracer
