/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation

/-!
# LeVeque Chapter 4, equation (4.40): signed characteristic speeds

Each wave speed uses the same positive and negative part operation already
introduced for scalar upwinding in (4.34).
-/

namespace NumStability

/-- Equation (4.40), applied to each wave family without introducing a
second pair of speed-part definitions. -/
theorem leveque04_equation40
    {m : ℕ} (waveSpeed : Fin m → ℝ) :
    ∀ p, leveque04_positiveVelocity (waveSpeed p) = max (waveSpeed p) 0 ∧
      leveque04_negativeVelocity (waveSpeed p) = min (waveSpeed p) 0 := by
  intro p
  exact leveque04_equation34 (waveSpeed p)

/-- The difference of the positive and negative speed parts is the absolute
speed, as used in the wave-propagation reformulation. -/
theorem leveque04_positiveVelocity_sub_negativeVelocity (velocity : ℝ) :
    leveque04_positiveVelocity velocity - leveque04_negativeVelocity velocity = |velocity| := by
  simpa only [leveque04_positiveVelocity, leveque04_negativeVelocity, zero_sub, abs_neg] using
    (max_sub_min_eq_abs velocity (0 : ℝ))

end NumStability
