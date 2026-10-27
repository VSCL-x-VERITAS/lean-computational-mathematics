/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import Mathlib.Tactic.Module
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# Centered slope error from local second derivative variation

A centered secant of a real-parameter normed-space curve approximates its
derivative with error at most `K * width ^ 2` when the second derivative varies
by at most `K * |y - center|` on the closed interval of radius `width`.
-/

namespace NumStability
open Set

theorem local_vector_centeredSlope_error
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f f' f'' : ℝ → E) (K center width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ y ∈ Set.Icc (center - width) (center + width), HasDerivAt f (f' y) y)
    (hf' : ∀ y ∈ Set.Icc (center - width) (center + width), HasDerivAt f' (f'' y) y)
    (hvariation : ∀ y ∈ Set.Icc (center - width) (center + width),
      ‖f'' y - f'' center‖ ≤ K * |y - center|) :
    ‖(2 * width)⁻¹ • (f (center + width) - f (center - width)) - f' center‖ ≤
      K * width ^ 2 := by
  have hsub (x : ℝ) (hx : x ∈ Set.Icc (center - width) (center + width)) :
      Set.uIcc center x ⊆ Set.Icc (center - width) (center + width) :=
    Set.uIcc_subset_Icc ⟨by linarith, by linarith⟩ hx
  have hleftMem : center - width ∈ Set.Icc (center - width) (center + width) :=
    ⟨le_rfl, by linarith⟩
  have hrightMem : center + width ∈ Set.Icc (center - width) (center + width) :=
    ⟨by linarith, le_rfl⟩
  have hl := norm_secondOrderTaylorError_le_of_local_second_deriv_variation
    f f' f'' K center (center - width) hK
    (fun y hy => hf y (hsub _ hleftMem hy))
    (fun y hy => hf' y (hsub _ hleftMem hy))
    (fun y hy => hvariation y (hsub _ hleftMem hy))
  have hr := norm_secondOrderTaylorError_le_of_local_second_deriv_variation
    f f' f'' K center (center + width) hK
    (fun y hy => hf y (hsub _ hrightMem hy))
    (fun y hy => hf' y (hsub _ hrightMem hy))
    (fun y hy => hvariation y (hsub _ hrightMem hy))
  let el := f (center - width) -
    (f center + (-width) • f' center + (width ^ 2 / 2) • f'' center)
  let er := f (center + width) -
    (f center + width • f' center + (width ^ 2 / 2) • f'' center)
  have hl' : ‖el‖ ≤ K * width ^ 3 := by
    simpa only [el, sub_sub_cancel_left, neg_sq, abs_neg, abs_of_pos hwidth] using hl
  have hr' : ‖er‖ ≤ K * width ^ 3 := by
    simpa only [er, add_sub_cancel_left, abs_of_pos hwidth] using hr
  have hid : f (center + width) - f (center - width) =
      (2 * width) • f' center + (er - el) := by dsimp [er, el]; module
  rw [hid, smul_add, smul_smul, inv_mul_cancel₀ (by positivity : 2 * width ≠ 0),
    one_smul, add_sub_cancel_left, norm_smul, Real.norm_eq_abs,
    abs_of_pos (inv_pos.mpr (by positivity : 0 < 2 * width))]
  calc
    _ ≤ (2 * width)⁻¹ * (‖er‖ + ‖el‖) :=
      mul_le_mul_of_nonneg_left (norm_sub_le _ _) (by positivity)
    _ ≤ (2 * width)⁻¹ * (K * width ^ 3 + K * width ^ 3) :=
      mul_le_mul_of_nonneg_left (add_le_add hr' hl') (by positivity)
    _ = K * width ^ 2 := by field_simp; ring

end NumStability
