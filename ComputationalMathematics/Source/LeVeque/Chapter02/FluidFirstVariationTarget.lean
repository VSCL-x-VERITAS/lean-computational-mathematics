/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FirstVariationTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FluidStateFluxModel

/-!
# Two-component linearized fluid equation
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.44) at a positive-density constant fluid background. -/
def fluidFirstVariationTarget : Prop :=
  ∀ (admissibleStates : Set (Fin 2 → ℝ)) (densityBackground velocityBackground : ℝ),
    0 < densityBackground →
    fluidConservedState densityBackground velocityBackground ∈ admissibleStates →
    ∀ (flux : (Fin 2 → ℝ) → (Fin 2 → ℝ))
      (derivative : (Fin 2 → ℝ) →L[ℝ] (Fin 2 → ℝ))
      (perturbation : ℝ → ℝ → (Fin 2 → ℝ)) (x t : ℝ) (qx : Fin 2 → ℝ),
      HasFDerivAt flux derivative (fluidConservedState densityBackground velocityBackground) →
      HasDerivAt (fun ξ => perturbation ξ t) qx x →
      (IsConservationLawSolutionAt perturbation (fun state => derivative state) x t ↔
        ∃ qt : Fin 2 → ℝ, HasDerivAt (fun τ => perturbation x τ) qt t ∧
          qt + (LinearMap.toMatrix' derivative.toLinearMap).mulVec qx = 0)

end NumStability.Leveque02Tracer
