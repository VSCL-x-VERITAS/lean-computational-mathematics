/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.WholeLineWeightedDiffusion
import ComputationalMathematics.Analysis.Normed.Lp.Maximum
import Mathlib.Tactic.LinearCombination

/-!
# Whole-line finite-energy uniqueness without a coefficient bound

A nonzero square-summable sequence attains its largest absolute coordinate.
The resolvent equation contradicts either a positive maximum or a negative
minimum when every face coefficient is nonnegative. No uniform coefficient
bound or summation-by-parts boundary condition is needed for this argument.
-/

namespace NumStability

/-- Subtracting two literal CN steps gives the step for their actual difference. -/
theorem wholeLineWeightedDiffusionCNStep_sub
    (b : ℤ → ℝ) (width timeStep : ℝ)
    (before₁ after₁ before₂ after₂ : ℤ → ℝ)
    (h₁ : IsWholeLineWeightedDiffusionCNStep b width timeStep before₁ after₁)
    (h₂ : IsWholeLineWeightedDiffusionCNStep b width timeStep before₂ after₂) :
    IsWholeLineWeightedDiffusionCNStep b width timeStep
      (before₁ - before₂) (after₁ - after₂) := by
  intro i
  simp only [Pi.sub_apply]
  linear_combination h₁ i - h₂ i

/-- The homogeneous whole-line CN equation has no nonzero square-summable
solution, even for arbitrarily growing nonnegative face coefficients. -/
theorem wholeLineDiffusion_l2_zero_step
    (b : ℤ → ℝ) (hpos : ∀ i, 0 ≤ b i)
    (width timeStep : ℝ) (htime : 0 ≤ timeStep)
    (u : lp (fun _ : ℤ => ℝ) 2)
    (hstep : IsWholeLineWeightedDiffusionCNStep b width timeStep 0 u) : u = 0 := by
  by_contra hu
  obtain ⟨i, hpeak, hmax⟩ := l2_exists_norm_max_of_ne_zero u hu
  simp only [Real.norm_eq_abs] at hpeak hmax
  have heq : u i = timeStep / 2 *
      ((b (i + 1) * (u (i + 1) - u i) - b i * (u i - u (i - 1))) / width ^ 2) := by
    simpa only [Pi.zero_apply, add_zero, sub_zero] using hstep i
  by_cases hi : 0 ≤ u i
  · have hi' : 0 < u i := by simpa only [abs_of_nonneg hi] using hpeak
    have hright : u (i + 1) ≤ u i :=
      (le_abs_self _).trans (by simpa only [abs_of_nonneg hi] using hmax (i + 1))
    have hleft : u (i - 1) ≤ u i :=
      (le_abs_self _).trans (by simpa only [abs_of_nonneg hi] using hmax (i - 1))
    have hdiv : b (i + 1) * (u (i + 1) - u i) - b i * (u i - u (i - 1)) ≤ 0 :=
      sub_nonpos.mpr ((mul_nonpos_of_nonneg_of_nonpos (hpos _) (sub_nonpos.mpr hright)).trans
        (mul_nonneg (hpos _) (sub_nonneg.mpr hleft)))
    have hrhs := mul_nonpos_of_nonneg_of_nonpos
      (div_nonneg htime (by norm_num : (0 : ℝ) ≤ 2))
      (div_nonpos_of_nonpos_of_nonneg hdiv (sq_nonneg width))
    linarith
  · have hi' : u i < 0 := lt_of_not_ge hi
    have hright : u i ≤ u (i + 1) := by
      have h := hmax (i + 1)
      rw [abs_of_neg hi'] at h
      linarith [neg_abs_le (u (i + 1))]
    have hleft : u i ≤ u (i - 1) := by
      have h := hmax (i - 1)
      rw [abs_of_neg hi'] at h
      linarith [neg_abs_le (u (i - 1))]
    have hdiv : 0 ≤ b (i + 1) * (u (i + 1) - u i) - b i * (u i - u (i - 1)) :=
      sub_nonneg.mpr ((mul_nonpos_of_nonneg_of_nonpos (hpos _) (sub_nonpos.mpr hleft)).trans
        (mul_nonneg (hpos _) (sub_nonneg.mpr hright)))
    have hrhs := mul_nonneg
      (div_nonneg htime (by norm_num : (0 : ℝ) ≤ 2))
      (div_nonneg hdiv (sq_nonneg width))
    linarith

/-- Any two finite-energy solutions of the same literal CN equation agree,
without a boundedness assumption on the nonnegative coefficient sequence. -/
theorem wholeLineDiffusion_l2_step_unique
    (b : ℤ → ℝ) (hpos : ∀ i, 0 ≤ b i)
    (width timeStep : ℝ) (htime : 0 ≤ timeStep)
    (before after₁ after₂ : lp (fun _ : ℤ => ℝ) 2)
    (h₁ : IsWholeLineWeightedDiffusionCNStep b width timeStep before after₁)
    (h₂ : IsWholeLineWeightedDiffusionCNStep b width timeStep before after₂) : after₁ = after₂ := by
  have hd := wholeLineWeightedDiffusionCNStep_sub b width timeStep before after₁ before after₂ h₁ h₂
  have hzero : IsWholeLineWeightedDiffusionCNStep b width timeStep 0 (after₁ - after₂) := by
    simpa only [sub_self, lp.coeFn_sub] using hd
  exact sub_eq_zero.mp (wholeLineDiffusion_l2_zero_step b hpos width timeStep htime
    (after₁ - after₂) hzero)

end NumStability
