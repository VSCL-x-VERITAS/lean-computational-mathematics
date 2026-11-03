/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPropagationBound

/-!
# Actual minimizing feet exclude foreign active jumps under full-step CFL

The physical S-cones of active labels put every foreign active boundary on its
original side of an original observation face, strictly before the end of a
Courant-at-most-one step. Ordering of ALL real minimizers then keeps every
actual minimizing foot on that side of the foreign initial label. Supplied
tails and equal-state material faces are unrestricted. This is genuine
minimizer locality, not yet the local Riemann flux identity.
-/

noncomputable section
open Set

namespace NumStability

theorem leveque04_burgersFiniteActionMinimizingFeet_bounds_of_labels {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    (leveque04_burgersFiniteActionLabelRight old origin width label time < x →
      ∀ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time, label < y) ∧
    (x < leveque04_burgersFiniteActionLabelLeft old origin width label time →
      ∀ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time, y < label) := by
  constructor
  · intro hx y hy
    let z := (leveque04_burgersFiniteActionLabelRight old origin width label time + x) / 2
    have hzx : z < x := by dsimp [z]; linarith
    have hzR : leveque04_burgersFiniteActionLabelRight old origin width label time < z := by
      dsimp [z]; linarith
    have hfoot := (leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width label time z hwidth htime).2.2.2 hzR
    exact hfoot.trans_le (leveque04_burgersFiniteActionMinimizingFeet_ordered
      old origin width time z x _ y hwidth htime hzx
      (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width z time) hy)
  · intro hx y hy
    have hfoot := (leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width label time x hwidth htime).1 hx
    exact ((leveque04_burgersFiniteActionFoot_isGreatest
      old origin width x time hwidth htime).2 hy).trans_lt hfoot

/-- Strict interior-time CFL separation holds for every admissible S,
including S=0 and a Courant-one terminal step. -/
theorem leveque04_burgersFiniteActionPropagationBound_foreignFace_feet {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ)
    (j k : Fin (N + 1)) (hwidth : 0 < width)
    (hjump : leveque04_burgersActionState old k.val ≠ leveque04_burgersActionState old (k.val + 1))
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) (htime : time ∈ Ioo (0 : ℝ) horizon) :
    (k.val < j.val → ∀ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersActionFace origin width j.val) time,
      leveque04_burgersActionFace origin width k.val < y) ∧
    (j.val < k.val → ∀ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersActionFace origin width j.val) time,
      y < leveque04_burgersActionFace origin width k.val) := by
  have hstrict : bound * time < width := by
    by_cases hb : 0 < bound
    · exact (mul_lt_mul_of_pos_left htime.2 hb).trans_le hCFL
    · have hz : bound = 0 := le_antisymm (le_of_not_gt hb) hprop.1
      simpa only [hz, zero_mul] using hwidth
  have hcones := leveque04_burgersFiniteActionPropagationBound_label_cones
    old origin width horizon bound time k hwidth hjump hprop ⟨htime.1.le, htime.2.le⟩
  constructor
  · intro hkj
    have hindex : (k.val : ℝ) + 1 ≤ (j.val : ℝ) := by exact_mod_cast (show k.val + 1 ≤ j.val by omega)
    have hdist : leveque04_burgersActionFace origin width k.val + width ≤
        leveque04_burgersActionFace origin width j.val := by
      have hm := mul_le_mul_of_nonneg_right hindex hwidth.le
      simp only [leveque04_burgersActionFace_eq]
      nlinarith
    have hright : leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width k.val) time <
      leveque04_burgersActionFace origin width j.val := by
      have hb := (abs_le.mp hcones.2).2
      linarith
    exact (leveque04_burgersFiniteActionMinimizingFeet_bounds_of_labels old origin width
      (leveque04_burgersActionFace origin width k.val)
      (leveque04_burgersActionFace origin width j.val) time hwidth.le htime.1).1 hright
  · intro hjk
    have hindex : (j.val : ℝ) + 1 ≤ (k.val : ℝ) := by exact_mod_cast (show j.val + 1 ≤ k.val by omega)
    have hdist : leveque04_burgersActionFace origin width j.val + width ≤
        leveque04_burgersActionFace origin width k.val := by
      have hm := mul_le_mul_of_nonneg_right hindex hwidth.le
      simp only [leveque04_burgersActionFace_eq]
      nlinarith
    have hleft : leveque04_burgersActionFace origin width j.val <
        leveque04_burgersFiniteActionLabelLeft old origin width
          (leveque04_burgersActionFace origin width k.val) time := by
      have hb := (abs_le.mp hcones.1).1
      linarith
    exact (leveque04_burgersFiniteActionMinimizingFeet_bounds_of_labels old origin width
      (leveque04_burgersActionFace origin width k.val)
      (leveque04_burgersActionFace origin width j.val) time hwidth.le htime.1).2 hleft

end NumStability
