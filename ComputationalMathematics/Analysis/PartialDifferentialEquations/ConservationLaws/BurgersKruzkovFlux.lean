/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Sign
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Scalar Burgers absolute-value entropy flux

The maximum formula removes the apparent sign discontinuity at the reference
state. The descending-shock estimate holds for every reference state.
-/

namespace NumStability

/-- Flux paired with the absolute-value entropy for the scalar flux `u²/2`. -/
noncomputable def burgersKruzkovFlux (reference state : ℝ) : ℝ :=
  Real.sign (state - reference) * (state ^ 2 - reference ^ 2) / 2

/-- A continuous maximum representation of the absolute-value entropy flux. -/
theorem burgersKruzkovFlux_eq_max (reference state : ℝ) :
    burgersKruzkovFlux reference state =
      (max state reference) ^ 2 - state ^ 2 / 2 - reference ^ 2 / 2 := by
  rcases lt_trichotomy state reference with h | h | h
  · rw [burgersKruzkovFlux, Real.sign_of_neg (sub_neg.mpr h), max_eq_right h.le]
    ring
  · subst state
    simp [burgersKruzkovFlux]
    ring
  · rw [burgersKruzkovFlux, Real.sign_of_pos (sub_pos.mpr h), max_eq_left h.le]
    ring

/-- Every descending Burgers shock dissipates each absolute-value entropy.
The speed is the Rankine--Hugoniot mean of the two states. -/
theorem burgersKruzkovFlux_shock_dissipation
    (left right reference : ℝ) (horder : right ≤ left) :
    ((left + right) / 2) * (|left - reference| - |right - reference|) ≤
      burgersKruzkovFlux reference left - burgersKruzkovFlux reference right := by
  rw [burgersKruzkovFlux_eq_max, burgersKruzkovFlux_eq_max]
  by_cases hlo : reference ≤ right
  · rw [max_eq_left (hlo.trans horder), max_eq_left hlo,
      abs_of_nonneg (sub_nonneg.mpr (hlo.trans horder)),
      abs_of_nonneg (sub_nonneg.mpr hlo)]
    nlinarith
  · by_cases hhi : left ≤ reference
    · rw [max_eq_right hhi, max_eq_right (horder.trans hhi),
        abs_of_nonpos (sub_nonpos.mpr hhi),
        abs_of_nonpos (sub_nonpos.mpr (horder.trans hhi))]
      nlinarith
    · have hr : right ≤ reference := le_of_not_ge hlo
      have hl : reference ≤ left := le_of_not_ge hhi
      rw [max_eq_left hl, max_eq_right hr,
        abs_of_nonneg (sub_nonneg.mpr hl), abs_of_nonpos (sub_nonpos.mpr hr)]
      have hprod := mul_nonneg (sub_nonneg.mpr hl) (sub_nonneg.mpr hr)
      nlinarith

end NumStability
