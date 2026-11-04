/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Strict midpoint comparison for quadratic actions

If the initial potential is affine at the midpoint of two feet, both feet
cannot minimize the same positive-time quadratic action unless they coincide.
Only the actual two midpoint comparison inequalities are used.
-/

namespace NumStability

theorem quadraticAction_minimizers_eq_of_affine_midpoint
    (potential : ℝ → ℝ) (time x y z : ℝ) (htime : 0 < time)
    (haffine : potential ((y + z) / 2) = (potential y + potential z) / 2)
    (hminy : potential y + (x - y) ^ 2 / (2 * time) ≤
      potential ((y + z) / 2) + (x - (y + z) / 2) ^ 2 / (2 * time))
    (hminz : potential z + (x - z) ^ 2 / (2 * time) ≤
      potential ((y + z) / 2) + (x - (y + z) / 2) ^ 2 / (2 * time)) : y = z := by
  have hid : potential ((y + z) / 2) + (x - (y + z) / 2) ^ 2 / (2 * time) =
      ((potential y + (x - y) ^ 2 / (2 * time)) +
        (potential z + (x - z) ^ 2 / (2 * time))) / 2 - (y - z) ^ 2 / (8 * time) := by
    rw [haffine]
    field_simp [htime.ne']
    ring
  have hdiv : (y - z) ^ 2 / (8 * time) ≤ 0 := by linarith
  have hsq : (y - z) ^ 2 ≤ 0 := by
    have h := (div_le_iff₀ (by positivity : 0 < 8 * time)).mp hdiv
    simpa only [zero_mul] using h
  exact sub_eq_zero.mp (sq_eq_zero_iff.mp (le_antisymm hsq (sq_nonneg _)))

end NumStability
