/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Data.Complex.BigOperators
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-!
# Contraction of finite positive resolutions

Quadratic identities and a pointwise norm estimate for a finite positive
resolution of the identity with unit-modulus coefficients.
-/

open scoped BigOperators InnerProductSpace ComplexConjugate

set_option autoImplicit false
universe u v

namespace NumStability

variable {H : Type u} {ι : Type v} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [Fintype ι]

/-- Quadratic identity for a finite positive resolution, using the convention
that the complex inner product is conjugate-linear in its first argument. -/
theorem positiveResolution_quadratic_sum
    (P : ι → H →ₗ[ℂ] H) (z : ι → ℂ) (A : H →ₗ[ℂ] H)
    (hP : ∀ j, (P j).IsPositive)
    (hsum : (∑ j, P j) = LinearMap.id)
    (hA : A = ∑ j, z j • P j)
    (hz : ∀ j, ‖z j‖ = 1) (x y : H) :
    (∑ j, ⟪x + conj (z j) • y,
      P j (x + conj (z j) • y)⟫_ℂ) =
      ⟪x, x⟫_ℂ + ⟪y, y⟫_ℂ + ⟪A x, y⟫_ℂ + ⟪y, A x⟫_ℂ := by
  classical
  have hsum_apply (v : H) : (∑ j, P j v) = v := by
    simpa only [LinearMap.sum_apply, LinearMap.id_apply] using
      congrArg (fun T : H →ₗ[ℂ] H => T v) hsum
  have hA_apply (v : H) : (∑ j, z j • P j v) = A v := by
    simpa only [LinearMap.sum_apply, LinearMap.smul_apply] using
      congrArg (fun T : H →ₗ[ℂ] H => T v) hA.symm
  have hdiag (v : H) : (∑ j, ⟪v, P j v⟫_ℂ) = ⟪v, v⟫_ℂ := by
    rw [← inner_sum, hsum_apply]
  have hcross_left : (∑ j, conj (z j) * ⟪x, P j y⟫_ℂ) = ⟪A x, y⟫_ℂ := by
    calc
      (∑ j, conj (z j) * ⟪x, P j y⟫_ℂ) =
          ∑ j, ⟪z j • P j x, y⟫_ℂ := by
        apply Finset.sum_congr rfl
        intro j _
        rw [inner_smul_left, (hP j).isSymmetric x y]
      _ = ⟪∑ j, z j • P j x, y⟫_ℂ := (sum_inner _ _ _).symm
      _ = ⟪A x, y⟫_ℂ := by rw [hA_apply]
  have hcross_right : (∑ j, z j * ⟪y, P j x⟫_ℂ) = ⟪y, A x⟫_ℂ := by
    calc
      (∑ j, z j * ⟪y, P j x⟫_ℂ) =
          ∑ j, ⟪y, z j • P j x⟫_ℂ := by
        apply Finset.sum_congr rfl
        intro j _
        rw [inner_smul_right]
      _ = ⟪y, ∑ j, z j • P j x⟫_ℂ := (inner_sum _ _ _).symm
      _ = ⟪y, A x⟫_ℂ := by rw [hA_apply]
  calc
    (∑ j, ⟪x + conj (z j) • y, P j (x + conj (z j) • y)⟫_ℂ) =
        ∑ j, (⟪x, P j x⟫_ℂ + ⟪y, P j y⟫_ℂ +
          conj (z j) * ⟪x, P j y⟫_ℂ + z j * ⟪y, P j x⟫_ℂ) := by
      apply Finset.sum_congr rfl
      intro j _
      have hunit : z j * conj (z j) = 1 := by
        simpa [hz j] using Complex.mul_conj' (z j)
      simp [map_add, map_smul, inner_add_left, inner_add_right,
        inner_smul_left, inner_smul_right] <;>
        linear_combination ⟪y, P j y⟫_ℂ * hunit
    _ = (∑ j, ⟪x, P j x⟫_ℂ) + (∑ j, ⟪y, P j y⟫_ℂ) +
        (∑ j, conj (z j) * ⟪x, P j y⟫_ℂ) +
        (∑ j, z j * ⟪y, P j x⟫_ℂ) := by
      simp only [Finset.sum_add_distrib]
    _ = ⟪x, x⟫_ℂ + ⟪y, y⟫_ℂ + ⟪A x, y⟫_ℂ + ⟪y, A x⟫_ℂ := by
      rw [hdiag x, hdiag y, hcross_left, hcross_right]

/-- A finite positive resolution of the identity with unit-modulus scalar
coefficients acts contractively. No dimension or nonzero-vector hypothesis is
needed, so this also covers the zero-dimensional space. -/
theorem positiveResolution_norm_apply_le
    (P : ι → H →ₗ[ℂ] H) (z : ι → ℂ) (A : H →ₗ[ℂ] H)
    (hP : ∀ j, (P j).IsPositive)
    (hsum : (∑ j, P j) = LinearMap.id)
    (hA : A = ∑ j, z j • P j)
    (hz : ∀ j, ‖z j‖ = 1) (x : H) : ‖A x‖ ≤ ‖x‖ := by
  classical
  have hquadratic :
      (∑ j, ⟪x - conj (z j) • A x,
        P j (x - conj (z j) • A x)⟫_ℂ) =
        ⟪x, x⟫_ℂ - ⟪A x, A x⟫_ℂ := by
    calc
      (∑ j, ⟪x - conj (z j) • A x,
          P j (x - conj (z j) • A x)⟫_ℂ) =
          ⟪x, x⟫_ℂ + ⟪A x, A x⟫_ℂ +
            -⟪A x, A x⟫_ℂ + -⟪A x, A x⟫_ℂ := by
        simpa only [smul_neg, sub_eq_add_neg, inner_neg_neg,
          inner_neg_left, inner_neg_right, neg_neg] using
          positiveResolution_quadratic_sum P z A hP hsum hA hz x (-A x)
      _ = ⟪x, x⟫_ℂ - ⟪A x, A x⟫_ℂ := by ring
  have hnonneg :
      0 ≤ ∑ j, (⟪x - conj (z j) • A x,
        P j (x - conj (z j) • A x)⟫_ℂ).re := by
    apply Finset.sum_nonneg
    intro j _
    exact (hP j).re_inner_nonneg_right _
  have hreal :
      (∑ j, (⟪x - conj (z j) • A x,
        P j (x - conj (z j) • A x)⟫_ℂ).re) = ‖x‖ ^ 2 - ‖A x‖ ^ 2 := by
    have hself (v : H) : (⟪v, v⟫_ℂ).re = ‖v‖ ^ 2 :=
      (norm_sq_eq_re_inner (𝕜 := ℂ) v).symm
    simpa only [Complex.re_sum, Complex.sub_re, hself] using
      congrArg Complex.re hquadratic
  rw [hreal] at hnonneg
  apply (sq_le_sq₀ (norm_nonneg (A x)) (norm_nonneg x)).mp
  linarith

end NumStability
