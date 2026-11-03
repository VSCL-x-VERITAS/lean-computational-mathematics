/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionMinimizerRegularity
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionCornerStates
import Mathlib.Topology.Order.DenselyOrdered

/-!
# Genuine minimizing feet at actual label boundaries

Closed hitting sets and the actual threshold regions give minimizing feet on
both sides of a label at either boundary. A descending original corner cannot
itself minimize, by its opposite one-sided slope inequalities. Its two label
boundaries therefore coincide and possess distinct minimizing feet. This is
actual shock geometry, without a propagation-speed or Rankine-Hugoniot claim.
-/

noncomputable section
open Set

namespace NumStability

private theorem minimizingFeet_bracket_of_regions {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time boundary : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hleft : ∀ x < boundary, leveque04_burgersFiniteActionFoot old origin width x time ≤ label)
    (hright : ∀ x, boundary < x → label ≤ leveque04_burgersFiniteActionFoot old origin width x time) :
    (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width boundary time, y ≤ label) ∧
      (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width boundary time, label ≤ y) := by
  constructor
  · have hc := leveque04_burgersFiniteActionMinimizingFeet_isClosed_hit
      old origin width time hwidth htime (Iic label) isClosed_Iic
    have hsub : Iio boundary ⊆ {x : ℝ | ∃ y ∈
        leveque04_burgersFiniteActionMinimizingFeet old origin width x time, y ∈ Iic label} := by
      intro x hx
      exact ⟨_, leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time,
        hleft x hx⟩
    exact closure_minimal hsub hc (by rw [closure_Iio]; exact le_refl boundary)
  · have hc := leveque04_burgersFiniteActionMinimizingFeet_isClosed_hit
      old origin width time hwidth htime (Ici label) isClosed_Ici
    have hsub : Ioi boundary ⊆ {x : ℝ | ∃ y ∈
        leveque04_burgersFiniteActionMinimizingFeet old origin width x time, y ∈ Ici label} := by
      intro x hx
      exact ⟨_, leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time,
        hright x hx⟩
    exact closure_minimal hsub hc (by rw [closure_Ioi]; exact le_refl boundary)

theorem leveque04_burgersFiniteActionLabelLeft_minimizers_bracket {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelLeft old origin width label time) time, y ≤ label) ∧
      (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelLeft old origin width label time) time, label ≤ y) := by
  apply minimizingFeet_bracket_of_regions old origin width label time _ hwidth htime
  · intro x hx
    exact ((leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width label time x hwidth htime).1 hx).le
  · intro x hx
    exact (leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width label time x hwidth htime).2.1 hx

theorem leveque04_burgersFiniteActionLabelRight_minimizers_bracket {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelRight old origin width label time) time, y ≤ label) ∧
      (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelRight old origin width label time) time, label ≤ y) := by
  apply minimizingFeet_bracket_of_regions old origin width label time _ hwidth htime
  · intro x hx
    exact (leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width label time x hwidth htime).2.2.1 hx
  · intro x hx
    exact ((leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width label time x hwidth htime).2.2.2 hx).le

theorem leveque04_burgersFiniteAction_descendingFace_not_minimizing {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hdescending : leveque04_burgersActionState old (j.val + 1) < leveque04_burgersActionState old j.val) :
    leveque04_burgersActionFace origin width j.val ∉
      leveque04_burgersFiniteActionMinimizingFeet old origin width x time := by
  intro hmin
  have hb := leveque04_burgersFiniteAction_minimizingFace_state_bounds
    old origin width x time j hwidth htime hmin
  exact (not_le_of_gt hdescending) (hb.1.trans hb.2)

/-- A descending original jump always has one coincident boundary with
strictly bracketing, distinct actual minimizing feet, even after interactions. -/
theorem leveque04_burgersFiniteAction_descendingFace_shock_minimizers {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hdescending : leveque04_burgersActionState old (j.val + 1) < leveque04_burgersActionState old j.val) :
    leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time ∧
    ∃ y z, y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelLeft old origin width
          (leveque04_burgersActionFace origin width j.val) time) time ∧
      z ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelLeft old origin width
          (leveque04_burgersActionFace origin width j.val) time) time ∧
      y < leveque04_burgersActionFace origin width j.val ∧
      leveque04_burgersActionFace origin width j.val < z := by
  let a := leveque04_burgersActionFace origin width j.val
  let L := leveque04_burgersFiniteActionLabelLeft old origin width a time
  let R := leveque04_burgersFiniteActionLabelRight old origin width a time
  have hn (x : ℝ) : a ∉ leveque04_burgersFiniteActionMinimizingFeet old origin width x time :=
    leveque04_burgersFiniteAction_descendingFace_not_minimizing old origin width x time j
      hwidth htime hdescending
  have hLR : L = R := by
    apply le_antisymm (leveque04_burgersFiniteActionLabelBoundaries_ordered
      old origin width a time hwidth.le htime)
    by_contra hnot
    have hlt : L < R := lt_of_not_ge hnot
    have hp := leveque04_burgersFiniteActionEvolution_label_plateau
      old origin width a time ((L + R) / 2) hwidth.le htime (by linarith) (by linarith)
    have hm := leveque04_burgersFiniteActionFoot_mem_minimizingFeet
      old origin width ((L + R) / 2) time
    rw [hp.1] at hm
    exact hn _ hm
  obtain ⟨⟨y, hy, hya⟩, ⟨z, hz, haz⟩⟩ :=
    leveque04_burgersFiniteActionLabelLeft_minimizers_bracket old origin width a time hwidth.le htime
  refine ⟨hLR, y, z, hy, hz, lt_of_le_of_ne hya ?_, lt_of_le_of_ne haz ?_⟩
  · intro heq
    subst y
    exact hn L hy
  · intro heq
    rw [← heq] at hz
    exact hn L hz

end NumStability
