/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersPotential

/-!
# Initial-time primitive for the Burgers rarefaction

The continuous initial primitive has the two constant Riemann slopes.
Its value is the positive-time limit of the centered fan potential.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

/-- Primitive of the two-state Riemann data, continuous at the jump. -/
noncomputable def leveque04_burgersInitialPotential (left right x : ℝ) : ℝ :=
  if x < 0 then left * x else right * x

theorem leveque04_burgersInitialPotential_continuous (left right : ℝ) :
    Continuous (leveque04_burgersInitialPotential left right) := by
  apply continuous_if_lt_of_closed
  · exact (continuous_const.mul continuous_id).continuousOn
  · exact (continuous_const.mul continuous_id).continuousOn
  · simp

/-- The derivative from the right uses the right state at the jump. -/
theorem leveque04_burgersInitialPotential_space_rightDeriv (left right x : ℝ) :
    HasDerivWithinAt (leveque04_burgersInitialPotential left right)
      (riemannData left right right x) (Ioi x) x := by
  have hd := hasDerivWithinAt_if_lt_right (c := 0)
    (fun _ => ((hasDerivAt_id x).const_mul left).hasDerivWithinAt)
    (fun _ => ((hasDerivAt_id x).const_mul right).hasDerivWithinAt)
  convert hd using 1
  simp only [riemannData]
  split_ifs <;> simp

/-- The initial Riemann mass is an endpoint difference of its primitive. -/
theorem leveque04_burgersInitialPotential_mass (left right a b : ℝ) :
    (∫ x in a..b, riemannData left right right x) =
      leveque04_burgersInitialPotential left right b -
        leveque04_burgersInitialPotential left right a := by
  exact intervalIntegral.integral_eq_sub_of_hasDeriv_right
    (leveque04_burgersInitialPotential_continuous left right).continuousOn
    (fun x _ => leveque04_burgersInitialPotential_space_rightDeriv left right x)
    (riemannData_intervalIntegrable left right right a b)

/-- At the central spatial face, the primitive is linear in positive
time with slope minus the zero-ray flux. -/
theorem leveque04_burgersRarefactionPotential_zeroSpace
    (left right t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    leveque04_burgersRarefactionPotential left right 0 t =
      -(leveque04_burgersRarefactionProfile left right 0) ^ 2 * t / 2 := by
  by_cases hl : 0 ≤ left
  · rw [leveque04_burgersRarefactionPotential_leftRegion left right 0 t horder htime
      (by positivity), leveque04_burgersRarefactionProfile_left left right 0 horder hl]
    ring
  · by_cases hr : right ≤ 0
    · rw [leveque04_burgersRarefactionPotential_rightRegion left right 0 t horder htime
        (mul_nonpos_of_nonpos_of_nonneg hr htime.le),
        leveque04_burgersRarefactionProfile_right left right 0 horder hr]
      ring
    · rw [leveque04_burgersRarefactionPotential_fan left right 0 t htime
        (mul_nonpos_of_nonpos_of_nonneg (le_of_not_ge hl) htime.le)
          (mul_nonneg (le_of_not_ge hr) htime.le),
        leveque04_burgersRarefactionProfile_interior left right 0
          (le_of_not_ge hl) (le_of_not_ge hr)]
      simp

/-- Every fixed-face primitive converges to the initial Riemann
primitive as positive time tends to zero. -/
theorem leveque04_burgersRarefactionPotential_initialTrace
    (left right x : ℝ) (horder : left ≤ right) :
    Tendsto (fun t => leveque04_burgersRarefactionPotential left right x t)
      (nhdsWithin 0 (Ioi 0)) (nhds (leveque04_burgersInitialPotential left right x)) := by
  rcases lt_trichotomy x 0 with hx | hx | hx
  · have hev : ∀ᶠ t : ℝ in nhds 0, x < left * t := by
      have ht : Tendsto (fun t : ℝ => left * t) (nhds 0) (nhds 0) := by
        have hc : Continuous (fun t : ℝ => left * t) := by fun_prop
        simpa using hc.continuousAt (x := 0) |>.tendsto
      exact ht.eventually (eventually_gt_nhds hx)
    have ht : Tendsto (fun t : ℝ => left * x - left ^ 2 * t / 2)
        (nhdsWithin 0 (Ioi 0)) (nhds (left * x)) := by
      have hc : Continuous (fun t : ℝ => left * x - left ^ 2 * t / 2) := by fun_prop
      simpa using (hc.continuousAt (x := 0)).tendsto.mono_left inf_le_left
    simpa only [leveque04_burgersInitialPotential, if_pos hx] using ht.congr'
      (by
        filter_upwards [hev.filter_mono inf_le_left, self_mem_nhdsWithin] with t ht hpos
        exact (leveque04_burgersRarefactionPotential_leftRegion left right x t
          horder hpos ht.le).symm)
  · subst x
    have ht : Tendsto (fun t : ℝ =>
        -(leveque04_burgersRarefactionProfile left right 0) ^ 2 * t / 2)
        (nhdsWithin 0 (Ioi 0)) (nhds 0) := by
      have hc : Continuous (fun t : ℝ =>
          -(leveque04_burgersRarefactionProfile left right 0) ^ 2 * t / 2) := by fun_prop
      simpa using (hc.continuousAt (x := 0)).tendsto.mono_left inf_le_left
    simpa only [leveque04_burgersInitialPotential, lt_self_iff_false, if_false, mul_zero]
      using ht.congr' (by
        filter_upwards [self_mem_nhdsWithin] with t hpos
        exact (leveque04_burgersRarefactionPotential_zeroSpace left right t horder hpos).symm)
  · have hev : ∀ᶠ t : ℝ in nhds 0, right * t < x := by
      have ht : Tendsto (fun t : ℝ => right * t) (nhds 0) (nhds 0) := by
        have hc : Continuous (fun t : ℝ => right * t) := by fun_prop
        simpa using hc.continuousAt (x := 0) |>.tendsto
      exact ht.eventually (eventually_lt_nhds hx)
    have ht : Tendsto (fun t : ℝ => right * x - right ^ 2 * t / 2)
        (nhdsWithin 0 (Ioi 0)) (nhds (right * x)) := by
      have hc : Continuous (fun t : ℝ => right * x - right ^ 2 * t / 2) := by fun_prop
      simpa using (hc.continuousAt (x := 0)).tendsto.mono_left inf_le_left
    simpa only [leveque04_burgersInitialPotential, if_neg (not_lt.mpr hx.le)] using ht.congr'
      (by
        filter_upwards [hev.filter_mono inf_le_left, self_mem_nhdsWithin] with t ht hpos
        exact (leveque04_burgersRarefactionPotential_rightRegion left right x t
          horder hpos ht.le).symm)

/-- The whole-time candidate's physical face flux from initial time
is the endpoint difference of the forward primitive. -/
theorem leveque04_burgersRarefactionGlobalCandidate_flux_from_initial
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    (∫ τ in (0 : ℝ)..t,
      (leveque04_burgersRarefactionGlobalCandidate left right x τ) ^ 2 / 2) =
      leveque04_burgersInitialPotential left right x -
        leveque04_burgersRarefactionPotential left right x t := by
  have hint := leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime
    left right x 0 t horder
  have hd : ∀ τ ∈ Ioo (0 : ℝ) t,
      HasDerivAt (fun σ => leveque04_burgersRarefactionPotential left right x σ)
        (-((leveque04_burgersRarefactionGlobalCandidate left right x τ) ^ 2 / 2)) τ := by
    intro τ hτ
    rw [leveque04_burgersRarefactionGlobalCandidate_positive left right x τ hτ.1]
    simpa only [neg_div] using
      leveque04_burgersRarefactionPotential_time_hasDerivAt left right x τ horder hτ.1
  have hh := intervalIntegral.integral_eq_sub_of_hasDerivAt_of_tendsto
    htime hd hint.neg (leveque04_burgersRarefactionPotential_initialTrace left right x horder)
    ((leveque04_burgersRarefactionPotential_time_hasDerivAt left right x t horder htime).continuousAt.tendsto.mono_left inf_le_left)
  rw [intervalIntegral.integral_neg] at hh
  linarith

/-- The constructed rarefaction satisfies the initial-to-positive-time
rectangle balance, with the exact Riemann data at the initial face. -/
theorem leveque04_burgersRarefactionGlobalCandidate_rectangle_from_initial_positive
    (left right a b t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    (∫ x in a..b, leveque04_burgersRarefactionGlobalCandidate left right x t) -
        (∫ x in a..b, leveque04_burgersRarefactionGlobalCandidate left right x 0) =
      ∫ τ in (0 : ℝ)..t,
        ((leveque04_burgersRarefactionGlobalCandidate left right a τ) ^ 2 / 2 -
          (leveque04_burgersRarefactionGlobalCandidate left right b τ) ^ 2 / 2) := by
  simp only [leveque04_burgersRarefactionGlobalCandidate_positive left right _ t htime,
    leveque04_burgersRarefactionGlobalCandidate_initial]
  rw [leveque04_burgersRarefactionForward_mass_potential left right a b t horder htime,
    leveque04_burgersInitialPotential_mass,
    intervalIntegral.integral_sub
      (leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime left right a 0 t horder)
      (leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime left right b 0 t horder),
    leveque04_burgersRarefactionGlobalCandidate_flux_from_initial left right a t horder htime,
    leveque04_burgersRarefactionGlobalCandidate_flux_from_initial left right b t horder htime]
  ring

/-- The joined fan and backward moving jump balance from initial time
to every time, using the appropriate evolution on each half-line. -/
theorem leveque04_burgersRarefactionGlobalCandidate_rectangle_from_initial
    (left right a b t : ℝ) (horder : left ≤ right) :
    (∫ x in a..b, leveque04_burgersRarefactionGlobalCandidate left right x t) -
        (∫ x in a..b, leveque04_burgersRarefactionGlobalCandidate left right x 0) =
      ∫ τ in (0 : ℝ)..t,
        ((leveque04_burgersRarefactionGlobalCandidate left right a τ) ^ 2 / 2 -
          (leveque04_burgersRarefactionGlobalCandidate left right b τ) ^ 2 / 2) := by
  by_cases ht : t ≤ 0
  · rw [show (fun x => leveque04_burgersRarefactionGlobalCandidate left right x t) =
        fun x => travelingWave (riemannData left right right) ((left + right) / 2) x t from
      funext (fun x => leveque04_burgersRarefactionGlobalCandidate_nonpositive left right x t ht),
      show (fun x => leveque04_burgersRarefactionGlobalCandidate left right x 0) =
        fun x => travelingWave (riemannData left right right) ((left + right) / 2) x 0 from
      funext (fun x => leveque04_burgersRarefactionGlobalCandidate_nonpositive left right x 0 le_rfl)]
    rw [(leveque04_burgersRarefaction_backwardJump_rectangle left right).2.2 a b 0 t]
    apply intervalIntegral.integral_congr
    intro τ hτ
    have hτnonpos : τ ≤ 0 := hτ.2.trans (max_le le_rfl ht)
    dsimp
    rw [leveque04_burgersRarefactionGlobalCandidate_nonpositive left right a τ hτnonpos,
      leveque04_burgersRarefactionGlobalCandidate_nonpositive left right b τ hτnonpos]
  · exact leveque04_burgersRarefactionGlobalCandidate_rectangle_from_initial_positive
      left right a b t horder (lt_of_not_ge ht)

/-- Complete oriented rectangle balance for the ascending Burgers
Riemann solver, including rectangles crossing the initial-time slice. -/
theorem leveque04_burgersRarefactionGlobalCandidate_rectangle_balance
    (left right a b s t : ℝ) (horder : left ≤ right) :
    (∫ x in a..b, leveque04_burgersRarefactionGlobalCandidate left right x t) -
        (∫ x in a..b, leveque04_burgersRarefactionGlobalCandidate left right x s) =
      ∫ τ in s..t,
        ((leveque04_burgersRarefactionGlobalCandidate left right a τ) ^ 2 / 2 -
          (leveque04_burgersRarefactionGlobalCandidate left right b τ) ^ 2 / 2) := by
  have h0t := leveque04_burgersRarefactionGlobalCandidate_rectangle_from_initial
    left right a b t horder
  have h0s := leveque04_burgersRarefactionGlobalCandidate_rectangle_from_initial
    left right a b s horder
  have h0tint := (leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime
    left right a 0 t horder).sub
      (leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime left right b 0 t horder)
  have h0sint := (leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime
    left right a 0 s horder).sub
      (leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime left right b 0 s horder)
  calc
    _ = (∫ τ in (0 : ℝ)..t,
        ((leveque04_burgersRarefactionGlobalCandidate left right a τ) ^ 2 / 2 -
          (leveque04_burgersRarefactionGlobalCandidate left right b τ) ^ 2 / 2)) -
      (∫ τ in (0 : ℝ)..s,
        ((leveque04_burgersRarefactionGlobalCandidate left right a τ) ^ 2 / 2 -
          (leveque04_burgersRarefactionGlobalCandidate left right b τ) ^ 2 / 2)) := by linarith
    _ = _ := intervalIntegral.integral_interval_sub_left h0tint h0sint

/-- The explicit joined candidate inhabits the shared conservation
predicate without assuming a conservation certificate. -/
theorem leveque04_burgersRarefactionGlobalCandidate_isRectangleSolution
    (left right : ℝ) (horder : left ≤ right) :
    IsRectangleConservationLawSolution
      (leveque04_burgersRarefactionGlobalCandidate left right) (fun u : ℝ => u ^ 2 / 2) := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    exact leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_space left right t a b
  · intro x s t
    exact leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime left right x s t horder
  · intro a b s t
    exact leveque04_burgersRarefactionGlobalCandidate_rectangle_balance left right a b s t horder

end NumStability
