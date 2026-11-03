/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSelectedSolver
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Ring

/-!
# Actual kinetic representation of the selected Burgers field

The kinetic steps use the right-state representative at their moving fronts.
Their finite-velocity zeroth and first moments represent the selected ascending
fan and its physical flux. The initial face is treated separately, so the
formulas include time zero and equal states without dividing by time there.
Descending pairs use the actual Rankine--Hugoniot traveling jump.
-/

noncomputable section

open Set MeasureTheory

namespace NumStability

/-- The actual unit Riemann jump traveling at the kinetic velocity. Its value
on the front, including the initial origin, is one. -/
def leveque04_burgersKineticStep (speed x t : ℝ) : ℝ :=
  travelingWave (riemannData 0 1 1) speed x t

theorem leveque04_burgersKineticStep_eq_ite (speed x t : ℝ) :
    leveque04_burgersKineticStep speed x t = if x < speed * t then 0 else 1 := by
  simp only [leveque04_burgersKineticStep, travelingWave, riemannData, ite_self,
    sub_neg]

theorem leveque04_burgersKineticStep_initial (speed x : ℝ) :
    leveque04_burgersKineticStep speed x 0 = if x < 0 then 0 else 1 := by
  simp [leveque04_burgersKineticStep_eq_ite]

theorem leveque04_burgersKineticStep_front (speed t : ℝ) :
    leveque04_burgersKineticStep speed (speed * t) t = 1 := by
  simp [leveque04_burgersKineticStep_eq_ite]

theorem leveque04_burgersKineticStep_bounds (speed x t : ℝ) :
    0 ≤ leveque04_burgersKineticStep speed x t ∧
      leveque04_burgersKineticStep speed x t ≤ 1 := by
  rw [leveque04_burgersKineticStep_eq_ite]
  split_ifs <;> norm_num

/-- Joint measurability in velocity, space, and time, without a time or sign
restriction. The product coordinates are `(velocity, (space, time))`. -/
theorem leveque04_burgersKineticStep_measurable :
    Measurable (fun z : ℝ × (ℝ × ℝ) =>
      leveque04_burgersKineticStep z.1 z.2.1 z.2.2) := by
  simp only [leveque04_burgersKineticStep_eq_ite]
  apply Measurable.ite
  · exact measurableSet_lt (by fun_prop) (by fun_prop)
  · exact measurable_const
  · exact measurable_const

theorem leveque04_burgersKineticStep_velocityMoment_measurable :
    Measurable (fun z : ℝ × (ℝ × ℝ) =>
      z.1 * leveque04_burgersKineticStep z.1 z.2.1 z.2.2) :=
  measurable_fst.mul leveque04_burgersKineticStep_measurable

theorem leveque04_burgersKineticStep_measurable_velocity (x t : ℝ) :
    Measurable (fun v => leveque04_burgersKineticStep v x t) :=
  leveque04_burgersKineticStep_measurable.comp
    (measurable_id.prodMk (measurable_const.prodMk measurable_const))

/-- Every finite velocity interval is integrable, including at time zero and
for intervals whose endpoints are in either order. -/
theorem leveque04_burgersKineticStep_intervalIntegrable (x t a b : ℝ) :
    IntervalIntegrable (fun v => leveque04_burgersKineticStep v x t) volume a b := by
  apply intervalIntegrable_iff.mpr
  apply IntegrableOn.of_bound (by
    simpa only [uIoc] using
      (measure_Ioc_lt_top (μ := volume) (a := min a b) (b := max a b)))
    (leveque04_burgersKineticStep_measurable_velocity x t).aestronglyMeasurable 1
  filter_upwards [] with v
  rw [Real.norm_eq_abs, abs_of_nonneg (leveque04_burgersKineticStep_bounds v x t).1]
  exact (leveque04_burgersKineticStep_bounds v x t).2

theorem leveque04_burgersKineticStep_velocityMoment_intervalIntegrable (x t a b : ℝ) :
    IntervalIntegrable (fun v => v * leveque04_burgersKineticStep v x t) volume a b :=
  (leveque04_burgersKineticStep_intervalIntegrable x t a b).continuousOn_mul continuousOn_id

theorem leveque04_burgersKineticStep_eq_indicator_velocity
    (x t : ℝ) (htime : 0 < t) :
    (fun v => leveque04_burgersKineticStep v x t) =
      (Iic (x / t)).indicator (fun _ => (1 : ℝ)) := by
  funext v
  rw [leveque04_burgersKineticStep_eq_ite]
  by_cases hv : v ≤ x / t
  · have hfront : v * t ≤ x := (le_div_iff₀ htime).mp hv
    simp [hv, not_lt.mpr hfront]
  · have hfront : x < v * t := (div_lt_iff₀ htime).mp (lt_of_not_ge hv)
    simp [hv, hfront]

private theorem burgers_integral_indicator_clamp
    (f : ℝ → ℝ) (left right ray : ℝ) (horder : left ≤ right) :
    (∫ v in left..right, (Iic ray).indicator f v) =
      ∫ v in left..leveque04_burgersRarefactionProfile left right ray, f v := by
  by_cases hleft : ray ≤ left
  · rw [leveque04_burgersRarefactionProfile_left left right ray horder hleft,
      intervalIntegral.integral_same]
    apply intervalIntegral.integral_zero_ae
    filter_upwards [] with v hv
    have hv' : v ∈ Ioc left right := by simpa only [uIoc_of_le horder] using hv
    have hnot : ¬v ≤ ray := not_le_of_gt (hleft.trans_lt hv'.1)
    simp [hnot]
  · by_cases hright : right ≤ ray
    · rw [leveque04_burgersRarefactionProfile_right left right ray horder hright]
      apply intervalIntegral.integral_congr_ae
      filter_upwards [] with v hv
      have hv' : v ∈ Ioc left right := by simpa only [uIoc_of_le horder] using hv
      simp [hv'.2.trans hright]
    · have hL : left ≤ ray := (lt_of_not_ge hleft).le
      have hR : ray ≤ right := (lt_of_not_ge hright).le
      rw [leveque04_burgersRarefactionProfile_interior left right ray hL hR]
      exact intervalIntegral.integral_indicator ⟨hL, hR⟩

/-- Actual zeroth velocity moment of the positive-time unit transport steps.
Both fan endpoints are included without excluding any speed sign. -/
theorem leveque04_burgersKineticStep_integral
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    (∫ v in left..right, leveque04_burgersKineticStep v x t) =
      leveque04_burgersRarefactionProfile left right (x / t) - left := by
  rw [leveque04_burgersKineticStep_eq_indicator_velocity x t htime,
    burgers_integral_indicator_clamp (fun _ => (1 : ℝ)) left right (x / t) horder]
  simp [intervalIntegral.integral_const]

/-- Actual first velocity moment, which supplies the Burgers flux of the fan. -/
theorem leveque04_burgersKineticStep_velocityMoment_integral
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    (∫ v in left..right, v * leveque04_burgersKineticStep v x t) =
      (leveque04_burgersRarefactionProfile left right (x / t) ^ 2 - left ^ 2) / 2 := by
  have heq : (fun v => v * leveque04_burgersKineticStep v x t) =
      (Iic (x / t)).indicator (fun v : ℝ => v) := by
    funext v
    rw [congrFun (leveque04_burgersKineticStep_eq_indicator_velocity x t htime) v]
    by_cases hv : v ≤ x / t <;> simp [hv]
  rw [heq, burgers_integral_indicator_clamp (fun v : ℝ => v) left right (x / t) horder]
  exact integral_id

/-- The actual ascending selected field is the finite-velocity superposition
of unit transport steps, including time zero and equal endpoint states. -/
theorem leveque04_burgersSelectedField_rarefaction_kinetic
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 ≤ t) :
    leveque04_burgersSelectedField left right x t =
      left + ∫ v in left..right, leveque04_burgersKineticStep v x t := by
  rcases eq_or_lt_of_le htime with hzero | hpositive
  · subst t
    rw [leveque04_burgersSelectedField_initial]
    simp_rw [leveque04_burgersKineticStep_initial]
    by_cases hx : x < 0 <;> simp [riemannData, hx]
  · rw [leveque04_burgersKineticStep_integral left right x t horder hpositive]
    simp only [leveque04_burgersSelectedField, horder, if_true,
      leveque04_burgersRarefactionGlobalCandidate_positive left right x t hpositive,
      leveque04_burgersRarefactionForward]
    ring

/-- The actual ascending selected physical flux is the first kinetic moment,
including time zero, fan edges, and equal states. -/
theorem leveque04_burgersSelectedField_rarefaction_kinetic_flux
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 ≤ t) :
    leveque04_burgersSelectedField left right x t ^ 2 / 2 =
      left ^ 2 / 2 + ∫ v in left..right, v * leveque04_burgersKineticStep v x t := by
  rcases eq_or_lt_of_le htime with hzero | hpositive
  · subst t
    rw [leveque04_burgersSelectedField_initial]
    simp_rw [leveque04_burgersKineticStep_initial]
    by_cases hx : x < 0
    · simp [riemannData, hx]
    · simp [riemannData, hx]
      ring
  · rw [leveque04_burgersKineticStep_velocityMoment_integral left right x t horder hpositive]
    simp only [leveque04_burgersSelectedField, horder, if_true,
      leveque04_burgersRarefactionGlobalCandidate_positive left right x t hpositive,
      leveque04_burgersRarefactionForward]
    ring

private theorem burgers_riemannData_affine_step (left right y : ℝ) :
    riemannData left right right y =
      left + (right - left) * riemannData (0 : ℝ) 1 1 y := by
  unfold riemannData
  split_ifs <;> ring

/-- The descending selected field is the actual Rankine--Hugoniot unit step.
This branch identity holds at every real time, including the initial face. -/
theorem leveque04_burgersSelectedField_shock_kinetic
    (left right x t : ℝ) (horder : right < left) :
    leveque04_burgersSelectedField left right x t =
      left + (right - left) * leveque04_burgersKineticStep ((left + right) / 2) x t := by
  simp only [leveque04_burgersSelectedField, not_le.mpr horder, if_false,
    leveque04_burgersKineticStep, travelingWave]
  exact burgers_riemannData_affine_step left right (x - (left + right) / 2 * t)

/-- Rankine--Hugoniot makes the actual shock flux affine in the same unit step;
no division by the state jump and no restriction on the shock-speed sign occurs. -/
theorem leveque04_burgersSelectedField_shock_kinetic_flux
    (left right x t : ℝ) (horder : right < left) :
    leveque04_burgersSelectedField left right x t ^ 2 / 2 =
      left ^ 2 / 2 + (left + right) / 2 * (right - left) *
        leveque04_burgersKineticStep ((left + right) / 2) x t := by
  rw [leveque04_burgersSelectedField_shock_kinetic left right x t horder,
    leveque04_burgersKineticStep_eq_ite]
  split_ifs <;> ring

end NumStability
