/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Characteristic constancy on a finite pipe

For constant transport speed, two points on an admitted characteristic carry
the same field value. This permits piecewise solutions with a jump on a
different characteristic.
-/

namespace NumStability

/-- Characteristic constancy away from the incoming corner ray, whose value is
not specified by the two strict branches of the finite-pipe formula. -/
def IsPipeCharacteristicSolution (field : ℝ → ℝ → ℝ)
    (left right speed initialTime : ℝ) : Prop :=
  ∀ x t s, x ≠ left + speed * (t - initialTime) →
    left ≤ x → x ≤ right → initialTime ≤ s → s ≤ t →
    left ≤ x - speed * (t - s) → x - speed * (t - s) ≤ right →
    field x t = field (x - speed * (t - s)) s

end NumStability
