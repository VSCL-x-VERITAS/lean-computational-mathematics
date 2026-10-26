/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersRarefaction
import ComputationalMathematics.Analysis.Calculus.Piecewise
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Potential for the centered Burgers rarefaction

For positive time and ascending Riemann states, the potential is affine
outside the centered fan and quadratic inside it. Squared positive parts
give one formula with matching values at both moving characteristic edges.
Its spatial and temporal derivatives agree with the state and negative
physical flux through both edges. Interval FTC gives oriented rectangle
balance between positive times.
-/

namespace NumStability

/-- A continuous piecewise potential for the positive-time centered fan.
The formula is only interpreted as a Burgers fan potential for `0 < t`. -/
noncomputable def leveque04_burgersRarefactionPotential
    (left right x t : ℝ) : ℝ :=
  left * x - left ^ 2 * t / 2 +
    (max 0 (x - left * t)) ^ 2 / (2 * t) -
      (max 0 (x - right * t)) ^ 2 / (2 * t)

/-- To the left of the fan, the potential is the left constant-state
primitive `left*x - f(left)*t`. -/
theorem leveque04_burgersRarefactionPotential_leftRegion
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t)
    (hleft : x ≤ left * t) :
    leveque04_burgersRarefactionPotential left right x t =
      left * x - left ^ 2 * t / 2 := by
  have hright : x ≤ right * t :=
    hleft.trans (mul_le_mul_of_nonneg_right horder htime.le)
  have hl : x - left * t ≤ 0 := sub_nonpos.mpr hleft
  have hr : x - right * t ≤ 0 := sub_nonpos.mpr hright
  simp [leveque04_burgersRarefactionPotential,
    max_eq_left hl, max_eq_left hr]

/-- In the closed centered fan, the potential is the quadratic
similarity primitive `x²/(2t)`. -/
theorem leveque04_burgersRarefactionPotential_fan
    (left right x t : ℝ) (htime : 0 < t)
    (hleft : left * t ≤ x) (hright : x ≤ right * t) :
    leveque04_burgersRarefactionPotential left right x t =
      x ^ 2 / (2 * t) := by
  have hl : 0 ≤ x - left * t := sub_nonneg.mpr hleft
  have hr : x - right * t ≤ 0 := sub_nonpos.mpr hright
  simp only [leveque04_burgersRarefactionPotential,
    max_eq_right hl, max_eq_left hr, zero_pow (by norm_num : 2 ≠ 0), zero_div,
    sub_zero]
  field_simp
  ring

/-- To the right of the fan, the potential is the right constant-state
primitive `right*x - f(right)*t`. -/
theorem leveque04_burgersRarefactionPotential_rightRegion
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t)
    (hright : right * t ≤ x) :
    leveque04_burgersRarefactionPotential left right x t =
      right * x - right ^ 2 * t / 2 := by
  have hleft : left * t ≤ x :=
    (mul_le_mul_of_nonneg_right horder htime.le).trans hright
  have hl : 0 ≤ x - left * t := sub_nonneg.mpr hleft
  have hr : 0 ≤ x - right * t := sub_nonneg.mpr hright
  simp only [leveque04_burgersRarefactionPotential,
    max_eq_right hl, max_eq_right hr]
  field_simp
  ring

/-- The affine and quadratic pieces agree in value at both moving
characteristic edges. -/
theorem leveque04_burgersRarefactionPotential_edgeValues
    (left right t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    leveque04_burgersRarefactionPotential left right (left * t) t =
        left ^ 2 * t / 2 ∧
      leveque04_burgersRarefactionPotential left right (right * t) t =
        right ^ 2 * t / 2 := by
  constructor
  · rw [leveque04_burgersRarefactionPotential_leftRegion
      left right (left * t) t horder htime le_rfl]
    ring
  · rw [leveque04_burgersRarefactionPotential_rightRegion
      left right (right * t) t horder htime le_rfl]
    ring

/-- The spatial derivative of the potential is the fan state, including
both characteristic edges. -/
theorem leveque04_burgersRarefactionPotential_space_hasDerivAt
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    HasDerivAt (fun y => leveque04_burgersRarefactionPotential left right y t)
      (leveque04_burgersRarefactionForward left right x t) x := by
  have hl := (hasDerivAt_sq_max_zero (x - left * t)).comp x
    ((hasDerivAt_id x).sub_const (left * t))
  have hr := (hasDerivAt_sq_max_zero (x - right * t)).comp x
    ((hasDerivAt_id x).sub_const (right * t))
  have hd := ((((hasDerivAt_id x).const_mul left).sub_const (left ^ 2 * t / 2)).add
    (hl.div_const (2 * t))).sub (hr.div_const (2 * t))
  change HasDerivAt (fun y => leveque04_burgersRarefactionPotential left right y t) _ x at hd
  apply hd.congr_deriv
  dsimp
  rcases le_total x (left * t) with hx | hx
  · have hxright := hx.trans (mul_le_mul_of_nonneg_right horder htime.le)
    rw [max_eq_left (sub_nonpos.mpr hx), max_eq_left (sub_nonpos.mpr hxright)]
    rw [leveque04_burgersRarefactionForward,
      leveque04_burgersRarefactionProfile_left left right (x / t) horder
        ((div_le_iff₀ htime).2 hx)]
    ring
  · rcases le_total x (right * t) with hy | hy
    · rw [max_eq_right (sub_nonneg.mpr hx), max_eq_left (sub_nonpos.mpr hy)]
      rw [leveque04_burgersRarefactionForward,
        leveque04_burgersRarefactionProfile_interior left right (x / t)
          ((le_div_iff₀ htime).2 hx) ((div_le_iff₀ htime).2 hy)]
      field_simp
      ring
    · have hxleft := (mul_le_mul_of_nonneg_right horder htime.le).trans hy
      rw [max_eq_right (sub_nonneg.mpr hxleft), max_eq_right (sub_nonneg.mpr hy)]
      rw [leveque04_burgersRarefactionForward,
        leveque04_burgersRarefactionProfile_right left right (x / t) horder
          ((le_div_iff₀ htime).2 hy)]
      field_simp
      ring

/-- The temporal derivative equals minus the physical Burgers flux,
also when a characteristic edge passes the spatial face. -/
theorem leveque04_burgersRarefactionPotential_time_hasDerivAt
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    HasDerivAt (fun τ => leveque04_burgersRarefactionPotential left right x τ)
      (-(leveque04_burgersRarefactionForward left right x t) ^ 2 / 2) t := by
  have hl := (hasDerivAt_sq_max_zero (x - left * t)).comp t
    ((hasDerivAt_const t x).sub ((hasDerivAt_id t).const_mul left))
  have hr := (hasDerivAt_sq_max_zero (x - right * t)).comp t
    ((hasDerivAt_const t x).sub ((hasDerivAt_id t).const_mul right))
  have hden := (hasDerivAt_id t).const_mul (2 : ℝ)
  have hd := (((hasDerivAt_const t (left * x)).sub
    (((hasDerivAt_id t).const_mul (left ^ 2)).div_const 2)).add
      (hl.div hden (by positivity))).sub (hr.div hden (by positivity))
  change HasDerivAt (fun τ => leveque04_burgersRarefactionPotential left right x τ) _ t at hd
  apply hd.congr_deriv
  dsimp
  rcases le_total x (left * t) with hx | hx
  · have hxright := hx.trans (mul_le_mul_of_nonneg_right horder htime.le)
    rw [max_eq_left (sub_nonpos.mpr hx), max_eq_left (sub_nonpos.mpr hxright)]
    rw [leveque04_burgersRarefactionForward,
      leveque04_burgersRarefactionProfile_left left right (x / t) horder
        ((div_le_iff₀ htime).2 hx)]
    ring
  · rcases le_total x (right * t) with hy | hy
    · rw [max_eq_right (sub_nonneg.mpr hx), max_eq_left (sub_nonpos.mpr hy)]
      rw [leveque04_burgersRarefactionForward,
        leveque04_burgersRarefactionProfile_interior left right (x / t)
          ((le_div_iff₀ htime).2 hx) ((div_le_iff₀ htime).2 hy)]
      field_simp
      ring
    · have hxleft := (mul_le_mul_of_nonneg_right horder htime.le).trans hy
      rw [max_eq_right (sub_nonneg.mpr hxleft), max_eq_right (sub_nonneg.mpr hy)]
      rw [leveque04_burgersRarefactionForward,
        leveque04_burgersRarefactionProfile_right left right (x / t) horder
          ((le_div_iff₀ htime).2 hy)]
      field_simp
      ring

/-- Integrating the spatial primitive gives the mass in any oriented
interval at a positive time. -/
theorem leveque04_burgersRarefactionForward_mass_potential
    (left right a b t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    (∫ x in a..b, leveque04_burgersRarefactionForward left right x t) =
      leveque04_burgersRarefactionPotential left right b t -
        leveque04_burgersRarefactionPotential left right a t := by
  exact intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun x _ => leveque04_burgersRarefactionPotential_space_hasDerivAt
      left right x t horder htime)
    (leveque04_burgersRarefactionForward_intervalIntegrable_space left right t a b)

/-- Integrating the temporal primitive gives the physical face flux
between two positive times, in either orientation. -/
theorem leveque04_burgersRarefactionForward_scalarFlux_integrable
    (left right x s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    IntervalIntegrable
      (fun τ => (leveque04_burgersRarefactionForward left right x τ) ^ 2 / 2)
      MeasureTheory.volume s t := by
  apply ContinuousOn.intervalIntegrable
  intro τ hτ
  have hτpos : 0 < τ := (lt_min hs ht).trans_le hτ.1
  have hquot : ContinuousAt (fun σ : ℝ => x / σ) τ :=
    continuousAt_const.div continuousAt_id (ne_of_gt hτpos)
  have hstate := ((leveque04_burgersRarefactionProfile_lipschitz left right).continuous
    |>.continuousAt.comp hquot)
  exact (hstate.pow 2 |>.div_const 2).continuousWithinAt

/-- Temporal FTC for the scalar physical flux. -/
theorem leveque04_burgersRarefactionForward_flux_potential
    (left right x s t : ℝ) (horder : left ≤ right) (hs : 0 < s) (ht : 0 < t) :
    (∫ τ in s..t, (leveque04_burgersRarefactionForward left right x τ) ^ 2 / 2) =
      leveque04_burgersRarefactionPotential left right x s -
        leveque04_burgersRarefactionPotential left right x t := by
  have hint := leveque04_burgersRarefactionForward_scalarFlux_integrable
    left right x s t hs ht
  have hh := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun τ (hτ : τ ∈ Set.uIcc s t) =>
      leveque04_burgersRarefactionPotential_time_hasDerivAt left right x τ horder
        ((lt_min hs ht).trans_le hτ.1))
    (by simpa only [neg_div] using hint.neg)
  simp only [neg_div, intervalIntegral.integral_neg] at hh
  linarith

/-- The constructed forward rarefaction satisfies conservation on every
oriented rectangle whose two time faces are positive. -/
theorem leveque04_burgersRarefactionForward_rectangle_balance_positive
    (left right a b s t : ℝ) (horder : left ≤ right) (hs : 0 < s) (ht : 0 < t) :
    (∫ x in a..b, leveque04_burgersRarefactionForward left right x t) -
        (∫ x in a..b, leveque04_burgersRarefactionForward left right x s) =
      ∫ τ in s..t, ((leveque04_burgersRarefactionForward left right a τ) ^ 2 / 2 -
        (leveque04_burgersRarefactionForward left right b τ) ^ 2 / 2) := by
  rw [leveque04_burgersRarefactionForward_mass_potential left right a b t horder ht,
    leveque04_burgersRarefactionForward_mass_potential left right a b s horder hs,
    intervalIntegral.integral_sub
      (leveque04_burgersRarefactionForward_scalarFlux_integrable
        left right a s t hs ht)
      (leveque04_burgersRarefactionForward_scalarFlux_integrable
        left right b s t hs ht),
    leveque04_burgersRarefactionForward_flux_potential left right a s t horder hs ht,
    leveque04_burgersRarefactionForward_flux_potential left right b s t horder hs ht]
  ring

end NumStability
