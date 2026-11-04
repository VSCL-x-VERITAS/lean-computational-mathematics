/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionMinimizerRegularity
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionEvolution
import Mathlib.Order.ConditionallyCompleteLattice.Finset

/-!
# Actual one-sided spatial traces of the finite-action Burgers field

All true minimizing feet at a strictly earlier observation precede all those
at a later observation. Together with upper semicontinuity this identifies the
left foot limit as the least current minimizer and the right limit as the
existing greatest selected foot. The physical field therefore has both actual
one-sided traces at every positive time, with a downward jump at tied feet.
-/

noncomputable section
open Set Filter
open scoped Topology

namespace NumStability

theorem leveque04_burgersFiniteActionMinimizingFeet_ordered {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x₁ x₂ y₁ y₂ : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (hx : x₁ < x₂)
    (hy₁ : y₁ ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x₁ time)
    (hy₂ : y₂ ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x₂ time) : y₁ ≤ y₂ := by
  have h₁ := (leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
    old origin width x₁ time y₁ hwidth htime).mp hy₁
  have h₂ := (leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
    old origin width x₂ time y₂ hwidth htime).mp hy₂
  exact quadraticAction_minimizers_ordered (leveque04_burgersInitialPrimitive old origin width)
    time x₁ x₂ y₁ y₂ htime hx (h₁ y₂) (h₂ y₁)

theorem leveque04_burgersFiniteActionMinimizingFeet_sInf_isLeast {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    IsLeast (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)
      (sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)) := by
  have hf := leveque04_burgersFiniteActionMinimizingFeet_finite old origin width x time hwidth htime
  have hn : (leveque04_burgersFiniteActionMinimizingFeet old origin width x time).Nonempty :=
    ⟨_, leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time⟩
  exact ⟨hn.csInf_mem hf, fun _ hy => csInf_le hf.bddBelow hy⟩

theorem leveque04_burgersFiniteActionFoot_rightTrace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    Tendsto (fun r => leveque04_burgersFiniteActionFoot old origin width r time)
      (𝓝[>] x) (𝓝 (leveque04_burgersFiniteActionFoot old origin width x time)) := by
  apply tendsto_order.mpr
  constructor
  · intro a ha
    filter_upwards [self_mem_nhdsWithin] with r hr
    exact ha.trans_le (leveque04_burgersFiniteActionFoot_monotone
      old origin width time hwidth htime hr.le)
  · intro a ha
    have hcontain : leveque04_burgersFiniteActionMinimizingFeet old origin width x time ⊆ Iio a := by
      intro y hy
      exact ((leveque04_burgersFiniteActionFoot_isGreatest old origin width x time hwidth htime).2 hy).trans_lt ha
    have hnear := leveque04_burgersFiniteActionMinimizingFeet_eventually_subset
      old origin width x time hwidth htime (Iio a) isOpen_Iio hcontain
    have hline : Tendsto (fun r : ℝ => (r, time)) (𝓝[>] x) (𝓝 (x, time)) :=
      (continuous_id.prodMk continuous_const).continuousAt.mono_left nhdsWithin_le_nhds
    exact (hline.eventually hnear).mono (fun r hr =>
      hr (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width r time))

theorem leveque04_burgersFiniteActionFoot_leftTrace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    Tendsto (fun r => leveque04_burgersFiniteActionFoot old origin width r time)
      (𝓝[<] x) (𝓝 (sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time))) := by
  have hleast := leveque04_burgersFiniteActionMinimizingFeet_sInf_isLeast
    old origin width x time hwidth htime
  apply tendsto_order.mpr
  constructor
  · intro a ha
    have hcontain : leveque04_burgersFiniteActionMinimizingFeet old origin width x time ⊆ Ioi a := by
      intro y hy
      exact ha.trans_le (hleast.2 hy)
    have hnear := leveque04_burgersFiniteActionMinimizingFeet_eventually_subset
      old origin width x time hwidth htime (Ioi a) isOpen_Ioi hcontain
    have hline : Tendsto (fun r : ℝ => (r, time)) (𝓝[<] x) (𝓝 (x, time)) :=
      (continuous_id.prodMk continuous_const).continuousAt.mono_left nhdsWithin_le_nhds
    exact (hline.eventually hnear).mono (fun r hr =>
      hr (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width r time))
  · intro a ha
    filter_upwards [self_mem_nhdsWithin] with r hr
    exact (leveque04_burgersFiniteActionMinimizingFeet_ordered old origin width time r x
      _ _ hwidth htime hr
      (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width r time) hleast.1).trans_lt ha

theorem leveque04_burgersFiniteActionEvolution_rightTrace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    Tendsto (fun r => leveque04_burgersFiniteActionEvolution old origin width r time)
      (𝓝[>] x) (𝓝 (leveque04_burgersFiniteActionEvolution old origin width x time)) := by
  have hx : Tendsto (fun r : ℝ => r) (𝓝[>] x) (𝓝 x) :=
    tendsto_id'.mpr nhdsWithin_le_nhds
  have hf := leveque04_burgersFiniteActionFoot_rightTrace old origin width x time hwidth htime
  simpa only [leveque04_burgersFiniteActionEvolution_positive old origin width _ time htime,
    leveque04_burgersFiniteActionVelocity] using (hx.sub hf).div_const time

theorem leveque04_burgersFiniteActionEvolution_leftTrace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    Tendsto (fun r => leveque04_burgersFiniteActionEvolution old origin width r time)
      (𝓝[<] x) (𝓝 ((x - sInf
        (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)) / time)) := by
  have hx : Tendsto (fun r : ℝ => r) (𝓝[<] x) (𝓝 x) :=
    tendsto_id'.mpr nhdsWithin_le_nhds
  have hf := leveque04_burgersFiniteActionFoot_leftTrace old origin width x time hwidth htime
  simpa only [leveque04_burgersFiniteActionEvolution_positive old origin width _ time htime,
    leveque04_burgersFiniteActionVelocity] using (hx.sub hf).div_const time

/-- The actual left trace is at least the actual right representative. -/
theorem leveque04_burgersFiniteActionEvolution_leftTrace_ge_right {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    leveque04_burgersFiniteActionEvolution old origin width x time ≤
      (x - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)) / time := by
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width x time htime,
    leveque04_burgersFiniteActionVelocity]
  apply div_le_div_of_nonneg_right _ htime.le
  have hle := (leveque04_burgersFiniteActionMinimizingFeet_sInf_isLeast
    old origin width x time hwidth htime).2
    (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time)
  linarith

end NumStability
