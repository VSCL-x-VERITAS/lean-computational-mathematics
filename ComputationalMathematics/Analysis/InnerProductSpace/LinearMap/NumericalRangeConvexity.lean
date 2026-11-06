/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.NumericalRange.TwoCoordinates
import Mathlib.Analysis.Normed.Module.RCLike.Basic
import Mathlib.Tactic.Linarith

/-!
# Convexity of the numerical range

The unit-vector numerical range of a complex-linear operator is real convex.
Two unit witnesses either have the same expectation or lie in an actual
orthonormal two-vector coordinate plane, where the complex quadratic-range
convexity theorem applies. The proof needs no finite dimension, completeness,
boundedness or nonzero-space hypothesis.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

private theorem norm_pair_sq (x e : H) (hx : ‖x‖ = 1) (he : ‖e‖ = 1)
    (hxe : inner ℂ x e = 0) (α β : ℂ) :
    ‖α • x + β • e‖ ^ 2 = Complex.normSq α + Complex.normSq β := by
  have ho : inner ℂ (α • x) (β • e) = 0 := by
    simp only [inner_smul_left, inner_smul_right, hxe, mul_zero]
  have h := norm_add_sq_eq_norm_sq_add_norm_sq_of_inner_eq_zero _ _ ho
  simpa only [norm_smul, hx, he, mul_one, ← pow_two,
    ← Complex.normSq_eq_norm_sq] using h

private theorem inner_pair (A : H →ₗ[ℂ] H) (x e : H) (α β : ℂ) :
    inner ℂ (α • x + β • e) (A (α • x + β • e)) =
      star α * (inner ℂ x (A x) * α + inner ℂ x (A e) * β) +
      star β * (inner ℂ e (A x) * α + inner ℂ e (A e) * β) := by
  simp only [map_add, map_smul, inner_add_left, inner_add_right,
    inner_smul_left, inner_smul_right, starRingEnd_apply]
  ring

/-- Toeplitz–Hausdorff convexity for the actual all-unit-vector numerical range
of a complex-linear operator, including on the zero space. -/
theorem convex_numerical_range (A : H →ₗ[ℂ] H) :
    Convex ℝ {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)} := by
  rintro _ ⟨x, hx, rfl⟩ _ ⟨y, hy, rfl⟩ s t hs ht hst
  let c : ℂ := inner ℂ x y
  let d : H := y - c • x
  have hxd : inner ℂ x d = 0 := by
    dsimp only [d, c]
    rw [inner_sub_right, inner_smul_right, inner_self_eq_norm_sq_to_K, hx]
    norm_num
  by_cases hd : d = 0
  · have hyrep : y = c • x := sub_eq_zero.mp hd
    have hc : ‖c‖ = 1 := by
      simpa only [hyrep, norm_smul, hx, mul_one] using hy
    have hcc : star c * c = (1 : ℂ) := by
      simpa only [Complex.star_def, hc, one_pow, Complex.ofReal_one] using Complex.conj_mul' c
    have hvalue : inner ℂ y (A y) = inner ℂ x (A x) := by
      rw [hyrep, map_smul, inner_smul_left, inner_smul_right, starRingEnd_apply, ← mul_assoc, hcc, one_mul]
    refine ⟨x, hx, ?_⟩
    rw [hvalue, ← add_smul, hst, one_smul]
  · let e : H := (‖d‖⁻¹ : ℂ) • d
    have he : ‖e‖ = 1 := norm_smul_inv_norm hd
    have hxe : inner ℂ x e = 0 := by
      dsimp only [e]
      rw [inner_smul_right, hxd, mul_zero]
    have hdrecover : (‖d‖ : ℂ) • e = d := by
      dsimp only [e]
      rw [smul_smul]
      have h : (‖d‖ : ℂ) * (‖d‖⁻¹ : ℂ) = 1 := by
        have hn : ‖d‖ ≠ 0 := norm_ne_zero_iff.mpr hd
        simpa only [Complex.ofReal_mul, Complex.ofReal_inv, Complex.ofReal_one] using
          congrArg (fun r : ℝ => (r : ℂ)) (mul_inv_cancel₀ hn)
      rw [h, one_smul]
    have hyrep : y = c • x + (‖d‖ : ℂ) • e := by
      rw [hdrecover]
      dsimp only [d]
      rw [add_comm, sub_add_cancel]
    have hcoeff : Complex.normSq c + Complex.normSq (‖d‖ : ℂ) = 1 := by
      have hn := norm_pair_sq x e hx he hxe c (‖d‖ : ℂ)
      rw [← hyrep, hy] at hn
      simpa only [one_pow] using hn.symm
    have hQ := convex_two_coordinate_quadratic_range
      (inner ℂ x (A x)) (inner ℂ x (A e)) (inner ℂ e (A x)) (inner ℂ e (A e))
    have hp : ∃ α β : ℂ, Complex.normSq α + Complex.normSq β = 1 ∧
        inner ℂ x (A x) =
          star α * (inner ℂ x (A x) * α + inner ℂ x (A e) * β) +
          star β * (inner ℂ e (A x) * α + inner ℂ e (A e) * β) :=
      ⟨1, 0, by norm_num [Complex.normSq_apply], by simp⟩
    have hq : ∃ α β : ℂ, Complex.normSq α + Complex.normSq β = 1 ∧
        inner ℂ y (A y) =
          star α * (inner ℂ x (A x) * α + inner ℂ x (A e) * β) +
          star β * (inner ℂ e (A x) * α + inner ℂ e (A e) * β) := by
      refine ⟨c, (‖d‖ : ℂ), hcoeff, ?_⟩
      rw [hyrep, inner_pair]
    obtain ⟨α, β, hunit, hvalue⟩ := hQ hp hq hs ht hst
    refine ⟨α • x + β • e, ?_, ?_⟩
    · have hn := norm_pair_sq x e hx he hxe α β
      rw [hunit] at hn
      nlinarith [norm_nonneg (α • x + β • e)]
    · rw [inner_pair]
      exact hvalue

end NumStability
