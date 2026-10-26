/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFlux

/-!
# Comparing the actual Burgers flux with its quadratic split

At a compressive sign crossing the exact shock selection takes the larger
half-flux. Its difference from their sum is quadratic in the state jump.
-/

namespace NumStability

/-- The actual selected Godunov flux differs from the positive-left plus
negative-right half-flux by at most half the squared state jump. -/
theorem leveque04_burgersSelectedInterfaceFlux_split_difference
    (left right : ℝ) :
    |(leveque04_burgersSelectedInterfaceState left right) ^ 2 / 2 -
      ((max 0 left) ^ 2 / 2 + (min 0 right) ^ 2 / 2)| ≤ (left - right) ^ 2 / 2 := by
  rw [leveque04_burgersSelectedInterfaceFlux_eq_max]
  by_cases hl : left ≤ 0
  · rw [max_eq_left hl]
    simp [max_eq_right (by positivity : (0 : ℝ) ≤ (min 0 right) ^ 2 / 2)]
    positivity
  · by_cases hr : 0 ≤ right
    · rw [min_eq_left hr]
      simp [max_eq_left (by positivity : (0 : ℝ) ≤ (max 0 left) ^ 2 / 2)]
      positivity
    · have hl' : 0 ≤ left := (le_of_not_ge hl)
      have hr' : right ≤ 0 := (le_of_not_ge hr)
      rw [max_eq_right hl', min_eq_right hr']
      have hmax : max (left ^ 2 / 2) (right ^ 2 / 2) ≤ left ^ 2 / 2 + right ^ 2 / 2 :=
        max_le (by nlinarith [sq_nonneg right]) (by nlinarith [sq_nonneg left])
      rw [abs_of_nonpos (by linarith)]
      have hright := le_max_right (left ^ 2 / 2) (right ^ 2 / 2)
      have hprod : left * right ≤ 0 := mul_nonpos_of_nonneg_of_nonpos hl' hr'
      nlinarith [sq_nonneg right]

end NumStability
