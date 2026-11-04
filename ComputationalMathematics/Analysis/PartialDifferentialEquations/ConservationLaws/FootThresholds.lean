/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Archimedean
import Mathlib.Order.ConditionallyCompleteLattice.Basic
import Mathlib.Tactic.Linarith

/-!
# Ordered boundaries of a monotone minimizing-foot map

For a monotone real foot map within a finite distance of the identity, the
strict sublevel and superlevel sets determine two finite ordered boundaries.
Between them the actual foot equals the label. Different labels have ordered
boundaries even when a jump skips several labels. No continuity of the foot
map and no active-wave or propagation-speed hypothesis is assumed.
-/

noncomputable section
open Set

namespace NumStability

/-- The supremum of positions whose backtracked foot lies strictly left of the label. -/
def footThresholdLeft (foot : ℝ → ℝ) (label : ℝ) : ℝ :=
  sSup {x | foot x < label}

/-- The infimum of positions whose backtracked foot lies strictly right of the label. -/
def footThresholdRight (foot : ℝ → ℝ) (label : ℝ) : ℝ :=
  sInf {x | label < foot x}

private theorem sublevel_finite (foot : ℝ → ℝ) (label bound : ℝ)
    (hclose : ∀ x, |x - foot x| ≤ bound) :
    {x | foot x < label}.Nonempty ∧ BddAbove {x | foot x < label} := by
  constructor
  · refine ⟨label - bound - 1, ?_⟩
    have hb := (abs_le.mp (hclose (label - bound - 1))).1
    change foot (label - bound - 1) < label
    linarith
  · refine ⟨label + bound, ?_⟩
    intro x hx
    have hb := (abs_le.mp (hclose x)).2
    change foot x < label at hx
    linarith

private theorem superlevel_finite (foot : ℝ → ℝ) (label bound : ℝ)
    (hclose : ∀ x, |x - foot x| ≤ bound) :
    {x | label < foot x}.Nonempty ∧ BddBelow {x | label < foot x} := by
  constructor
  · refine ⟨label + bound + 1, ?_⟩
    have hb := (abs_le.mp (hclose (label + bound + 1))).2
    change label < foot (label + bound + 1)
    linarith
  · refine ⟨label - bound, ?_⟩
    intro x hx
    have hb := (abs_le.mp (hclose x)).1
    change label < foot x at hx
    linarith

theorem footThresholdLeft_bounds (foot : ℝ → ℝ) (label bound : ℝ)
    (hclose : ∀ x, |x - foot x| ≤ bound) :
    label - bound ≤ footThresholdLeft foot label ∧
      footThresholdLeft foot label ≤ label + bound := by
  obtain ⟨hne, hbdd⟩ := sublevel_finite foot label bound hclose
  constructor
  · by_contra hn
    have hlt : footThresholdLeft foot label < label - bound := lt_of_not_ge hn
    let x := (footThresholdLeft foot label + label - bound) / 2
    have hx : foot x < label := by
      have hb := (abs_le.mp (hclose x)).1
      dsimp [x] at hb
      linarith
    have hsup : x ≤ footThresholdLeft foot label := le_csSup hbdd hx
    dsimp [x] at hsup
    linarith
  · apply csSup_le hne
    intro x hx
    have hb := (abs_le.mp (hclose x)).2
    change foot x < label at hx
    linarith

theorem footThresholdRight_bounds (foot : ℝ → ℝ) (label bound : ℝ)
    (hclose : ∀ x, |x - foot x| ≤ bound) :
    label - bound ≤ footThresholdRight foot label ∧
      footThresholdRight foot label ≤ label + bound := by
  obtain ⟨hne, hbdd⟩ := superlevel_finite foot label bound hclose
  constructor
  · apply le_csInf hne
    intro x hx
    have hb := (abs_le.mp (hclose x)).1
    change label < foot x at hx
    linarith
  · by_contra hn
    have hlt : label + bound < footThresholdRight foot label := lt_of_not_ge hn
    let x := (footThresholdRight foot label + label + bound) / 2
    have hx : label < foot x := by
      have hb := (abs_le.mp (hclose x)).2
      dsimp [x] at hb
      linarith
    have hinf : footThresholdRight foot label ≤ x := csInf_le hbdd hx
    dsimp [x] at hinf
    linarith

theorem foot_lt_label_of_lt_leftThreshold (foot : ℝ → ℝ) (label bound x : ℝ)
    (hmono : Monotone foot) (hclose : ∀ y, |y - foot y| ≤ bound)
    (hx : x < footThresholdLeft foot label) : foot x < label := by
  obtain ⟨y, hy, hxy⟩ := exists_lt_of_lt_csSup (sublevel_finite foot label bound hclose).1 hx
  exact (hmono hxy.le).trans_lt hy

theorem label_le_foot_of_leftThreshold_lt (foot : ℝ → ℝ) (label bound x : ℝ)
    (hclose : ∀ y, |y - foot y| ≤ bound)
    (hx : footThresholdLeft foot label < x) : label ≤ foot x := by
  by_contra hn
  have hm : x ∈ {y | foot y < label} := lt_of_not_ge hn
  exact (not_le_of_gt hx) (le_csSup (sublevel_finite foot label bound hclose).2 hm)

theorem foot_le_label_of_lt_rightThreshold (foot : ℝ → ℝ) (label bound x : ℝ)
    (hclose : ∀ y, |y - foot y| ≤ bound)
    (hx : x < footThresholdRight foot label) : foot x ≤ label := by
  by_contra hn
  have hm : x ∈ {y | label < foot y} := lt_of_not_ge hn
  exact (not_le_of_gt hx) (csInf_le (superlevel_finite foot label bound hclose).2 hm)

theorem label_lt_foot_of_rightThreshold_lt (foot : ℝ → ℝ) (label bound x : ℝ)
    (hmono : Monotone foot) (hclose : ∀ y, |y - foot y| ≤ bound)
    (hx : footThresholdRight foot label < x) : label < foot x := by
  obtain ⟨y, hy, hyx⟩ := exists_lt_of_csInf_lt (superlevel_finite foot label bound hclose).1 hx
  exact hy.trans_le (hmono hyx.le)

theorem footThresholdLeft_le_right (foot : ℝ → ℝ) (label bound : ℝ)
    (hmono : Monotone foot) (hclose : ∀ x, |x - foot x| ≤ bound) :
    footThresholdLeft foot label ≤ footThresholdRight foot label := by
  by_contra hn
  have hlt : footThresholdRight foot label < footThresholdLeft foot label := lt_of_not_ge hn
  let x := (footThresholdLeft foot label + footThresholdRight foot label) / 2
  have hxleft : x < footThresholdLeft foot label := by dsimp [x]; linarith
  have hxright : footThresholdRight foot label < x := by dsimp [x]; linarith
  exact (not_lt_of_gt (foot_lt_label_of_lt_leftThreshold foot label bound x hmono hclose hxleft))
    (label_lt_foot_of_rightThreshold_lt foot label bound x hmono hclose hxright)

/-- A nonempty interval between the two boundaries is an actual foot plateau. -/
theorem foot_eq_label_between_thresholds (foot : ℝ → ℝ) (label bound x : ℝ)
    (hclose : ∀ y, |y - foot y| ≤ bound)
    (hxleft : footThresholdLeft foot label < x)
    (hxright : x < footThresholdRight foot label) : foot x = label :=
  le_antisymm (foot_le_label_of_lt_rightThreshold foot label bound x hclose hxright)
    (label_le_foot_of_leftThreshold_lt foot label bound x hclose hxleft)

/-- Several distinct labels can share one jump boundary; their order is retained. -/
theorem footThresholdRight_le_left_of_label_lt (foot : ℝ → ℝ) (left right bound : ℝ)
    (hclose : ∀ x, |x - foot x| ≤ bound) (hlabel : left < right) :
    footThresholdRight foot left ≤ footThresholdLeft foot right := by
  by_contra hn
  have hlt : footThresholdLeft foot right < footThresholdRight foot left := lt_of_not_ge hn
  let x := (footThresholdLeft foot right + footThresholdRight foot left) / 2
  have hxleft : footThresholdLeft foot right < x := by dsimp [x]; linarith
  have hxright : x < footThresholdRight foot left := by dsimp [x]; linarith
  have hfirst := label_le_foot_of_leftThreshold_lt foot right bound x hclose hxleft
  have hsecond := foot_le_label_of_lt_rightThreshold foot left bound x hclose hxright
  linarith

end NumStability
