/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import Mathlib.Tactic.Module

/-!
# Symmetric Taylor errors from local derivative variation

One pair of interval-local Taylor bounds controls both the centered mean
and centered difference. The constants do not depend on the dimension of
the real normed state space, and no global derivative budget is required.
-/

namespace NumStability

theorem local_firstOrderTaylor_symmetric_errors
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f f' : ℝ → E) (K center width : ℝ) (hK : 0 ≤ K) (hwidth : 0 ≤ width)
    (hf : ∀ y ∈ Set.Icc (center - width) (center + width), HasDerivAt f (f' y) y)
    (hvariation : ∀ y ∈ Set.Icc (center - width) (center + width),
      ‖f' y - f' center‖ ≤ K * |y - center|) :
    ‖(1 / 2 : ℝ) • (f (center - width) + f (center + width)) - f center‖ ≤ K * width ^ 2 ∧
    ‖(f (center + width) - f (center - width)) - (2 * width) • f' center‖ ≤ 2 * K * width ^ 2 := by
  have hleftMem : Set.uIcc center (center - width) ⊆ Set.Icc (center - width) (center + width) := by
    intro y hy
    rw [Set.uIcc_of_ge (by linarith : center - width ≤ center)] at hy
    exact ⟨hy.1, by linarith [hy.2]⟩
  have hrightMem : Set.uIcc center (center + width) ⊆ Set.Icc (center - width) (center + width) := by
    intro y hy
    rw [Set.uIcc_of_le (by linarith : center ≤ center + width)] at hy
    exact ⟨by linarith [hy.1], hy.2⟩
  have hl := norm_firstOrderTaylorError_le_of_local_deriv_variation f f' K center (center - width) hK
    (fun y hy => hf y (hleftMem hy)) (fun y hy => hvariation y (hleftMem hy))
  have hr := norm_firstOrderTaylorError_le_of_local_deriv_variation f f' K center (center + width) hK
    (fun y hy => hf y (hrightMem hy)) (fun y hy => hvariation y (hrightMem hy))
  have hl' : ‖f (center - width) - (f center + (-width) • f' center)‖ ≤ K * width ^ 2 := by
    simpa only [sub_sub_cancel_left, neg_sq] using hl
  have hr' : ‖f (center + width) - (f center + width • f' center)‖ ≤ K * width ^ 2 := by
    simpa only [add_sub_cancel_left] using hr
  constructor
  · have heq : (1 / 2 : ℝ) • (f (center - width) + f (center + width)) - f center =
        (1 / 2 : ℝ) • ((f (center - width) - (f center + (-width) • f' center)) +
          (f (center + width) - (f center + width • f' center))) := by module
    rw [heq, norm_smul, Real.norm_eq_abs, abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 1 / 2)]
    calc
      _ ≤ (1 / 2 : ℝ) * (‖f (center - width) - (f center + (-width) • f' center)‖ +
          ‖f (center + width) - (f center + width • f' center)‖) :=
        mul_le_mul_of_nonneg_left (norm_add_le _ _) (by norm_num)
      _ ≤ (1 / 2 : ℝ) * (K * width ^ 2 + K * width ^ 2) :=
        mul_le_mul_of_nonneg_left (add_le_add hl' hr') (by norm_num)
      _ = K * width ^ 2 := by ring
  · have heq : (f (center + width) - f (center - width)) - (2 * width) • f' center =
        (f (center + width) - (f center + width • f' center)) -
          (f (center - width) - (f center + (-width) • f' center)) := by module
    rw [heq]
    calc
      _ ≤ ‖f (center + width) - (f center + width • f' center)‖ +
          ‖f (center - width) - (f center + (-width) • f' center)‖ := norm_sub_le _ _
      _ ≤ K * width ^ 2 + K * width ^ 2 := add_le_add hr' hl'
      _ = 2 * K * width ^ 2 := by ring

end NumStability
