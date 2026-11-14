/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.CartesianTarget
import Mathlib.Tactic.Abel

/-!
# Bhatia Chapter I: Cartesian decomposition

The prescribed real and imaginary operator parts in Section I.2, printed page 6,
reconstruct every operator and are both Hermitian. The statement applies to every
finite-dimensional complex Hilbert space, including dimension zero.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- The prescribed Cartesian parts reconstruct the operator and are Hermitian. -/
theorem cartesianDecomposition : Targets.cartesianDecomposition.{u} := by
  intro H _ _ _ A
  dsimp only
  have hcoef : Complex.I * (2 * Complex.I)⁻¹ = (2 : ℂ)⁻¹ := by
    rw [mul_inv_rev, ← mul_assoc, mul_inv_cancel₀ Complex.I_ne_zero, one_mul]
  have hsum : (A + LinearMap.adjoint A) + (A - LinearMap.adjoint A) =
      (2 : ℂ) • A := by
    rw [two_smul]
    abel
  have htwo : starRingEnd ℂ (2 : ℂ) = 2 := by
    exact map_natCast (starRingEnd ℂ) 2
  constructor
  · rw [smul_smul, hcoef, ← smul_add, hsum, smul_smul,
      inv_mul_cancel₀ (two_ne_zero : (2 : ℂ) ≠ 0), one_smul]
  constructor
  · simp [map_smulₛₗ, htwo, add_comm]
  · have hconj : starRingEnd ℂ ((2 * Complex.I)⁻¹) = -((2 * Complex.I)⁻¹) := by
      simp [htwo]
    rw [map_smulₛₗ, map_sub, LinearMap.adjoint_adjoint, hconj,
      neg_smul, ← smul_neg, neg_sub]

end NumStability.Bhatia.Chapter01
