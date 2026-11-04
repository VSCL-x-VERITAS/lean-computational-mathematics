/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersPhysicalFluctuationsTarget
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Physical Burgers fluctuations for every pair of states

The signed fan integrals and shock contributions agree with the physical
fluctuations of the existing selected Burgers solution. The strict transonic
case uses the exact scalar entropy correction (12.9), rather than an
expansion shock. The last identity is the per-cell conservative algebra;
assembled-grid REA realization retains its separate CFL hypotheses.
-/

namespace NumStability

private theorem integral_negative_part (a b : ℝ) :
    (∫ v in a..b, min 0 v) = (min 0 b) ^ 2 / 2 - (min 0 a) ^ 2 / 2 := by
  exact intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun x _ => hasDerivAt_sq_min_zero_div_two x)
    ((continuous_const.min continuous_id).intervalIntegrable a b)

private theorem integral_positive_part (a b : ℝ) :
    (∫ v in a..b, max 0 v) = (max 0 b) ^ 2 / 2 - (max 0 a) ^ 2 / 2 := by
  exact intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun x _ => hasDerivAt_sq_max_zero_div_two x)
    ((continuous_const.max continuous_id).intervalIntegrable a b)

/-- The independent directional fan/shock contributions equal the physical
flux differences of the actual selected zero-ray state, for all real pairs. -/
theorem leveque04_burgersFanShockContribution_eq_physical (left right : ℝ) :
    leveque04_burgersFanShockMinusContribution left right =
        leveque04_burgersPhysicalMinusFluctuation left right ∧
      leveque04_burgersFanShockPlusContribution left right =
        leveque04_burgersPhysicalPlusFluctuation left right := by
  simp only [leveque04_burgersFanShockMinusContribution,
    leveque04_burgersFanShockPlusContribution, integral_negative_part,
    integral_positive_part, leveque04_burgersPhysicalMinusFluctuation,
    leveque04_burgersPhysicalPlusFluctuation, leveque04_burgersPhysicalInterfaceFlux,
    leveque04_burgersSelectedInterfaceState, leveque04_burgersRarefactionProfile]
  by_cases horder : left ≤ right
  · simp only [if_pos horder]
    by_cases hl : 0 ≤ left
    · have hr : 0 ≤ right := hl.trans horder
      simp only [min_eq_left hl, min_eq_left hr, max_eq_right hl, max_eq_right hr,
        max_eq_left hl]
      constructor <;> first | trivial | ring
    · by_cases hr : right ≤ 0
      · have hl' : left ≤ 0 := horder.trans hr
        simp only [min_eq_right hl', min_eq_right hr, max_eq_left hl',
          max_eq_left hr, max_eq_right horder]
        constructor <;> first | trivial | ring
      · have hl' : left ≤ 0 := le_of_not_ge hl
        have hr' : 0 ≤ right := le_of_not_ge hr
        simp only [min_eq_right hl', min_eq_left hr', max_eq_left hl',
          max_eq_right hr', max_eq_right hl']
        constructor <;> trivial
  · simp only [if_neg horder]
    by_cases hs : 0 < (left + right) / 2
    · simp only [if_pos hs, min_eq_left hs.le, max_eq_right hs.le]
      constructor <;> ring
    · have hs' : (left + right) / 2 ≤ 0 := le_of_not_gt hs
      simp only [if_neg hs, min_eq_right hs', max_eq_left hs']
      constructor <;> ring

/-- Source (12.8) applies outside the strict transonic fan; (12.9) supplies
the exact replacement in that fan. Sonic endpoints and equal states remain included. -/
theorem leveque04_burgersPhysicalFluctuations_entropy_rule (left right : ℝ) :
    (leveque04_burgersPhysicalMinusFluctuation left right,
      leveque04_burgersPhysicalPlusFluctuation left right) =
      if left < 0 ∧ 0 < right then (-(left ^ 2) / 2, right ^ 2 / 2)
      else (min 0 ((left + right) / 2) * (right - left),
        max 0 ((left + right) / 2) * (right - left)) := by
  obtain ⟨hminus, hplus⟩ := leveque04_burgersFanShockContribution_eq_physical left right
  rw [← hminus, ← hplus]
  simp only [leveque04_burgersFanShockMinusContribution,
    leveque04_burgersFanShockPlusContribution, integral_negative_part, integral_positive_part]
  by_cases hsonic : left < 0 ∧ 0 < right
  · have horder : left ≤ right := hsonic.1.le.trans hsonic.2.le
    simp [horder, hsonic, min_eq_right hsonic.1.le, min_eq_left hsonic.2.le,
      max_eq_left hsonic.1.le, max_eq_right hsonic.2.le]
    ring
  · simp only [if_neg hsonic]
    by_cases horder : left ≤ right
    · simp only [if_pos horder]
      by_cases hl : 0 ≤ left
      · have hr : 0 ≤ right := hl.trans horder
        have hs : 0 ≤ (left + right) / 2 := by linarith
        simp only [min_eq_left hl, min_eq_left hr, max_eq_right hl, max_eq_right hr,
          min_eq_left hs, max_eq_right hs]
        apply Prod.ext <;> dsimp <;> ring
      · have hr : right ≤ 0 := by
          by_contra hn
          exact hsonic ⟨lt_of_not_ge hl, lt_of_not_ge hn⟩
        have hl' : left ≤ 0 := horder.trans hr
        have hs : (left + right) / 2 ≤ 0 := by linarith
        simp only [min_eq_right hl', min_eq_right hr, max_eq_left hl', max_eq_left hr,
          min_eq_right hs, max_eq_left hs]
        apply Prod.ext <;> dsimp <;> ring
    · simp [horder]

/-- The isolated actual interface flux is constant at almost every time in
the positive-duration interval; the initial endpoint contributes no mass. -/
theorem leveque04_burgersPhysicalInterfaceFlux_timeAverage
    (left right duration : ℝ) (hduration : 0 < duration) :
    (∫ time in (0 : ℝ)..duration,
      (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) / duration =
        leveque04_burgersPhysicalInterfaceFlux left right := by
  have hintegral :
      (∫ time in (0 : ℝ)..duration,
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) =
      ∫ _time in (0 : ℝ)..duration,
        leveque04_burgersPhysicalInterfaceFlux left right := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [] with time htime
    have ht : 0 < time ∧ time ≤ duration := by
      simpa only [Set.uIoc_of_le hduration.le, Set.mem_Ioc] using htime
    rw [leveque04_burgersSelectedField_interface left right time ht.1]
    rfl
  rw [hintegral, intervalIntegral.integral_const]
  simp [smul_eq_mul, hduration.ne']

/-- The actual stationary shock has a common flux for either endpoint
representative, and both physical fluctuations vanish. -/
theorem leveque04_burgersPhysicalFluctuations_stationary
    (left right : ℝ) (horder : right < left) (hstationary : left + right = 0)
    (representative : ℝ) (hrep : representative = left ∨ representative = right) :
    representative ^ 2 / 2 = leveque04_burgersPhysicalInterfaceFlux left right ∧
      leveque04_burgersPhysicalMinusFluctuation left right = 0 ∧
      leveque04_burgersPhysicalPlusFluctuation left right = 0 := by
  have hflux : leveque04_burgersPhysicalInterfaceFlux left right = right ^ 2 / 2 := by
    simp [leveque04_burgersPhysicalInterfaceFlux, leveque04_burgersSelectedInterfaceState,
      not_le.mpr horder, hstationary]
  have hsquare : left ^ 2 = right ^ 2 := by
    have hl : left = -right := by linarith
    rw [hl, neg_sq]
  refine ⟨?_, ?_, ?_⟩
  · rcases hrep with rfl | rfl <;> simp [hflux, hsquare]
  · simp [leveque04_burgersPhysicalMinusFluctuation, hflux, hsquare]
  · simp [leveque04_burgersPhysicalPlusFluctuation, hflux]

/-- The exact frozen all-state physical-fluctuation contract. -/
theorem leveque04_burgersPhysicalFluctuations :
    Leveque04BurgersPhysicalFluctuationsTarget := by
  constructor
  · intro left right
    obtain ⟨hminus, hplus⟩ := leveque04_burgersFanShockContribution_eq_physical left right
    refine ⟨leveque04_burgersSelectedField_interface left right,
      leveque04_burgersPhysicalInterfaceFlux_timeAverage left right,
      leveque04_burgersSelectedInterfaceFlux_eq_max left right,
      hminus, hplus, leveque04_burgersPhysicalFluctuations_entropy_rule left right,
      ?_, ?_, ?_, leveque04_burgersPhysicalFluctuations_stationary left right⟩
    all_goals
      simp only [leveque04_burgersPhysicalMinusFluctuation,
        leveque04_burgersPhysicalPlusFluctuation]
      ring
  · intro left center right timeStep cellWidth _htime _hwidth
    simp only [leveque04_burgersPhysicalFluctuationUpdate,
      leveque04_burgersPhysicalMinusFluctuation, leveque04_burgersPhysicalPlusFluctuation]
    ring

end NumStability
