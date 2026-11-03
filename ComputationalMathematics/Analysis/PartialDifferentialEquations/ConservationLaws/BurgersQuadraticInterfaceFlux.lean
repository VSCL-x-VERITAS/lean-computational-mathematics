/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Burgers zero-ray flux from two constrained quadratic comparisons

For a real velocity, comparison with the positive-left and negative-right
quadratic minima determines its physical flux. Only two explicit inequalities
are needed. Stationary-shock ties may choose either state, with equal flux.
-/

namespace NumStability

private theorem nonnegative_minimizer (q u : ℝ) (hu : 0 ≤ u)
    (hmin : u ^ 2 / 2 - q * u ≤ -(max 0 q) ^ 2 / 2) :
    u = max 0 q ∧ u ^ 2 / 2 - q * u = -(max 0 q) ^ 2 / 2 := by
  by_cases hq : 0 ≤ q
  · rw [max_eq_right hq] at hmin ⊢
    have hsq : (u - q) ^ 2 = 0 := le_antisymm (by nlinarith) (sq_nonneg _)
    have heq := sub_eq_zero.mp (sq_eq_zero_iff.mp hsq)
    exact ⟨heq, by rw [heq]; ring⟩
  · have hq0 : q ≤ 0 := le_of_not_ge hq
    rw [max_eq_left hq0] at hmin ⊢
    simp only [zero_pow (by decide : 2 ≠ 0), neg_zero, zero_div] at hmin
    have hprod : q * u ≤ 0 := mul_nonpos_of_nonpos_of_nonneg hq0 hu
    have hhalf : u ^ 2 / 2 ≤ 0 := (sub_nonpos.mp hmin).trans hprod
    have hsqle : u ^ 2 ≤ 0 := by
      simpa only [zero_mul] using (div_le_iff₀ (by norm_num : 0 < (2 : ℝ))).mp hhalf
    have hsq : u ^ 2 = 0 := le_antisymm hsqle (sq_nonneg _)
    have heq := sq_eq_zero_iff.mp hsq
    exact ⟨heq, by rw [heq]; ring⟩

/-- The normalized two-state quadratic action comparisons determine the
outgoing Burgers flux without selecting a stationary-shock representative. -/
theorem burgers_zeroRayFlux_of_quadratic_comparisons (left right velocity : ℝ)
    (hleft : (if 0 ≤ velocity then velocity ^ 2 / 2 - left * velocity
      else velocity ^ 2 / 2 - right * velocity) ≤ -(max 0 left) ^ 2 / 2)
    (hright : (if 0 ≤ velocity then velocity ^ 2 / 2 - left * velocity
      else velocity ^ 2 / 2 - right * velocity) ≤ -(min 0 right) ^ 2 / 2) :
    velocity ^ 2 / 2 = max ((max 0 left) ^ 2 / 2) ((min 0 right) ^ 2 / 2) := by
  by_cases hu : 0 ≤ velocity
  · rw [if_pos hu] at hleft hright
    have hm := nonnegative_minimizer left velocity hu hleft
    have hdom : (min 0 right) ^ 2 / 2 ≤ (max 0 left) ^ 2 / 2 := by
      rw [hm.2] at hright
      linarith
    rw [max_eq_left hdom, hm.1]
  · rw [if_neg hu] at hleft hright
    have hr : max 0 (-right) = -(min 0 right) := by
      by_cases hq : 0 ≤ right
      · rw [min_eq_left hq, max_eq_left (neg_nonpos.mpr hq), neg_zero]
      · rw [min_eq_right (le_of_not_ge hq), max_eq_right (neg_nonneg.mpr (le_of_not_ge hq))]
    have hn : (-velocity) ^ 2 / 2 - (-right) * (-velocity) ≤ -(max 0 (-right)) ^ 2 / 2 := by
      rw [hr]
      nlinarith [hright]
    have hm := nonnegative_minimizer (-right) (-velocity) (by linarith) hn
    rw [hr] at hm
    have heq : velocity = min 0 right := by linarith [hm.1]
    have hcost : velocity ^ 2 / 2 - right * velocity = -(min 0 right) ^ 2 / 2 := by
      nlinarith [hm.2]
    have hdom : (max 0 left) ^ 2 / 2 ≤ (min 0 right) ^ 2 / 2 := by
      rw [hcost] at hleft
      linarith
    rw [max_eq_right hdom, heq]

end NumStability
