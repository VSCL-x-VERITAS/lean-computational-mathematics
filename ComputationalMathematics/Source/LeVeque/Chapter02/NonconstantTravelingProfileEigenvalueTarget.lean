/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileMatrixEquationLocalTarget
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# LeVeque Chapter 2: speed and eigenvectors of a nonconstant traveling wave

The eigenvector conclusion requires a nonzero profile derivative at the
particular phase. Nonconstancy of a differentiable profile supplies at least
one such phase and therefore makes the speed an eigenvalue.
-/

namespace NumStability.Leveque02Tracer

/-- A nonconstant differentiable traveling-wave solution has an eigenvalue
speed. Its profile derivative is an eigenvector exactly at phases where that
derivative is nonzero. -/
def nonconstantTravelingProfileEigenvalueTarget : Prop :=
  ∀ (m : ℕ), 0 < m → ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (profile : ℝ → (Fin m → ℝ)) (speed : ℝ),
    Differentiable ℝ profile →
    (∃ ξ₁ ξ₂, profile ξ₁ ≠ profile ξ₂) →
    (∀ x t, IsConstantCoefficientLinearSystemSolutionAt
      (travelingWave profile speed) coefficient x t) →
    Module.End.HasEigenvalue (Matrix.toLin' coefficient) speed ∧
      ∀ ξ, deriv profile ξ ≠ 0 →
        Module.End.HasEigenvector
          (Matrix.toLin' coefficient) speed (deriv profile ξ)

end NumStability.Leveque02Tracer
