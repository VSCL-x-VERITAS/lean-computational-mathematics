/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.EigenbasisTransformedSystemTarget

/-!
# The intermediate eigenbasis-transformed system
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.73): the constant-coefficient system's actual derivative
residual is equivalent to its expression after multiplying by the fixed
inverse eigenvector matrix. -/
theorem eigenbasisTransformedSystem : eigenbasisTransformedSystemTarget := by
  intro ι _ _ coefficient eigenvalues eigenbasis _ q x t
  let R : Matrix ι ι ℝ := (Pi.basisFun ℝ ι).toMatrix eigenbasis
  let S : Matrix ι ι ℝ := eigenbasis.toMatrix (Pi.basisFun ℝ ι)
  have hSR : S * R = 1 := by
    simpa [S, R] using
      (Module.Basis.toMatrix_mul_toMatrix_flip
        eigenbasis (Pi.basisFun ℝ ι))
  have hRS : R * S = 1 := by
    simpa [S, R] using
      (Module.Basis.toMatrix_mul_toMatrix_flip
        (Pi.basisFun ℝ ι) eigenbasis)
  have hInv : R⁻¹ = S := Matrix.inv_eq_left_inv hSR
  have hRR : R * R⁻¹ = 1 := by rw [hInv]; exact hRS
  have hcomp : (R⁻¹ * coefficient * R) * R⁻¹ = R⁻¹ * coefficient := by
    calc
      (R⁻¹ * coefficient * R) * R⁻¹ =
          (R⁻¹ * coefficient) * (R * R⁻¹) := by rw [Matrix.mul_assoc]
      _ = R⁻¹ * coefficient := by rw [hRR, Matrix.mul_one]
  have hrewrite (qt qx : ι → ℝ) :
      (R⁻¹).mulVec qt +
          (R⁻¹ * coefficient * R).mulVec ((R⁻¹).mulVec qx) =
        (R⁻¹).mulVec (qt + coefficient.mulVec qx) := by
    calc
      (R⁻¹).mulVec qt +
          (R⁻¹ * coefficient * R).mulVec ((R⁻¹).mulVec qx) =
        (R⁻¹).mulVec qt +
          ((R⁻¹ * coefficient * R) * R⁻¹).mulVec qx := by
            rw [Matrix.mulVec_mulVec]
      _ = (R⁻¹).mulVec qt + (R⁻¹ * coefficient).mulVec qx := by rw [hcomp]
      _ = (R⁻¹).mulVec (qt + coefficient.mulVec qx) := by
        rw [Matrix.mulVec_add, Matrix.mulVec_mulVec]
  change IsConstantCoefficientLinearSystemSolutionAt q coefficient x t ↔
    ∃ qt qx : ι → ℝ,
      HasDerivAt (fun τ => q x τ) qt t ∧
        HasDerivAt (fun ξ => q ξ t) qx x ∧
          (R⁻¹).mulVec qt +
            (R⁻¹ * coefficient * R).mulVec ((R⁻¹).mulVec qx) = 0
  constructor
  · rintro ⟨qt, qx, ht, hx, hzero⟩
    refine ⟨qt, qx, ht, hx, ?_⟩
    rw [hrewrite qt qx, hzero]
    simp
  · rintro ⟨qt, qx, ht, hx, htrans⟩
    refine ⟨qt, qx, ht, hx, ?_⟩
    rw [hrewrite qt qx] at htrans
    have h := congrArg (R.mulVec) htrans
    simpa only [Matrix.mulVec_mulVec, hRR, Matrix.one_mulVec,
      Matrix.mulVec_zero] using h

end NumStability.Leveque02Tracer
