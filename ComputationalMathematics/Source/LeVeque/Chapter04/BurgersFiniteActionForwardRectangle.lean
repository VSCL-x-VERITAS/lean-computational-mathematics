/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionEvolution

/-!
# Rectangle conservation including the actual initial time

The extended potential is Lipschitz in time. Its positive-time derivative is
the negative physical flux of the same actual evolution; the initial time is
a null set for the time integral. FTC therefore includes zero endpoints, while
the spatial mass at zero comes from the prescribed initial datum, not a value
assigned by total division. No negative-time conservation or compact-test
distribution implication is asserted here.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Topology Interval

namespace NumStability

theorem leveque04_burgersFiniteActionForwardPotential_temporal_hasDerivAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hdiff : DifferentiableAt ℝ
      (fun s => leveque04_burgersFiniteActionForwardPotential old origin width x s) time) :
    HasDerivAt (fun s => leveque04_burgersFiniteActionForwardPotential old origin width x s)
      (-(leveque04_burgersFiniteActionEvolution old origin width x time) ^ 2 / 2) time := by
  have heq : (fun s => leveque04_burgersFiniteActionForwardPotential old origin width x s) =ᶠ[𝓝 time]
      (fun s => leveque04_burgersFiniteActionPotential old origin width x s) := by
    filter_upwards [eventually_gt_nhds htime] with s hs
    exact leveque04_burgersFiniteActionForwardPotential_positive old origin width x s hs
  have hdiffP := hdiff.congr_of_eventuallyEq heq.symm
  have hderiv := (leveque04_burgersFiniteActionPotential_temporal_hasDerivAt
    old origin width x time hwidth htime hdiffP).congr_of_eventuallyEq heq
  simpa only [leveque04_burgersFiniteActionEvolution_positive old origin width x time htime] using hderiv

theorem leveque04_burgersFiniteActionEvolution_temporal_flux_integral {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x start finish : ℝ)
    (hwidth : 0 ≤ width) (hstart : 0 ≤ start) (hfinish : 0 ≤ finish) :
    IntervalIntegrable
      (fun time => leveque04_burgersFiniteActionEvolution old origin width x time ^ 2 / 2)
      volume start finish ∧
      (∫ time in start..finish,
        leveque04_burgersFiniteActionEvolution old origin width x time ^ 2 / 2) =
          leveque04_burgersFiniteActionForwardPotential old origin width x start -
            leveque04_burgersFiniteActionForwardPotential old origin width x finish := by
  have hnonneg : ∀ time ∈ uIcc start finish, 0 ≤ time := by
    intro time ht
    rcases le_total start finish with hsf | hfs
    · rw [uIcc_of_le hsf] at ht
      exact hstart.trans ht.1
    · rw [uIcc_of_ge hfs] at ht
      exact hfinish.trans ht.1
  have hac := ((leveque04_burgersFiniteActionForwardPotential_time_lipschitz
    old origin width x hwidth).lipschitzOnWith (s := uIcc start finish)).absolutelyContinuousOnInterval
  have heq : ∀ᵐ time : ℝ, time ∈ uIcc start finish →
      deriv (fun s => leveque04_burgersFiniteActionForwardPotential old origin width x s) time =
        -(leveque04_burgersFiniteActionEvolution old origin width x time) ^ 2 / 2 := by
    filter_upwards [hac.ae_differentiableAt, volume.ae_ne (0 : ℝ)] with time ht hne hmem
    have hpos : 0 < time := lt_of_le_of_ne (hnonneg time hmem) hne.symm
    exact (leveque04_burgersFiniteActionForwardPotential_temporal_hasDerivAt old origin width x time
      hwidth hpos (ht hmem)).deriv
  have heqRestricted : (fun time => deriv
      (fun s => leveque04_burgersFiniteActionForwardPotential old origin width x s) time) =ᵐ[volume.restrict (Ι start finish)]
      (fun time => -(leveque04_burgersFiniteActionEvolution old origin width x time) ^ 2 / 2) := by
    apply (ae_restrict_iff' measurableSet_uIoc).2
    exact heq.mono (fun _ h ht => h (uIoc_subset_uIcc ht))
  have hnegative := hac.intervalIntegrable_deriv.congr_ae heqRestricted
  have hnegativeIntegral :
      (∫ time in start..finish,
        -(leveque04_burgersFiniteActionEvolution old origin width x time) ^ 2 / 2) =
          leveque04_burgersFiniteActionForwardPotential old origin width x finish -
            leveque04_burgersFiniteActionForwardPotential old origin width x start := by
    calc
      _ = ∫ time in start..finish, deriv
          (fun s => leveque04_burgersFiniteActionForwardPotential old origin width x s) time :=
        (intervalIntegral.integral_congr_ae_restrict heqRestricted).symm
      _ = _ := hac.integral_deriv_eq_sub
  refine ⟨?_, ?_⟩
  · have hnegfun : (-(fun time : ℝ =>
        -(leveque04_burgersFiniteActionEvolution old origin width x time) ^ 2 / 2)) =
        (fun time => leveque04_burgersFiniteActionEvolution old origin width x time ^ 2 / 2) := by
      funext time
      simp only [Pi.neg_apply, neg_div, neg_neg]
    rw [← hnegfun]
    exact hnegative.neg
  · simp only [neg_div, intervalIntegral.integral_neg] at hnegativeIntegral
    linarith

/-- Actual Burgers conservation over every oriented finite forward rectangle,
including either or both temporal endpoints at zero and the prescribed datum. -/
theorem leveque04_burgersFiniteActionEvolution_forwardRectangle {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width left right start finish : ℝ)
    (hwidth : 0 ≤ width) (hstart : 0 ≤ start) (hfinish : 0 ≤ finish) :
    IntervalIntegrable
      (fun x => leveque04_burgersFiniteActionEvolution old origin width x start) volume left right ∧
    IntervalIntegrable
      (fun x => leveque04_burgersFiniteActionEvolution old origin width x finish) volume left right ∧
    IntervalIntegrable
      (fun t => leveque04_burgersFiniteActionEvolution old origin width left t ^ 2 / 2) volume start finish ∧
    IntervalIntegrable
      (fun t => leveque04_burgersFiniteActionEvolution old origin width right t ^ 2 / 2) volume start finish ∧
    (∫ x in left..right, leveque04_burgersFiniteActionEvolution old origin width x finish) -
      (∫ x in left..right, leveque04_burgersFiniteActionEvolution old origin width x start) =
        ∫ t in start..finish,
          leveque04_burgersFiniteActionEvolution old origin width left t ^ 2 / 2 -
            leveque04_burgersFiniteActionEvolution old origin width right t ^ 2 / 2 := by
  have hs := leveque04_burgersFiniteActionEvolution_spatial_integral
    old origin width start left right hwidth hstart
  have hf := leveque04_burgersFiniteActionEvolution_spatial_integral
    old origin width finish left right hwidth hfinish
  have hl := leveque04_burgersFiniteActionEvolution_temporal_flux_integral
    old origin width left start finish hwidth hstart hfinish
  have hr := leveque04_burgersFiniteActionEvolution_temporal_flux_integral
    old origin width right start finish hwidth hstart hfinish
  refine ⟨hs.1, hf.1, hl.1, hr.1, ?_⟩
  rw [intervalIntegral.integral_sub hl.1 hr.1, hs.2, hf.2, hl.2, hr.2]
  ring

/-- The actual initial field agrees with the existing supplied-ghost finite
reconstruction, rather than a value supplied by the positive-time formula. -/
theorem leveque04_burgersFiniteActionEvolution_initial_eq_finiteGridREA {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) :
    (fun _ : Fin 1 => leveque04_burgersFiniteActionEvolution old origin width x 0) =
      leveque04_burgersFiniteGridREA old origin width x 0 := by
  simp only [leveque04_burgersFiniteActionEvolution_initial]
  exact leveque04_burgersFiniteActionInitialData_eq_finiteGridREA old origin width x

/-- The same evolution retains the actual strict one-sided condition at all
positive times with one fixed constant. No entropy-equivalence theorem follows. -/
theorem leveque04_burgersFiniteActionEvolution_oleinikCondition {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (hwidth : 0 ≤ width) :
    ∃ E : ℝ, E = 2 ∧ 0 < E ∧
      ∀ x increment time : ℝ, 0 < increment → 0 < time →
        (leveque04_burgersFiniteActionEvolution old origin width (x + increment) time -
          leveque04_burgersFiniteActionEvolution old origin width x time) / increment < E / time := by
  obtain ⟨E, hE, hpos, hbound⟩ :=
    leveque04_burgersFiniteActionVelocity_oleinikCondition old origin width hwidth
  refine ⟨E, hE, hpos, ?_⟩
  intro x increment time hincrement htime
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width (x + increment) time htime,
    leveque04_burgersFiniteActionEvolution_positive old origin width x time htime]
  exact hbound x increment time hincrement htime

end NumStability
