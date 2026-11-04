/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersForwardTrace
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Linarith

/-!
# Measurability, boundedness, and local initial trace of selected Burgers fields

Every pair of real states gives a jointly measurable, uniformly bounded
selected shock/fan field. Its spatial slices are locally integrable, and its
forward initial trace agrees with the actual Riemann data in local L¹.
No integrability over the entire spatial line is asserted or required.
-/

noncomputable section

open Set MeasureTheory Filter
open scoped Topology

namespace NumStability

private theorem burgers_moving_riemann_measurable (left right speed : ℝ) :
    Measurable (fun z : ℝ × ℝ =>
      travelingWave (riemannData left right right) speed z.1 z.2) := by
  simp only [travelingWave, riemannData, ite_self]
  apply Measurable.ite
  · exact measurableSet_lt
      (measurable_fst.sub (measurable_const.mul measurable_snd)) measurable_const
  · exact measurable_const
  · exact measurable_const

/-- The actual selected Burgers field is jointly measurable on the entire
spacetime plane, including the auxiliary backward-time definition. -/
theorem leveque04_burgersSelectedField_measurable (left right : ℝ) :
    Measurable (fun z : ℝ × ℝ => leveque04_burgersSelectedField left right z.1 z.2) := by
  have hstep := burgers_moving_riemann_measurable left right ((left + right) / 2)
  have hfan : Measurable (fun z : ℝ × ℝ =>
      leveque04_burgersRarefactionForward left right z.1 z.2) := by
    exact measurable_const.max ((measurable_fst.div measurable_snd).min measurable_const)
  have hglobal : Measurable (fun z : ℝ × ℝ =>
      leveque04_burgersRarefactionGlobalCandidate left right z.1 z.2) := by
    exact Measurable.ite (measurableSet_le measurable_snd measurable_const) hstep hfan
  by_cases horder : left ≤ right
  · simpa only [leveque04_burgersSelectedField, if_pos horder] using hglobal
  · simpa only [leveque04_burgersSelectedField, if_neg horder] using hstep

/-- The exact endpoint maximum bounds the actual field at every point and
every real time. This uses the existing all-state selected-field bounds. -/
theorem leveque04_burgersSelectedField_abs_le_max (left right x t : ℝ) :
    |leveque04_burgersSelectedField left right x t| ≤ max |left| |right| := by
  exact abs_le.mpr (leveque04_burgersSelectedField_bounds left right (max |left| |right|) x t
    (abs_le.mp (le_max_left _ _)) (abs_le.mp (le_max_right _ _)))

private theorem burgers_initialData_measurable (left right : ℝ) :
    Measurable (riemannData left right right) := by
  simpa only [Function.comp_def, leveque04_burgersSelectedField_initial] using
    (leveque04_burgersSelectedField_measurable left right).comp
      (measurable_id.prodMk (measurable_const : Measurable (fun _ : ℝ => (0 : ℝ))))

private theorem burgers_initialData_abs_le_max (left right x : ℝ) :
    |riemannData left right right x| ≤ max |left| |right| := by
  simpa only [leveque04_burgersSelectedField_initial] using
    leveque04_burgersSelectedField_abs_le_max left right x 0

/-- Actual spatial slices are integrable on every finite oriented interval.
The existing rectangle certificate already provides this fact. -/
theorem leveque04_burgersSelectedField_intervalIntegrable_space
    (left right t a b : ℝ) :
    IntervalIntegrable (fun x => leveque04_burgersSelectedField left right x t) volume a b :=
  (leveque04_burgersSelectedField_isRectangleSolution left right).1 a b t

/-- Local spatial integrability on every closed real interval; endpoints in
reverse order simply give the empty set. -/
theorem leveque04_burgersSelectedField_integrableOn_Icc
    (left right t a b : ℝ) :
    IntegrableOn (fun x => leveque04_burgersSelectedField left right x t) (Icc a b) := by
  apply IntegrableOn.of_bound measure_Icc_lt_top
    (((leveque04_burgersSelectedField_measurable left right).comp
      (measurable_id.prodMk measurable_const)).aestronglyMeasurable) (max |left| |right|)
  filter_upwards [] with x
  simpa only [Real.norm_eq_abs] using leveque04_burgersSelectedField_abs_le_max left right x t

private theorem burgers_initialError_bound (left right x t : ℝ) :
    |leveque04_burgersSelectedField left right x t - riemannData left right right x| ≤
      2 * max |left| |right| := by
  calc
    _ ≤ |leveque04_burgersSelectedField left right x t| + |riemannData left right right x| := by
      simpa only [Real.norm_eq_abs] using norm_sub_le
        (leveque04_burgersSelectedField left right x t) (riemannData left right right x)
    _ ≤ max |left| |right| + max |left| |right| :=
      add_le_add (leveque04_burgersSelectedField_abs_le_max left right x t)
        (burgers_initialData_abs_le_max left right x)
    _ = _ := by rw [two_mul]

private theorem burgers_initialError_measurable (left right t : ℝ) :
    Measurable (fun x =>
      |leveque04_burgersSelectedField left right x t - riemannData left right right x|) := by
  have hsub : Measurable (fun x =>
      leveque04_burgersSelectedField left right x t - riemannData left right right x) :=
    ((leveque04_burgersSelectedField_measurable left right).comp
      (measurable_id.prodMk (measurable_const : Measurable (fun _ : ℝ => t)))).sub
      (burgers_initialData_measurable left right)
  exact continuous_abs.measurable.comp hsub

/-- The actual local L¹ initial-error integral is integrable at every time. -/
theorem leveque04_burgersSelectedField_initialError_integrableOn_Icc
    (left right t a b : ℝ) :
    IntegrableOn (fun x =>
      |leveque04_burgersSelectedField left right x t - riemannData left right right x|)
      (Icc a b) := by
  have hmeas : Measurable (fun x =>
      |leveque04_burgersSelectedField left right x t - riemannData left right right x|) :=
    burgers_initialError_measurable left right t
  apply IntegrableOn.of_bound measure_Icc_lt_top hmeas.aestronglyMeasurable
    (2 * max |left| |right|)
  filter_upwards [] with x
  simpa only [Real.norm_eq_abs, abs_abs] using burgers_initialError_bound left right x t

/-- The actual selected field approaches its actual Riemann initial data in
L¹ on every finite closed interval, as time decreases to zero from above. -/
theorem leveque04_burgersSelectedField_localL1_initialTrace
    (left right a b : ℝ) :
    Tendsto (fun t => ∫ x in Icc a b,
      |leveque04_burgersSelectedField left right x t - riemannData left right right x|)
      (𝓝[>] (0 : ℝ)) (𝓝 (0 : ℝ)) := by
  let μ := volume.restrict (Icc a b)
  let F : ℝ → ℝ → ℝ := fun t x =>
    |leveque04_burgersSelectedField left right x t - riemannData left right right x|
  have hmeas : ∀ᶠ t : ℝ in 𝓝[>] (0 : ℝ), AEStronglyMeasurable (F t) μ := by
    apply Eventually.of_forall
    intro t
    exact (burgers_initialError_measurable left right t).aestronglyMeasurable
  have hbound : ∀ᶠ t : ℝ in 𝓝[>] (0 : ℝ), ∀ᵐ x ∂μ,
      ‖F t x‖ ≤ 2 * max |left| |right| := by
    apply Eventually.of_forall
    intro t
    filter_upwards [] with x
    simpa only [F, Real.norm_eq_abs, abs_abs] using burgers_initialError_bound left right x t
  have hdom : Integrable (fun _ : ℝ => 2 * max |left| |right|) μ :=
    integrableOn_const measure_Icc_lt_top.ne
  have hpointwise : ∀ᵐ x ∂μ,
      Tendsto (fun t => F t x) (𝓝[>] (0 : ℝ)) (𝓝 (0 : ℝ)) := by
    filter_upwards [ae_restrict_of_ae (volume.ae_ne (0 : ℝ))] with x hx
    have h := ((leveque04_burgersSelectedField_initialTrace left right x hx).sub_const
      (riemannData left right right x)).abs
    simpa only [F, sub_self, abs_zero] using h
  simpa only [integral_zero] using tendsto_integral_filter_of_dominated_convergence
    (μ := μ) (l := 𝓝[>] (0 : ℝ)) (F := F) (f := fun _ => (0 : ℝ))
    (fun _ => 2 * max |left| |right|) hmeas hbound hdom hpointwise

end NumStability
