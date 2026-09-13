/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# Constant-matrix conservation systems

The actual derivative of the constant linear flux identifies the conservation
law with the source's constant-coefficient system at a classical point.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.42) is the conservation equation with constant linear flux. -/
def constantSystemTarget : Prop :=
  ∀ (m : ℕ) (q : ℝ → ℝ → (Fin m → ℝ)) (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (x t : ℝ) (qx : Fin m → ℝ),
    HasDerivAt (fun ξ => q ξ t) qx x →
      (IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t ↔
        IsConstantCoefficientLinearSystemSolutionAt q coefficient x t)

end NumStability.Leveque02Tracer
