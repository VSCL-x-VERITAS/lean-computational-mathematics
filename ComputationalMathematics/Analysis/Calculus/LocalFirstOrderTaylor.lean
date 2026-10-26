/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor
import Mathlib.Algebra.Order.Group.Pointwise.Interval

/-!
# First-order Taylor control on a local interval

Derivative variation is needed only on the interval between the center
and target point. The convex mean-value inequality bounds the quadratic
remainder in an arbitrary real normed space, without a global Lipschitz budget.
-/

namespace NumStability

theorem norm_firstOrderTaylorError_le_of_local_deriv_variation
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f f' : ℝ → E) (K center x : ℝ) (hK : 0 ≤ K)
    (hf : ∀ y ∈ Set.uIcc center x, HasDerivAt f (f' y) y)
    (hvariation : ∀ y ∈ Set.uIcc center x, ‖f' y - f' center‖ ≤ K * |y - center|) :
    ‖f x - (f center + (x - center) • f' center)‖ ≤ K * (x - center) ^ 2 := by
  let error : ℝ → E := fun y => f y - (f center + (y - center) • f' center)
  have herror (y : ℝ) (hy : y ∈ Set.uIcc center x) :
      HasDerivAt error (f' y - f' center) y := by
    have hlinear : HasDerivAt (fun z : ℝ => f center + (z - center) • f' center) (f' center) y := by
      simpa only [one_smul] using (((hasDerivAt_id y).sub_const center).smul_const (f' center)).const_add (f center)
    exact (hf y hy).sub hlinear
  have hbound (y : ℝ) (hy : y ∈ Set.uIcc center x) :
      ‖f' y - f' center‖ ≤ (K * |x - center|) :=
    (hvariation y hy).trans (mul_le_mul_of_nonneg_left (Set.abs_sub_left_of_mem_uIcc hy) hK)
  have hm := (convex_uIcc center x : Convex ℝ (Set.uIcc center x)).norm_image_sub_le_of_norm_hasDerivWithin_le
    (fun y hy => (herror y hy).hasDerivWithinAt) hbound Set.left_mem_uIcc Set.right_mem_uIcc
  have hm' : ‖f x - (f center + (x - center) • f' center)‖ ≤
      K * (|x - center| * |x - center|) := by
    simpa only [error, sub_self, zero_smul, add_zero, sub_zero, Real.norm_eq_abs,
      mul_assoc] using hm
  simpa only [← pow_two, sq_abs] using hm'

end NumStability
