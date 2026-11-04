/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionMinimizers
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FootThresholds

/-!
# Actual label boundaries of the finite Burgers minimizing-foot map

Strict sublevel/superlevel boundaries of the SAME selected global minimizing
foot are anchored at the label initially. At positive times they are ordered,
obey the analytic K cone bound and retain the order of distinct labels. On
every open interval between them the actual velocity is (x-label)/time.

These are actual label boundaries, not yet a definition of encountered wave
speed. Labels inside an initial constant region, including faces with equal
neighboring states, can trace material characteristics rather than active
waves. No bound S is imposed on all labels, and no CFL identity is asserted.
-/

noncomputable section
open Set Filter
open scoped Topology

namespace NumStability

/-- The left boundary associated with a backtracked initial label. -/
def leveque04_burgersFiniteActionLabelLeft {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ) : ℝ :=
  if time ≤ 0 then label else
    footThresholdLeft (fun x => leveque04_burgersFiniteActionFoot old origin width x time) label

/-- The right boundary associated with a backtracked initial label. -/
def leveque04_burgersFiniteActionLabelRight {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ) : ℝ :=
  if time ≤ 0 then label else
    footThresholdRight (fun x => leveque04_burgersFiniteActionFoot old origin width x time) label

@[simp]
theorem leveque04_burgersFiniteActionLabelBoundaries_initial {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label : ℝ) :
    leveque04_burgersFiniteActionLabelLeft old origin width label 0 = label ∧
      leveque04_burgersFiniteActionLabelRight old origin width label 0 = label := by
  simp only [leveque04_burgersFiniteActionLabelLeft, leveque04_burgersFiniteActionLabelRight,
    le_refl, if_true, and_self]

theorem leveque04_burgersFiniteActionLabelBoundaries_bounds {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    leveque04_burgersFiniteActionLabelLeft old origin width label time ∈
        Icc (label - leveque04_burgersPrimitiveBound old * time)
          (label + leveque04_burgersPrimitiveBound old * time) ∧
      leveque04_burgersFiniteActionLabelRight old origin width label time ∈
        Icc (label - leveque04_burgersPrimitiveBound old * time)
          (label + leveque04_burgersPrimitiveBound old * time) := by
  have hclose (x : ℝ) := leveque04_burgersFiniteActionFoot_displacement_le old origin width x time hwidth htime
  exact ⟨by simpa only [leveque04_burgersFiniteActionLabelLeft, if_neg (not_le_of_gt htime)] using
      footThresholdLeft_bounds _ label _ hclose,
    by simpa only [leveque04_burgersFiniteActionLabelRight, if_neg (not_le_of_gt htime)] using
      footThresholdRight_bounds _ label _ hclose⟩

theorem leveque04_burgersFiniteActionLabelBoundaries_ordered {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    leveque04_burgersFiniteActionLabelLeft old origin width label time ≤
      leveque04_burgersFiniteActionLabelRight old origin width label time := by
  simpa only [leveque04_burgersFiniteActionLabelLeft, leveque04_burgersFiniteActionLabelRight,
    if_neg (not_le_of_gt htime)] using footThresholdLeft_le_right _ label
      (leveque04_burgersPrimitiveBound old * time)
      (leveque04_burgersFiniteActionFoot_monotone old origin width time hwidth htime)
      (fun x => leveque04_burgersFiniteActionFoot_displacement_le old origin width x time hwidth htime)

theorem leveque04_burgersFiniteActionLabelBoundaries_noninterleaving {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width left right time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (hlabel : left < right) :
    leveque04_burgersFiniteActionLabelRight old origin width left time ≤
      leveque04_burgersFiniteActionLabelLeft old origin width right time := by
  simpa only [leveque04_burgersFiniteActionLabelLeft, leveque04_burgersFiniteActionLabelRight,
    if_neg (not_le_of_gt htime)] using footThresholdRight_le_left_of_label_lt _ left right
      (leveque04_burgersPrimitiveBound old * time)
      (fun x => leveque04_burgersFiniteActionFoot_displacement_le old origin width x time hwidth htime) hlabel

theorem leveque04_burgersFiniteActionLabelBoundaries_regions {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time x : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    (x < leveque04_burgersFiniteActionLabelLeft old origin width label time →
      leveque04_burgersFiniteActionFoot old origin width x time < label) ∧
    (leveque04_burgersFiniteActionLabelLeft old origin width label time < x →
      label ≤ leveque04_burgersFiniteActionFoot old origin width x time) ∧
    (x < leveque04_burgersFiniteActionLabelRight old origin width label time →
      leveque04_burgersFiniteActionFoot old origin width x time ≤ label) ∧
    (leveque04_burgersFiniteActionLabelRight old origin width label time < x →
      label < leveque04_burgersFiniteActionFoot old origin width x time) := by
  have hclose (y : ℝ) := leveque04_burgersFiniteActionFoot_displacement_le old origin width y time hwidth htime
  have hmono := leveque04_burgersFiniteActionFoot_monotone old origin width time hwidth htime
  simp only [leveque04_burgersFiniteActionLabelLeft, leveque04_burgersFiniteActionLabelRight,
    if_neg (not_le_of_gt htime)]
  exact ⟨foot_lt_label_of_lt_leftThreshold _ label _ x hmono hclose,
    label_le_foot_of_leftThreshold_lt _ label _ x hclose,
    foot_le_label_of_lt_rightThreshold _ label _ x hclose,
    label_lt_foot_of_rightThreshold_lt _ label _ x hmono hclose⟩

/-- A genuine open foot plateau has the centered characteristic formula in
the SAME physical evolution, with the original label and unrestarted time. -/
theorem leveque04_burgersFiniteActionEvolution_label_plateau {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time x : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hxleft : leveque04_burgersFiniteActionLabelLeft old origin width label time < x)
    (hxright : x < leveque04_burgersFiniteActionLabelRight old origin width label time) :
    leveque04_burgersFiniteActionFoot old origin width x time = label ∧
      leveque04_burgersFiniteActionEvolution old origin width x time = (x - label) / time := by
  have hregions := leveque04_burgersFiniteActionLabelBoundaries_regions old origin width label time x hwidth htime
  have heq := le_antisymm (hregions.2.2.1 hxright) (hregions.2.1 hxleft)
  refine ⟨heq, ?_⟩
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width x time htime,
    leveque04_burgersFiniteActionVelocity, heq]

private theorem curve_initialTrace (curve : ℝ → ℝ) (label K : ℝ)
    (hbound : ∀ time, 0 < time → curve time ∈ Icc (label - K * time) (label + K * time)) :
    Tendsto curve (𝓝[>] (0 : ℝ)) (𝓝 label) := by
  apply tendsto_iff_dist_tendsto_zero.mpr
  apply squeeze_zero' (g := fun time => K * time) (Eventually.of_forall (fun _ => dist_nonneg))
  · filter_upwards [self_mem_nhdsWithin] with time ht
    rw [Real.dist_eq]
    apply abs_le.mpr
    have hb := hbound time ht
    constructor <;> linarith [hb.1, hb.2]
  · simpa only [mul_zero] using tendsto_const_nhds.mul
      (tendsto_id'.mpr nhdsWithin_le_nhds :
        Tendsto (fun time : ℝ => time) (𝓝[>] (0 : ℝ)) (𝓝 (0 : ℝ)))

theorem leveque04_burgersFiniteActionLabelBoundaries_initialTrace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label : ℝ) (hwidth : 0 ≤ width) :
    Tendsto (leveque04_burgersFiniteActionLabelLeft old origin width label) (𝓝[>] (0 : ℝ)) (𝓝 label) ∧
      Tendsto (leveque04_burgersFiniteActionLabelRight old origin width label) (𝓝[>] (0 : ℝ)) (𝓝 label) := by
  exact ⟨curve_initialTrace _ label (leveque04_burgersPrimitiveBound old) (fun time ht =>
      (leveque04_burgersFiniteActionLabelBoundaries_bounds old origin width label time hwidth ht).1),
    curve_initialTrace _ label (leveque04_burgersPrimitiveBound old) (fun time ht =>
      (leveque04_burgersFiniteActionLabelBoundaries_bounds old origin width label time hwidth ht).2)⟩

end NumStability
