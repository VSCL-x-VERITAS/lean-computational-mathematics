/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Local traveling-profile reduction

LeVeque (2.53) reduces the constant-matrix PDE for a translated profile to
an equation on its derivative. Only differentiability at the translated
point is needed. The derivative may be zero; an eigenvalue conclusion needs
a separate nonzero assumption.
-/

namespace NumStability.Leveque02Tracer

/-- The pointwise PDE for `q(x,t)=q̄(x-s*t)` is equivalent to (2.53) under
an actual derivative of the profile at `x-s*t`. -/
def travelingProfileMatrixEquationLocalTarget : Prop :=
  ∀ (m : ℕ), 0 < m → ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (profile : ℝ → (Fin m → ℝ)) (profileDerivative : Fin m → ℝ)
      (speed x t : ℝ),
    HasDerivAt profile profileDerivative (x - speed * t) →
      (IsConstantCoefficientLinearSystemSolutionAt
          (travelingWave profile speed) coefficient x t ↔
        coefficient.mulVec profileDerivative = speed • profileDerivative)

end NumStability.Leveque02Tracer
