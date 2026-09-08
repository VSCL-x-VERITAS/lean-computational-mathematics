/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import Mathlib.Analysis.Calculus.Deriv.Abs

/-!
# Moving steps and classical mass derivatives

A translated unit step satisfies oriented rectangle conservation.
When its jump crosses a cell endpoint, the cell mass has a corner, for every
selected jump value. Time translation places the crossing at any chosen time.
-/

open MeasureTheory

namespace NumStability.MovingStep

open Set Filter
open scoped Topology

noncomputable section

/-- A unit step traveling right at speed one, with any selected jump representative. -/
def movingStep (valueAtJump x t : ℝ) : ℝ :=
  travelingWave (riemannData 0 valueAtJump 1) 1 x t

theorem movingStep_rectangle (v : ℝ) :
    IsRectangleConservationLawSolution (movingStep v) id := by
  simpa [movingStep] using
    travelingWave_isRectangleConservationLawSolution (riemannData (0 : ℝ) v 1)
      (riemannData_intervalIntegrable 0 v 1) 1

def stepMass (v t : ℝ) : ℝ := ∫ x in (0 : ℝ)..1, movingStep v x t

theorem stepMass_nonpositive (v : ℝ) {t : ℝ} (ht : t ≤ 0) : stepMass v t = 1 := by
  have heq : (∫ x in (0 : ℝ)..1, movingStep v x t) = ∫ _ in (0 : ℝ)..1, (1 : ℝ) := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [] with x hx
    have hx' : x ∈ Ioc (0 : ℝ) 1 := by simpa only [uIoc_of_le zero_le_one] using hx
    have hpos : 0 < x - t := by linarith [hx'.1]
    simp [movingStep, travelingWave, riemannData, hpos, not_lt.mpr hpos.le]
  simpa [stepMass] using heq

theorem stepMass_unitInterval (v : ℝ) {t : ℝ} (ht : t ∈ Icc (0 : ℝ) 1) :
    stepMass v t = 1 - t := by
  have hi (a b : ℝ) : IntervalIntegrable (fun x => movingStep v x t) volume a b :=
    (movingStep_rectangle v).1 a b t
  have hl : (∫ x in (0 : ℝ)..t, movingStep v x t) = 0 := by
    calc
      _ = ∫ _ in (0 : ℝ)..t, (0 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [volume.ae_ne t] with x hxt hx
        have hx' : x ∈ Ioc (0 : ℝ) t := by simpa only [uIoc_of_le ht.1] using hx
        have hneg : x - t < 0 := sub_neg.mpr (lt_of_le_of_ne hx'.2 hxt)
        simp [movingStep, travelingWave, riemannData, hneg]
      _ = 0 := by simp
  have hr : (∫ x in t..1, movingStep v x t) = 1 - t := by
    calc
      _ = ∫ _ in t..1, (1 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with x hx
        have hx' : x ∈ Ioc t 1 := by simpa only [uIoc_of_le ht.2] using hx
        have hpos : 0 < x - t := sub_pos.mpr hx'.1
        simp [movingStep, travelingWave, riemannData, hpos, not_lt.mpr hpos.le]
      _ = 1 - t := by simp
  have hadd := intervalIntegral.integral_add_adjacent_intervals (hi 0 t) (hi t 1)
  simpa [stepMass, hl, hr] using hadd.symm

/-- Endpoint crossing creates a corner in cell mass, for every value at the moving jump. -/
theorem stepMass_not_differentiableAt_zero (v : ℝ) :
    ¬ DifferentiableAt ℝ (stepMass v) 0 := by
  intro hd
  have heq : (abs : ℝ → ℝ) =ᶠ[𝓝 0] (fun t => 2 - 2 * stepMass v t - t) := by
    filter_upwards [eventually_lt_nhds (show (0 : ℝ) < 1 by norm_num)] with t ht
    by_cases hnonpos : t ≤ 0
    · rw [abs_of_nonpos hnonpos, stepMass_nonpositive v hnonpos]
      ring
    · have hnonneg : 0 ≤ t := le_of_lt (lt_of_not_ge hnonpos)
      rw [abs_of_nonneg hnonneg, stepMass_unitInterval v ⟨hnonneg, ht.le⟩]
      ring
  have hdiff : DifferentiableAt ℝ (fun t => 2 - 2 * stepMass v t - t) 0 :=
    (differentiableAt_const (2 : ℝ) |>.sub (hd.const_mul 2)).sub differentiableAt_id
  exact not_differentiableAt_abs_zero (hdiff.congr_of_eventuallyEq heq)

theorem movingStep_rectangle_without_classical_mass_derivative (v : ℝ) :
    IsRectangleConservationLawSolution (movingStep v) id ∧
      ∀ d : ℝ, ¬ HasDerivAt (fun t => ∫ x in (0 : ℝ)..1, movingStep v x t) d 0 := by
  refine ⟨movingStep_rectangle v, ?_⟩
  intro d hd
  exact stepMass_not_differentiableAt_zero v hd.differentiableAt

/-- Translate the crossing to any prescribed time, including a strictly positive time. -/
def timeShiftedStep (v τ x t : ℝ) : ℝ := movingStep v x (t - τ)

theorem timeShiftedStep_rectangle (v τ : ℝ) :
    IsRectangleConservationLawSolution (timeShiftedStep v τ) id := by
  have h := movingStep_rectangle v
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    exact h.1 a b (t - τ)
  · intro x s t
    simpa only [timeShiftedStep, sub_add_cancel] using
      (h.2.1 x (s - τ) (t - τ)).comp_sub_right τ
  · intro a b s t
    exact (h.2.2 a b (s - τ) (t - τ)).trans
      (intervalIntegral.integral_comp_sub_right
        (f := fun r => id (movingStep v a r) - id (movingStep v b r)) (a := s) (b := t) τ).symm

theorem timeShiftedStep_no_classical_mass_derivative (v τ d : ℝ) :
    ¬ HasDerivAt (fun t => ∫ x in (0 : ℝ)..1, timeShiftedStep v τ x t) d τ := by
  intro hd
  have hmass : DifferentiableAt ℝ (fun t => stepMass v (t - τ)) τ := hd.differentiableAt
  have hmass' : DifferentiableAt ℝ (fun t => stepMass v (t - τ)) (id 0 + τ) := by
    simpa only [id_eq, zero_add] using hmass
  have hcomp := hmass'.comp 0 (differentiableAt_id.add_const τ)
  simp only [Function.comp_def, id_eq, add_sub_cancel_right] at hcomp
  exact stepMass_not_differentiableAt_zero v hcomp



/-- The spatial derivative required by the classical advection equation
cannot exist at the jump crossing, independently of its selected point value. -/
theorem timeShiftedStep_no_classical_advection_at_crossing (v τ : ℝ) :
    ¬ IsLinearAdvectionSolutionAt (timeShiftedStep v τ) 1 0 τ := by
  rintro ⟨qt, qx, _ht, hx, _hresidual⟩
  have hc : ContinuousAt (riemannData (0 : ℝ) v 1) 0 := by
    simpa only [timeShiftedStep, movingStep, travelingWave, sub_self, mul_zero, sub_zero]
      using hx.continuousAt
  exact (riemannData_isRiemannData (0 : ℝ) v 1).not_continuousAt_zero zero_ne_one hc

end

end NumStability.MovingStep
