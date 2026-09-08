/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.Examples.HuberShock.Regularity
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.Piecewise
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.Rectangle

/-!
# Rectangle conservation for the Huber shock

Spatial and temporal integrability are proved independently. Applying FTC
to the displayed potential then gives balance on every oriented rectangle.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem shockState_space_intervalIntegrable (a b t : ℝ) :
    IntervalIntegrable (fun x => shockState x t) volume a b := by
  have hout : IntervalIntegrable (fun x => outerState x t) volume a b := by
    apply intervalIntegrable_piecewise measurableSet_Iio
    · exact (by fun_prop : Continuous (fun x : ℝ => t - x)).intervalIntegrable a b
    · exact (by fun_prop : Continuous (fun x : ℝ => -t - x)).intervalIntegrable a b
  apply intervalIntegrable_piecewise
    (isOpen_lt continuous_const (continuous_const.sub continuous_abs)).measurableSet
  · exact (by fun_prop : Continuous (fun x : ℝ => -x / (1 - t))).intervalIntegrable a b
  · exact hout

theorem clippedCentralState_continuous (x : ℝ) :
    Continuous (fun t : ℝ => -x / max (1 - t) |x|) := by
  by_cases hx : x = 0
  · subst x
    simpa only [neg_zero, zero_div] using (continuous_const : Continuous (fun _ : ℝ => (0 : ℝ)))
  apply continuous_const.div ((continuous_const.sub continuous_id).max continuous_const)
  intro t
  exact ne_of_gt ((abs_pos.mpr hx).trans_le (le_max_right (1 - t) |x|))

theorem shockState_flux_time_intervalIntegrable (x a b : ℝ) :
    IntervalIntegrable (fun t => huberFlux (shockState x t)) volume a b := by
  have hrepr : (fun t => huberFlux (shockState x t)) =
      fun t => if t < 1 - |x| then huberFlux (-x / max (1 - t) |x|)
        else huberFlux (outerState x t) := by
    funext t
    by_cases ht : t < 1 - |x|
    · simp only [shockState, if_pos ht, max_eq_left (show |x| ≤ 1 - t by linarith)]
    · simp only [shockState, if_neg ht]
  rw [hrepr]
  apply intervalIntegrable_piecewise measurableSet_Iio
  · exact (huberFlux_contDiff_one.continuous.comp (clippedCentralState_continuous x)).intervalIntegrable a b
  · have hout : Continuous (outerState x) := by
      unfold outerState
      split_ifs <;> fun_prop
    exact (huberFlux_contDiff_one.continuous.comp hout).intervalIntegrable a b

theorem shockState_mass_potential (a b t : ℝ) :
    (∫ x in a..b, shockState x t) = shockPotential b t - shockPotential a t := by
  exact intervalIntegral.integral_eq_sub_of_hasDeriv_right
    (shockPotential_space_continuous t).continuousOn
    (fun x _ => shockPotential_space_right_deriv x t)
    (shockState_space_intervalIntegrable a b t)

theorem shockState_flux_potential (x a b : ℝ) :
    (∫ t in a..b, huberFlux (shockState x t)) = shockPotential x a - shockPotential x b := by
  have hh := intervalIntegral.integral_eq_sub_of_hasDeriv_right
    (shockPotential_time_continuous x).continuousOn
    (fun t _ => shockPotential_time_right_deriv x t)
    (shockState_flux_time_intervalIntegrable x a b).neg
  rw [intervalIntegral.integral_neg] at hh
  linarith

/-- Complete oriented rectangle balance for the constructed field, proved from its
primitive and right-derivative FTC; no conservation-law certificate is an input. -/
theorem shockState_rectangle_balance (a b s t : ℝ) :
    (∫ x in a..b, shockState x t) - (∫ x in a..b, shockState x s) =
      ∫ τ in s..t, (huberFlux (shockState a τ) - huberFlux (shockState b τ)) := by
  rw [shockState_mass_potential, shockState_mass_potential,
    intervalIntegral.integral_sub (shockState_flux_time_intervalIntegrable a s t)
      (shockState_flux_time_intervalIntegrable b s t),
    shockState_flux_potential, shockState_flux_potential]
  ring

/-- The explicit field satisfies the shared conservation predicate. -/
theorem shockState_isRectangleConservationLawSolution :
    IsRectangleConservationLawSolution shockState huberFlux :=
  ⟨shockState_space_intervalIntegrable, shockState_flux_time_intervalIntegrable,
    shockState_rectangle_balance⟩

end

end NumStability.HuberShock
