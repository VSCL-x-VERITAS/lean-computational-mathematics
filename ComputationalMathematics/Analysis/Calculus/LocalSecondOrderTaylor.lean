/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Tactic.Ring

/-!
# Second-order Taylor control on a local interval

A center-relative variation bound for the second derivative gives a cubic
quadratic-Taylor remainder in any real normed space. Derivative hypotheses
are needed only between the center and target point.
-/

namespace NumStability

theorem norm_secondOrderTaylorError_le_of_local_second_deriv_variation
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f f' f'' : ℝ → E) (K center x : ℝ) (hK : 0 ≤ K)
    (hf : ∀ y ∈ Set.uIcc center x, HasDerivAt f (f' y) y)
    (hf' : ∀ y ∈ Set.uIcc center x, HasDerivAt f' (f'' y) y)
    (hvariation : ∀ y ∈ Set.uIcc center x, ‖f'' y - f'' center‖ ≤ K * |y - center|) :
    ‖f x - (f center + (x - center) • f' center +
      ((x - center) ^ 2 / 2) • f'' center)‖ ≤ K * |x - center| ^ 3 := by
  let error : ℝ → E := fun y => f y -
    (f center + (y - center) • f' center + ((y - center) ^ 2 / 2) • f'' center)
  have herror (y : ℝ) (hy : y ∈ Set.uIcc center x) :
      HasDerivAt error (f' y - (f' center + (y - center) • f'' center)) y := by
    have hquad : HasDerivAt (fun z : ℝ => (z - center) ^ 2 / 2) (y - center) y := by
      have hsub : HasDerivAt (fun z : ℝ => z - center) 1 y := by
        simpa only [id_eq] using (hasDerivAt_id y).sub_const center
      convert (hsub.pow 2).div_const 2 using 1
      norm_num
    have hpoly : HasDerivAt
        (fun z : ℝ => f center + (z - center) • f' center +
          ((z - center) ^ 2 / 2) • f'' center)
        (f' center + (y - center) • f'' center) y := by
      simpa only [one_smul] using
        ((((hasDerivAt_id y).sub_const center).smul_const (f' center)).const_add
          (f center)).add (hquad.smul_const (f'' center))
    exact (hf y hy).sub hpoly
  have hbound (y : ℝ) (hy : y ∈ Set.uIcc center x) :
      ‖f' y - (f' center + (y - center) • f'' center)‖ ≤ K * |x - center| ^ 2 := by
    have hsub : Set.uIcc center y ⊆ Set.uIcc center x := Set.uIcc_subset_uIcc_left hy
    have ht := norm_firstOrderTaylorError_le_of_local_deriv_variation
      f' f'' K center y hK (fun z hz => hf' z (hsub hz))
        (fun z hz => hvariation z (hsub hz))
    calc
      _ ≤ K * (y - center) ^ 2 := ht
      _ ≤ K * |x - center| ^ 2 := by
        apply mul_le_mul_of_nonneg_left _ hK
        rw [← sq_abs (y - center)]
        exact (pow_le_pow_left₀ (abs_nonneg _) (Set.abs_sub_left_of_mem_uIcc hy) 2)
  have hm := (convex_uIcc center x : Convex ℝ (Set.uIcc center x)).norm_image_sub_le_of_norm_hasDerivWithin_le
    (fun y hy => (herror y hy).hasDerivWithinAt) hbound Set.left_mem_uIcc Set.right_mem_uIcc
  have hm' : ‖f x - (f center + (x - center) • f' center +
      ((x - center) ^ 2 / 2) • f'' center)‖ ≤ K * |x - center| ^ 2 * |x - center| := by
    simpa only [error, sub_self, zero_smul, zero_pow (by decide : 2 ≠ 0),
      zero_div, add_zero, sub_zero, Real.norm_eq_abs] using hm
  simpa only [pow_succ, mul_assoc] using hm'

end NumStability
