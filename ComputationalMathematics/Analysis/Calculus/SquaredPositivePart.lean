/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.Piecewise
import Mathlib.Analysis.Calculus.MeanValue

/-!
# Bounds for the squared positive part

Half the squared positive part has derivative equal to the positive part.
An upper endpoint bound therefore gives a Lipschitz bound on any interval.
-/

namespace NumStability

theorem hasDerivAt_sq_max_zero_div_two (x : ℝ) :
    HasDerivAt (fun y : ℝ => (max 0 y) ^ 2 / 2) (max 0 x) x := by
  convert (hasDerivAt_sq_max_zero x).div_const 2 using 1
  ring

/-- The negative quadratic half-flux has derivative equal to the negative part. -/
theorem hasDerivAt_sq_min_zero_div_two (x : ℝ) :
    HasDerivAt (fun y : ℝ => (min 0 y) ^ 2 / 2) (min 0 x) x := by
  have hid (y : ℝ) : max 0 (-y) = -min 0 y := by
    simpa only [neg_zero] using max_neg_neg (0 : ℝ) y
  have h := (hasDerivAt_sq_max_zero_div_two (-x)).comp x ((hasDerivAt_id x).neg)
  simpa only [Function.comp_def, hid, neg_sq, neg_mul_neg, mul_one] using h

/-- A bounded Lipschitz profile times a bounded Lipschitz factor has the
usual sum of the two product Lipschitz constants. -/
theorem abs_bounded_product_sub_le
    (f g : ℝ → ℝ) (B M L K : ℝ) (hB : 0 ≤ B) (hL : 0 ≤ L)
    (hf : ∀ x, |f x| ≤ B) (hg : ∀ x, |g x| ≤ M)
    (hfLip : ∀ x y, |f x - f y| ≤ L * |x - y|)
    (hgLip : ∀ x y, |g x - g y| ≤ K * |x - y|) (x y : ℝ) :
    |f x * g x - f y * g y| ≤ (B * K + L * M) * |x - y| := by
  calc
    _ = |f x * (g x - g y) + (f x - f y) * g y| := by congr 1; ring
    _ ≤ |f x * (g x - g y)| + |(f x - f y) * g y| := abs_add_le _ _
    _ = |f x| * |g x - g y| + |f x - f y| * |g y| := by rw [abs_mul, abs_mul]
    _ ≤ B * (K * |x - y|) + (L * |x - y|) * M := by
      exact add_le_add (mul_le_mul (hf x) (hgLip x y) (abs_nonneg _) hB)
        (mul_le_mul (hfLip x y) (hg y) (abs_nonneg _) (mul_nonneg hL (abs_nonneg _)))
    _ = _ := by ring

/-- Truncating the value factor to its positive part preserves the product
Lipschitz bound for a half-flux derivative. -/
theorem sq_max_zero_comp_deriv_lipschitz
    (f f' : ℝ → ℝ) (B M K : ℝ) (hB : 0 ≤ B) (hM : 0 ≤ M)
    (hvalue : ∀ x, |f x| ≤ B) (hderiv : ∀ x, |f' x| ≤ M)
    (hvalueLip : ∀ x y, |f x - f y| ≤ M * |x - y|)
    (hLip : ∀ x y, |f' x - f' y| ≤ K * |x - y|) (x y : ℝ) :
    |max 0 (f x) * f' x - max 0 (f y) * f' y| ≤ (B * K + M ^ 2) * |x - y| := by
  have hb (z : ℝ) : |max 0 (f z)| ≤ B := by
    rw [abs_of_nonneg (le_max_left _ _)]
    exact max_le hB ((le_abs_self _).trans (hvalue z))
  have hmaxLip (a b : ℝ) : |max 0 (f a) - max 0 (f b)| ≤ M * |a - b| := by
    have h : |max 0 (f a) - max 0 (f b)| ≤ |f a - f b| := by
      simpa only [sub_self, abs_zero, max_eq_right (abs_nonneg (f a - f b))] using
        abs_max_sub_max_le_max (0 : ℝ) (f a) 0 (f b)
    exact h.trans (hvalueLip a b)
  simpa only [pow_two] using abs_bounded_product_sub_le
    (fun z => max 0 (f z)) f' B M M K hB hM hb hderiv hmaxLip hLip x y

/-- The corresponding negative-part derivative bound follows by reflection. -/
theorem sq_min_zero_comp_deriv_lipschitz
    (f f' : ℝ → ℝ) (B M K : ℝ) (hB : 0 ≤ B) (hM : 0 ≤ M)
    (hvalue : ∀ x, |f x| ≤ B) (hderiv : ∀ x, |f' x| ≤ M)
    (hvalueLip : ∀ x y, |f x - f y| ≤ M * |x - y|)
    (hLip : ∀ x y, |f' x - f' y| ≤ K * |x - y|) (x y : ℝ) :
    |min 0 (f x) * f' x - min 0 (f y) * f' y| ≤ (B * K + M ^ 2) * |x - y| := by
  have hid (z : ℝ) : max 0 (-f z) = -min 0 (f z) := by
    simpa only [neg_zero] using max_neg_neg (0 : ℝ) (f z)
  have h := sq_max_zero_comp_deriv_lipschitz (fun z => -f z) (fun z => -f' z)
    B M K hB hM (by simpa only [abs_neg] using hvalue)
    (by simpa only [abs_neg] using hderiv)
    (by simpa only [neg_sub_neg, abs_sub_comm] using hvalueLip)
    (by simpa only [neg_sub_neg, abs_sub_comm] using hLip) x y
  simpa only [hid, neg_mul_neg] using h

/-- The positive quadratic half-flux is Lipschitz on each half-line
with a nonnegative upper bound. No lower bound is needed. -/
theorem abs_sq_max_zero_div_two_sub_le
    (bound a b : ℝ) (hbound : 0 ≤ bound) (ha : a ≤ bound) (hb : b ≤ bound) :
    |(max 0 a) ^ 2 / 2 - (max 0 b) ^ 2 / 2| ≤ bound * |a - b| := by
  have hordered (x y : ℝ) (hxy : x ≤ y) (hy : y ≤ bound) :
      |(max 0 y) ^ 2 / 2 - (max 0 x) ^ 2 / 2| ≤ bound * (y - x) := by
    have hnorm (z : ℝ) (hz : z ∈ Set.Ico x y) : ‖max 0 z‖ ≤ bound := by
      rw [Real.norm_eq_abs, abs_of_nonneg (le_max_left 0 z)]
      exact max_le hbound (hz.2.le.trans hy)
    simpa only [Real.norm_eq_abs] using
      norm_image_sub_le_of_norm_deriv_le_segment'
        (fun z _ => (hasDerivAt_sq_max_zero_div_two z).hasDerivWithinAt)
        hnorm y (Set.right_mem_Icc.mpr hxy)
  rcases le_total a b with hab | hba
  · rw [abs_sub_comm ((max 0 a) ^ 2 / 2) ((max 0 b) ^ 2 / 2),
      abs_sub_comm a b, abs_of_nonneg (sub_nonneg.mpr hab)]
    exact hordered a b hab hb
  · rw [abs_of_nonneg (sub_nonneg.mpr hba)]
    exact hordered b a hba ha

end NumStability
