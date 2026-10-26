/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.WaveSpeedParts
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equation (4.63): signed speeds by absolute value
-/

namespace NumStability

/-- Equation (4.63): the max/min speed split equals the half-sum and
half-difference of speed and absolute speed. -/
theorem leveque04_equation63 (speed : ℝ) :
    leveque04_positiveVelocity speed = (speed + |speed|) / 2 ∧
      leveque04_negativeVelocity speed = (speed - |speed|) / 2 := by
  by_cases h : 0 ≤ speed
  · rw [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_left h, min_eq_right h, abs_of_nonneg h]
    constructor <;> ring
  · have hn : speed ≤ 0 := le_of_lt (lt_of_not_ge h)
    rw [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_right hn, min_eq_left hn, abs_of_nonpos hn]
    constructor <;> ring

end NumStability
