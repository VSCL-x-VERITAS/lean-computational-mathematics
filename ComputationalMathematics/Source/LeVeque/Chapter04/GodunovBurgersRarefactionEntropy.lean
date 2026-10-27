/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BurgersKruzkovFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersPotential

/-!
# Positive-time absolute-value entropy balance of the centered Burgers fan

A linear combination of the existing mass primitives supplies the entropy
primitive. The time domain is positive; the backward jump extension is not
asserted to satisfy the entropy inequality.
-/

open MeasureTheory

namespace NumStability

/-- Raising both fan endpoints to a reference state raises the clamped
fan value to that reference state. -/
theorem leveque04_burgersRarefactionForward_max_reference
    (left right reference x t : ℝ) :
    leveque04_burgersRarefactionForward (max left reference) (max right reference) x t =
      max (leveque04_burgersRarefactionForward left right x t) reference := by
  simp only [leveque04_burgersRarefactionForward, leveque04_burgersRarefactionProfile]
  grind

/-- Spatial primitive of the absolute-value entropy along the centered fan. -/
noncomputable def leveque04_burgersRarefactionEntropyPotential
    (left right reference x t : ℝ) : ℝ :=
  2 * leveque04_burgersRarefactionPotential (max left reference) (max right reference) x t -
    leveque04_burgersRarefactionPotential left right x t - reference * x + reference ^ 2 * t / 2

theorem leveque04_burgersRarefactionEntropyPotential_space_hasDerivAt
    (left right reference x t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    HasDerivAt (fun y => leveque04_burgersRarefactionEntropyPotential left right reference y t)
      |leveque04_burgersRarefactionForward left right x t - reference| x := by
  have hd := (((leveque04_burgersRarefactionPotential_space_hasDerivAt
    (max left reference) (max right reference) x t (max_le_max_right reference horder) htime).const_mul 2).sub
      (leveque04_burgersRarefactionPotential_space_hasDerivAt left right x t horder htime)).sub
        ((hasDerivAt_id x).const_mul reference)
  have hh := hd.add_const (reference ^ 2 * t / 2)
  change HasDerivAt (fun y => leveque04_burgersRarefactionEntropyPotential left right reference y t) _ x at hh
  apply hh.congr_deriv
  rw [leveque04_burgersRarefactionForward_max_reference]
  rcases le_total (leveque04_burgersRarefactionForward left right x t) reference with h | h
  · rw [max_eq_right h, abs_of_nonpos (sub_nonpos.mpr h)]
    ring
  · rw [max_eq_left h, abs_of_nonneg (sub_nonneg.mpr h)]
    ring

theorem leveque04_burgersRarefactionEntropyPotential_time_hasDerivAt
    (left right reference x t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    HasDerivAt (fun τ => leveque04_burgersRarefactionEntropyPotential left right reference x τ)
      (-burgersKruzkovFlux reference (leveque04_burgersRarefactionForward left right x t)) t := by
  have hd := (((leveque04_burgersRarefactionPotential_time_hasDerivAt
    (max left reference) (max right reference) x t (max_le_max_right reference horder) htime).const_mul 2).sub
      (leveque04_burgersRarefactionPotential_time_hasDerivAt left right x t horder htime)).sub_const
        (reference * x)
  have hh := hd.add (((hasDerivAt_id t).const_mul (reference ^ 2)).div_const 2)
  change HasDerivAt (fun τ => leveque04_burgersRarefactionEntropyPotential left right reference x τ) _ t at hh
  apply hh.congr_deriv
  rw [leveque04_burgersRarefactionForward_max_reference, burgersKruzkovFlux_eq_max]
  ring

/-- Every spatial entropy trace is integrable, including both fan edges. -/
theorem leveque04_burgersRarefactionForward_entropy_space_integrable
    (left right reference a b t : ℝ) :
    IntervalIntegrable (fun x => |leveque04_burgersRarefactionForward left right x t - reference|)
      volume a b := by
  exact ((leveque04_burgersRarefactionProfile_lipschitz left right).continuous.comp
    (continuous_id.div_const t) |>.sub continuous_const |>.abs).intervalIntegrable a b

/-- Every positive-time entropy-flux trace is integrable. -/
theorem leveque04_burgersRarefactionForward_entropy_flux_integrable
    (left right reference x s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    IntervalIntegrable (fun τ => burgersKruzkovFlux reference
      (leveque04_burgersRarefactionForward left right x τ)) volume s t := by
  simp_rw [burgersKruzkovFlux_eq_max]
  apply ContinuousOn.intervalIntegrable
  intro τ hτ
  have hτpos := (lt_min hs ht).trans_le hτ.1
  have hquot : ContinuousAt (fun σ : ℝ => x / σ) τ :=
    continuousAt_const.div continuousAt_id (ne_of_gt hτpos)
  have hstate : ContinuousAt (fun σ => leveque04_burgersRarefactionForward left right x σ) τ :=
    ((leveque04_burgersRarefactionProfile_lipschitz left right).continuous
      |>.continuousAt.comp hquot)
  have hcont : ContinuousAt (fun σ =>
      (max (leveque04_burgersRarefactionForward left right x σ) reference) ^ 2 -
        (leveque04_burgersRarefactionForward left right x σ) ^ 2 / 2 - reference ^ 2 / 2) τ :=
    (((hstate.max (continuousAt_const (y := reference))).pow 2).sub
      ((hstate.pow 2).div_const 2)).sub (continuousAt_const (y := reference ^ 2 / 2))
  exact hcont.continuousWithinAt

theorem leveque04_burgersRarefactionForward_entropy_mass_potential
    (left right reference a b t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    (∫ x in a..b, |leveque04_burgersRarefactionForward left right x t - reference|) =
      leveque04_burgersRarefactionEntropyPotential left right reference b t -
        leveque04_burgersRarefactionEntropyPotential left right reference a t := by
  exact intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun x _ => leveque04_burgersRarefactionEntropyPotential_space_hasDerivAt
      left right reference x t horder htime)
    (leveque04_burgersRarefactionForward_entropy_space_integrable left right reference a b t)

theorem leveque04_burgersRarefactionForward_entropy_flux_potential
    (left right reference x s t : ℝ) (horder : left ≤ right) (hs : 0 < s) (ht : 0 < t) :
    (∫ τ in s..t, burgersKruzkovFlux reference (leveque04_burgersRarefactionForward left right x τ)) =
      leveque04_burgersRarefactionEntropyPotential left right reference x s -
        leveque04_burgersRarefactionEntropyPotential left right reference x t := by
  have hh := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun τ (hτ : τ ∈ Set.uIcc s t) =>
      leveque04_burgersRarefactionEntropyPotential_time_hasDerivAt left right reference x τ horder
        ((lt_min hs ht).trans_le hτ.1))
    (leveque04_burgersRarefactionForward_entropy_flux_integrable left right reference x s t hs ht).neg
  rw [intervalIntegral.integral_neg] at hh
  linarith

/-- The centered ascending fan conserves every absolute-value entropy on
each oriented rectangle with positive time faces. -/
theorem leveque04_burgersRarefactionForward_entropy_rectangle_positive
    (left right reference a b s t : ℝ) (horder : left ≤ right) (hs : 0 < s) (ht : 0 < t) :
    (∫ x in a..b, |leveque04_burgersRarefactionForward left right x t - reference|) -
        (∫ x in a..b, |leveque04_burgersRarefactionForward left right x s - reference|) =
      ∫ τ in s..t, (burgersKruzkovFlux reference (leveque04_burgersRarefactionForward left right a τ) -
        burgersKruzkovFlux reference (leveque04_burgersRarefactionForward left right b τ)) := by
  rw [leveque04_burgersRarefactionForward_entropy_mass_potential left right reference a b t horder ht,
    leveque04_burgersRarefactionForward_entropy_mass_potential left right reference a b s horder hs,
    intervalIntegral.integral_sub
      (leveque04_burgersRarefactionForward_entropy_flux_integrable left right reference a s t hs ht)
      (leveque04_burgersRarefactionForward_entropy_flux_integrable left right reference b s t hs ht),
    leveque04_burgersRarefactionForward_entropy_flux_potential left right reference a s t horder hs ht,
    leveque04_burgersRarefactionForward_entropy_flux_potential left right reference b s t horder hs ht]
  ring

end NumStability
