/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.ContDiff.Defs
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Matrix equation for a travelling profile
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.53), without the later nonzero-vector eigenvalue inference. -/
def travelingProfileMatrixEquationTarget : Prop :=
  ∀ (m : ℕ), 0 < m → ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (profile : ℝ → (Fin m → ℝ)) (profileDerivative : Fin m → ℝ)
      (speed x t : ℝ),
    ContDiff ℝ ⊤ profile →
      HasDerivAt profile profileDerivative (x - speed * t) →
        IsConstantCoefficientLinearSystemSolutionAt
            (travelingWave profile speed) coefficient x t →
          coefficient.mulVec profileDerivative = speed • profileDerivative

end NumStability.Leveque02Tracer
