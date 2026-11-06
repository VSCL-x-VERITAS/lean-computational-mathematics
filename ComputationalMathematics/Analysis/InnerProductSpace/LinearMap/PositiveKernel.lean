/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Positive

/-!
# The quadratic zero set of a positive operator

On a finite-dimensional inner-product space, the real quadratic form of a
positive operator vanishes exactly on its kernel. The statement applies over
`RCLike` and includes the zero-dimensional space.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]
variable [FiniteDimensional 𝕜 H]

/-- A positive operator's real quadratic form vanishes exactly where the
operator itself vanishes. -/
theorem positive_re_inner_eq_zero_iff (A : H →ₗ[𝕜] H) (hA : A.IsPositive) (x : H) :
    RCLike.re (inner 𝕜 x (A x)) = 0 ↔ A x = 0 := by
  classical
  constructor
  · intro hx
    have hAc : A.toContinuousLinearMap.IsPositive :=
      (LinearMap.isPositive_toContinuousLinearMap_iff A).mpr hA
    obtain ⟨m, u, hu⟩ := ContinuousLinearMap.isPositive_iff_eq_sum_rankOne.mp hAc
    have hAx : A x = ∑ i : Fin m, inner 𝕜 (u i) x • u i := by
      have h := congrArg (fun T : H →L[𝕜] H => T x) hu
      simpa only [ContinuousLinearMap.sum_apply, InnerProductSpace.rankOne_apply] using h
    have hquad : RCLike.re (inner 𝕜 x (A x)) =
        ∑ i : Fin m, ‖inner 𝕜 (u i) x‖ ^ 2 := by
      rw [hAx, inner_sum, map_sum]
      apply Finset.sum_congr rfl
      intro i _
      rw [inner_smul_right, ← inner_conj_symm (𝕜 := 𝕜) x (u i),
        RCLike.mul_conj, RCLike.re_ofReal_pow]
    have hsum : (∑ i : Fin m, ‖inner 𝕜 (u i) x‖ ^ 2) = 0 := hquad.symm.trans hx
    have hterms := (Finset.sum_eq_zero_iff_of_nonneg
      (fun i (_ : i ∈ (Finset.univ : Finset (Fin m))) =>
        sq_nonneg ‖inner 𝕜 (u i) x‖)).mp hsum
    rw [hAx]
    apply Finset.sum_eq_zero
    intro i _
    have hi : inner 𝕜 (u i) x = 0 :=
      norm_eq_zero.mp (sq_eq_zero_iff.mp (hterms i (Finset.mem_univ i)))
    rw [hi, zero_smul]
  · intro hx
    simp only [hx, inner_zero_right, map_zero]

end NumStability
