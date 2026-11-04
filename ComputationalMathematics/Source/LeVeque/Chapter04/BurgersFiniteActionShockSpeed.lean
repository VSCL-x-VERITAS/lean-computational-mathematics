/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionCurveDerivative
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionBoundaryMinimizers
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionSpatialTraces
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionLabelTimeRegularity
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionWeakPotential

/-!
# Actual shock velocities of the finite Burgers action field

Touching fixed-foot actions identify velocities along an actual curve. The
existing Lipschitz regularity of the forward potential and the curve supplies
both differentiability hypotheses almost everywhere. At two distinct minimizing
feet the actual curve speed is the Burgers Rankine-Hugoniot mean. In particular,
every descending original jump has this speed with the actual left/right traces,
including its interaction descendants. No physical bound S is assumed or derived.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Topology NNReal

namespace NumStability

theorem leveque04_burgersFiniteAction_curve_speed_of_distinct_minimizers {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (curve : ℝ → ℝ)
    (time y z speed : ℝ) (hwidth : 0 ≤ width) (htime : 0 < time)
    (hcurve : HasDerivAt curve speed time)
    (hpotential : DifferentiableAt ℝ
      (fun s => leveque04_burgersFiniteActionForwardPotential old origin width (curve s) s) time)
    (hy : y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)
    (hz : z ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)
    (hyz : y ≠ z) :
    speed = (((curve time - y) / time) + ((curve time - z) / time)) / 2 := by
  apply quadraticActionEnvelope_curve_speed_of_distinct_touching_feet
    (leveque04_burgersInitialPrimitive old origin width)
    (fun s => leveque04_burgersFiniteActionForwardPotential old origin width (curve s) s)
    curve time y z speed htime hcurve hyz
  · intro s hs
    rw [leveque04_burgersFiniteActionForwardPotential_positive old origin width (curve s) s hs]
    exact leveque04_burgersFiniteActionPotential_le old origin width (curve s) s hwidth hs y
  · intro s hs
    rw [leveque04_burgersFiniteActionForwardPotential_positive old origin width (curve s) s hs]
    exact leveque04_burgersFiniteActionPotential_le old origin width (curve s) s hwidth hs z
  · exact (leveque04_burgersFiniteActionForwardPotential_positive old origin width
      (curve time) time htime).trans hy.symm
  · exact (leveque04_burgersFiniteActionForwardPotential_positive old origin width
      (curve time) time htime).trans hz.symm
  · exact hpotential

/-- For any actual Lipschitz observation curve, every pair of distinct current
minimizing feet determines its speed at almost every positive time. -/
theorem leveque04_burgersFiniteAction_curve_shock_speed_ae {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (curve : ℝ → ℝ)
    {C : ℝ≥0} (hcurve : LipschitzWith C curve) (hwidth : 0 ≤ width) :
    ∀ᵐ time : ℝ, 0 < time → ∀ y ∈
      leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time,
      ∀ z ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time,
      y ≠ z → deriv curve time =
        (((curve time - y) / time) + ((curve time - z) / time)) / 2 := by
  have hp := (leveque04_burgersFiniteActionForwardPotential_joint_lipschitz
    old origin width hwidth).comp (hcurve.prodMk LipschitzWith.id)
  filter_upwards [hcurve.ae_differentiableAt_real, hp.ae_differentiableAt_real] with time hc hP
  intro ht y hy z hz hyz
  exact leveque04_burgersFiniteAction_curve_speed_of_distinct_minimizers
    old origin width curve time y z (deriv curve time) hwidth ht hc.hasDerivAt hP hy hz hyz

/-- Actual descending-jump shock velocity is the mean of the already proved
physical spatial traces. The fixed label is retained through interactions. -/
theorem leveque04_burgersFiniteAction_descendingFace_shock_speed_ae {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hdescending : leveque04_burgersActionState old (j.val + 1) < leveque04_burgersActionState old j.val) :
    ∀ᵐ time : ℝ, 0 < time →
      let curve := leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val)
      deriv curve time =
        (((curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width
          (curve time) time)) / time) +
          leveque04_burgersFiniteActionEvolution old origin width (curve time) time) / 2 := by
  let curve := leveque04_burgersFiniteActionLabelLeft old origin width
    (leveque04_burgersActionFace origin width j.val)
  have hlip := (leveque04_burgersFiniteActionLabelBoundaries_time_lipschitz old origin width
    (leveque04_burgersActionFace origin width j.val) hwidth.le).1
  filter_upwards [leveque04_burgersFiniteAction_curve_shock_speed_ae
    old origin width curve hlip hwidth.le] with time ht
  intro htime
  have hleast := leveque04_burgersFiniteActionMinimizingFeet_sInf_isLeast
    old origin width (curve time) time hwidth.le htime
  have hgreat := leveque04_burgersFiniteActionFoot_isGreatest
    old origin width (curve time) time hwidth.le htime
  obtain ⟨_, y, z, hy, hz, hya, haz⟩ :=
    leveque04_burgersFiniteAction_descendingFace_shock_minimizers
      old origin width time j hwidth htime hdescending
  have hlt : sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time) <
      leveque04_burgersFiniteActionFoot old origin width (curve time) time :=
    (hleast.2 hy).trans_lt ((hya.trans haz).trans_le (hgreat.2 hz))
  have hv := ht htime _ hleast.1 _ hgreat.1 (ne_of_lt hlt)
  simpa only [leveque04_burgersFiniteActionEvolution_positive old origin width _ time htime,
    leveque04_burgersFiniteActionVelocity] using hv

end NumStability
