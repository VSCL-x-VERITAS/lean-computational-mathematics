/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Eigenspace.Matrix
import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileMatrixEquationTarget

/-!
# Eigenvalue necessity for a nonconstant travelling profile
-/

namespace NumStability.Leveque02Tracer

/-- The eigenvalue conclusion following equation (2.53), with the omitted
nonzero-derivative qualification made explicit.  Equation (2.53) itself still
allows the profile derivative to vanish. -/
def travelingProfileEigenvalueTarget : Prop :=
  ∀ (m : ℕ), 0 < m → ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (profile : ℝ → (Fin m → ℝ)) (profileDerivative : Fin m → ℝ)
      (speed x t : ℝ),
    ContDiff ℝ ⊤ profile →
      HasDerivAt profile profileDerivative (x - speed * t) →
        IsConstantCoefficientLinearSystemSolutionAt
            (travelingWave profile speed) coefficient x t →
          profileDerivative ≠ 0 →
            Module.End.HasEigenvector
                (Matrix.toLin' coefficient) speed profileDerivative ∧
              Module.End.HasEigenvalue (Matrix.toLin' coefficient) speed

end NumStability.Leveque02Tracer
