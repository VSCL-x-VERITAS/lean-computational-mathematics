/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.SingularValues.Basic
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Operator and Frobenius norm comparison

The comparison in Bhatia, Matrix Analysis (1997), Section I.2,
printed page 7 / PDF page 19. The operator acts on an arbitrary
finite-dimensional complex Hilbert space. The Frobenius norm forwards to
the existing matrix norm through an orthonormal coordinate basis.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The existing matrix Frobenius norm in orthonormal coordinates. -/
noncomputable def operatorFrobeniusNorm {H : Type u} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H) : ℝ :=
  let e := stdOrthonormalBasis ℂ H
  NumStability.complexMatrixFrobenius (LinearMap.toMatrix e.toBasis e.toBasis A)

/-- Bhatia I.2: the operator norm is bounded by the Frobenius norm, which
is bounded by the square root of the dimension times the operator norm. -/
noncomputable def operatorFrobeniusComparison : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    ‖A.toContinuousLinearMap‖ ≤ operatorFrobeniusNorm A ∧
      operatorFrobeniusNorm A ≤
        Real.sqrt (Module.finrank ℂ H : ℝ) * ‖A.toContinuousLinearMap‖

end NumStability.Bhatia.Chapter01.Targets
