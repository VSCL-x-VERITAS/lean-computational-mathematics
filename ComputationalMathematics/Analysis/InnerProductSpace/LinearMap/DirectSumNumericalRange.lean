/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.NumericalRangeConvexity
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.InnerProductSpace.ProdL2

/-!
# Numerical range of a Hilbert direct sum

The actual diagonal operator on the L2 product has numerical range equal to the
real convex hull of the union of the two component numerical ranges. Zero
components are handled before normalization, so either summand may be the zero
space. No finite dimension, completeness, nontriviality or normality is needed.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

namespace NumStability

variable {H K : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K]

private theorem recover_normalized (x : H) (hx : x ≠ 0) :
    (‖x‖ : ℂ) • ((‖x‖⁻¹ : ℂ) • x) = x := by
  rw [smul_smul]
  have hn : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
  have h : (‖x‖ : ℂ) * (‖x‖⁻¹ : ℂ) = 1 := by
    simpa only [Complex.ofReal_mul, Complex.ofReal_inv, Complex.ofReal_one] using
      congrArg (fun r : ℝ => (r : ℂ)) (mul_inv_cancel₀ hn)
  rw [h, one_smul]

private theorem expectation_real_smul (A : H →L[ℂ] H) (r : ℝ) (x : H) :
    inner ℂ ((r : ℂ) • x) (A ((r : ℂ) • x)) = r ^ 2 • inner ℂ x (A x) := by
  rw [map_smul, inner_smul_left, inner_smul_right, starRingEnd_apply,
    Complex.star_def, Complex.conj_ofReal, Complex.real_smul, Complex.ofReal_pow]
  ring

/-- The full numerical range of the actual L2 diagonal sum is exactly the real
convex hull of both component ranges, including zero-dimensional summands. -/
theorem numerical_range_l2_direct_sum (A₁ : H →L[ℂ] H) (A₂ : K →L[ℂ] K) :
    let L := WithLp.prodContinuousLinearEquiv 2 ℂ H K
    let D := L.symm.toContinuousLinearMap.comp
      ((A₁.prodMap A₂).comp L.toContinuousLinearMap)
    let W₁ : Set ℂ := {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A₁ x)}
    let W₂ : Set ℂ := {z : ℂ | ∃ y : K, ‖y‖ = 1 ∧ z = inner ℂ y (A₂ y)}
    {z : ℂ | ∃ p : WithLp 2 (H × K), ‖p‖ = 1 ∧ z = inner ℂ p (D p)} =
      convexHull ℝ (W₁ ∪ W₂) := by
  let L := WithLp.prodContinuousLinearEquiv 2 ℂ H K
  let D := L.symm.toContinuousLinearMap.comp
    ((A₁.prodMap A₂).comp L.toContinuousLinearMap)
  let W₁ : Set ℂ := {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A₁ x)}
  let W₂ : Set ℂ := {z : ℂ | ∃ y : K, ‖y‖ = 1 ∧ z = inner ℂ y (A₂ y)}
  let W : Set ℂ := {z : ℂ | ∃ p : WithLp 2 (H × K), ‖p‖ = 1 ∧ z = inner ℂ p (D p)}
  change W = convexHull ℝ (W₁ ∪ W₂)
  have hD (p : WithLp 2 (H × K)) : D p = WithLp.toLp 2 (A₁ p.fst, A₂ p.snd) := rfl
  have heval (p : WithLp 2 (H × K)) :
      inner ℂ p (D p) = inner ℂ p.fst (A₁ p.fst) + inner ℂ p.snd (A₂ p.snd) := by
    rw [hD, WithLp.prod_inner_apply]
    rfl
  have hconv : Convex ℝ W := convex_numerical_range D.toLinearMap
  apply Set.Subset.antisymm
  · rintro z ⟨p, hp, rfl⟩
    rw [heval]
    let x := p.fst
    let y := p.snd
    change inner ℂ x (A₁ x) + inner ℂ y (A₂ y) ∈ convexHull ℝ (W₁ ∪ W₂)
    have hsum : ‖x‖ ^ 2 + ‖y‖ ^ 2 = 1 := by
      have h := WithLp.prod_norm_sq_eq_of_L2 p
      rw [hp] at h
      simpa only [one_pow] using h.symm
    by_cases hx : x = 0
    · have hy : ‖y‖ = 1 := by
        rw [hx, norm_zero, zero_pow (by norm_num), zero_add] at hsum
        nlinarith [norm_nonneg y]
      have hm := subset_convexHull ℝ (W₁ ∪ W₂) (Or.inr (show inner ℂ y (A₂ y) ∈ W₂ from ⟨y, hy, rfl⟩))
      simpa only [hx, inner_zero_left, zero_add] using hm
    · by_cases hy : y = 0
      · have hx' : ‖x‖ = 1 := by
          rw [hy, norm_zero, zero_pow (by norm_num), add_zero] at hsum
          nlinarith [norm_nonneg x]
        have hm := subset_convexHull ℝ (W₁ ∪ W₂) (Or.inl (show inner ℂ x (A₁ x) ∈ W₁ from ⟨x, hx', rfl⟩))
        simpa only [hy, inner_zero_left, add_zero] using hm
      · let u : H := (‖x‖⁻¹ : ℂ) • x
        let v : K := (‖y‖⁻¹ : ℂ) • y
        have hu : ‖u‖ = 1 := norm_smul_inv_norm hx
        have hv : ‖v‖ = 1 := norm_smul_inv_norm hy
        have hxrec : (‖x‖ : ℂ) • u = x := recover_normalized x hx
        have hyrec : (‖y‖ : ℂ) • v = y := recover_normalized y hy
        have hxval : inner ℂ x (A₁ x) = ‖x‖ ^ 2 • inner ℂ u (A₁ u) := by
          have h := expectation_real_smul A₁ ‖x‖ u
          rw [hxrec] at h
          exact h
        have hyval : inner ℂ y (A₂ y) = ‖y‖ ^ 2 • inner ℂ v (A₂ v) := by
          have h := expectation_real_smul A₂ ‖y‖ v
          rw [hyrec] at h
          exact h
        have hm₁ := subset_convexHull ℝ (W₁ ∪ W₂)
          (Or.inl (show inner ℂ u (A₁ u) ∈ W₁ from ⟨u, hu, rfl⟩))
        have hm₂ := subset_convexHull ℝ (W₁ ∪ W₂)
          (Or.inr (show inner ℂ v (A₂ v) ∈ W₂ from ⟨v, hv, rfl⟩))
        have h := (convex_convexHull ℝ (W₁ ∪ W₂)) hm₁ hm₂
          (sq_nonneg ‖x‖) (sq_nonneg ‖y‖) hsum
        rwa [← hxval, ← hyval] at h
  · apply convexHull_min ?_ hconv
    rintro z (hz | hz)
    · rcases hz with ⟨x, hx, rfl⟩
      refine ⟨WithLp.toLp 2 (x, (0 : K)), ?_, ?_⟩
      · simpa only [WithLp.norm_toLp_fst] using hx
      · rw [heval]
        simp
    · rcases hz with ⟨y, hy, rfl⟩
      refine ⟨WithLp.toLp 2 ((0 : H), y), ?_, ?_⟩
      · simpa only [WithLp.norm_toLp_snd] using hy
      · rw [heval]
        simp

end NumStability
