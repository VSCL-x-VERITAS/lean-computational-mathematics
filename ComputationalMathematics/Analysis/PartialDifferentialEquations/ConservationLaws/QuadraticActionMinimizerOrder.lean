/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Order of minimizing feet for quadratic actions

Only the two crossed minimizing inequalities are needed. No existence,
regularity, or coercivity of the potential is assumed. The resulting order
gives the signed one-sided bound for velocities selected from such feet.
-/

namespace NumStability

/-- Minimizing feet at two strictly ordered observations cannot cross.
The strict observation order matters when minimizers are not unique. -/
theorem quadraticAction_minimizers_ordered
    (potential : ℝ → ℝ) (time x₁ x₂ y₁ y₂ : ℝ)
    (htime : 0 < time) (hx : x₁ < x₂)
    (h₁ : potential y₁ + (x₁ - y₁) ^ 2 / (2 * time) ≤
      potential y₂ + (x₁ - y₂) ^ 2 / (2 * time))
    (h₂ : potential y₂ + (x₂ - y₂) ^ 2 / (2 * time) ≤
      potential y₁ + (x₂ - y₁) ^ 2 / (2 * time)) :
    y₁ ≤ y₂ := by
  have hden : 0 < 2 * time := by linarith
  have action (x y : ℝ) : potential y + (x - y) ^ 2 / (2 * time) =
      (2 * time * potential y + (x - y) ^ 2) / (2 * time) := by
    field_simp [ne_of_gt htime]
  rw [action, action] at h₁ h₂
  have h₁' := (div_le_div_iff_of_pos_right hden).mp h₁
  have h₂' := (div_le_div_iff_of_pos_right hden).mp h₂
  by_contra hcross
  have hpositive : 0 < (x₂ - x₁) * (y₁ - y₂) :=
    mul_pos (sub_pos.mpr hx) (sub_pos.mpr (lt_of_not_ge hcross))
  nlinarith [h₁', h₂']

/-- A selection of actual quadratic-action minimizers obeys the signed
one-sided velocity bound. The same selection is used at both observations. -/
theorem quadraticAction_selectedVelocity_oneSided
    (potential foot : ℝ → ℝ) (time : ℝ) (htime : 0 < time)
    (hmin : ∀ x y : ℝ,
      potential (foot x) + (x - foot x) ^ 2 / (2 * time) ≤
        potential y + (x - y) ^ 2 / (2 * time))
    (x₁ x₂ : ℝ) (hx : x₁ ≤ x₂) :
    (x₂ - foot x₂) / time - (x₁ - foot x₁) / time ≤ (x₂ - x₁) / time := by
  rcases hx.eq_or_lt with heq | hlt
  · subst x₂
    simp
  · have hfoot := quadraticAction_minimizers_ordered potential time x₁ x₂
      (foot x₁) (foot x₂) htime hlt (hmin x₁ (foot x₂)) (hmin x₂ (foot x₁))
    calc
      _ = ((x₂ - x₁) + (foot x₁ - foot x₂)) / time := by ring
      _ ≤ (x₂ - x₁) / time :=
        div_le_div_of_nonneg_right (by linarith) htime.le

end NumStability
