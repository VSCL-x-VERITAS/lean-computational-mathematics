/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.SquaredPositivePart
import Mathlib.Analysis.Calculus.Deriv.Pow

/-!
# Backward difference of a smooth half-square

Bounded values, bounded first derivatives and Lipschitz first derivatives
give a first-order backward-difference estimate for the half-square.
-/

namespace NumStability

theorem halfSquare_comp_deriv_lipschitz
    (f f' : ℝ → ℝ) (B M K : ℝ) (hB : 0 ≤ B) (hM : 0 ≤ M)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hvalue : ∀ x, |f x| ≤ B) (hderiv : ∀ x, |f' x| ≤ M)
    (hLip : ∀ x y, |f' x - f' y| ≤ K * |x - y|) (x y : ℝ) :
    |f x * f' x - f y * f' y| ≤ (B * K + M ^ 2) * |x - y| := by
  have hvalueLip (a b : ℝ) : |f a - f b| ≤ M * |a - b| := by
    have h := Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
      (f := f) (f' := f') (s := Set.univ)
      (fun z _ => (hf z).hasDerivWithinAt)
      (fun z _ => by simpa only [Real.norm_eq_abs] using hderiv z)
      (convex_univ : Convex ℝ (Set.univ : Set ℝ)) (Set.mem_univ b) (Set.mem_univ a)
    simpa only [Real.norm_eq_abs] using h
  simpa only [pow_two] using abs_bounded_product_sub_le
    f f' B M M K hB hM hvalue hderiv hvalueLip hLip x y

/-- The half-square backward derivative has an explicit first-order error bound. -/
theorem halfSquare_backwardDifference_error
    (f f' : ℝ → ℝ) (B M K x width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ y, HasDerivAt f (f' y) y)
    (hvalue : ∀ y, |f y| ≤ B) (hderiv : ∀ y, |f' y| ≤ M)
    (hLip : ∀ y z, |f' y - f' z| ≤ K * |y - z|) :
    |(f x ^ 2 / 2 - f (x - width) ^ 2 / 2) / width - f x * f' x| ≤
      (B * K + M ^ 2) * width := by
  have hflux (y : ℝ) : HasDerivAt (fun z => f z ^ 2 / 2) (f y * f' y) y := by
    have hd := ((hf y).pow 2).div_const 2
    apply hd.congr_deriv
    ring
  have hTaylor := firstOrderTaylorError_le_of_lipschitzDeriv
    (fun y => f y ^ 2 / 2) (fun y => f y * f' y) (B * K + M ^ 2)
    x (x - width) (by positivity) hflux
    (halfSquare_comp_deriv_lipschitz f f' B M K hB hM hf hvalue hderiv hLip)
  have hid :
      (f x ^ 2 / 2 - f (x - width) ^ 2 / 2) / width - f x * f' x =
        -(f (x - width) ^ 2 / 2 - (f x ^ 2 / 2 - width * (f x * f' x))) / width := by
    field_simp
    ring
  rw [hid, abs_div, abs_neg, abs_of_pos hwidth]
  apply (div_le_iff₀ hwidth).2
  convert hTaylor using 1 <;> ring_nf

end NumStability
