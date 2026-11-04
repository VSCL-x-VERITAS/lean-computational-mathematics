/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionLabelBoundaries
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.LocalExtr.Basic

/-!
# Open foot plateaus originate at actual nonzero initial jumps

At any label where the actual initial primitive is differentiable, Fermat's
theorem permits that label to minimize only at one observation at a fixed
positive time. Its two label boundaries therefore coincide. A face with zero
jump contributes the zero hinge, so this also covers equal-state interfaces.
Every nonempty open plateau must consequently originate at one of the finite
nonzero initial jumps. No full wave genealogy or speed-bound theorem is claimed.
-/

noncomputable section
open Set Filter
open scoped Topology BigOperators

namespace NumStability

theorem leveque04_burgersInitialPrimitive_hasDerivAt_of_no_jump {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label : ℝ)
    (hzero : ∀ j : Fin (N + 1), label = leveque04_burgersActionFace origin width j.val →
      leveque04_burgersActionState old (j.val + 1) = leveque04_burgersActionState old j.val) :
    HasDerivAt (leveque04_burgersInitialPrimitive old origin width)
      (leveque04_burgersFiniteActionInitialData old origin width label) label := by
  have hterm (j : ℕ) (hj : j ∈ Finset.range (N + 1)) :
      HasDerivAt (fun y : ℝ =>
        (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) *
          max (y - leveque04_burgersActionFace origin width j) 0)
        ((leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) *
          (if label < leveque04_burgersActionFace origin width j then 0 else 1)) label := by
    by_cases heq : label = leveque04_burgersActionFace origin width j
    · have hz : leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j = 0 :=
        sub_eq_zero.mpr (hzero ⟨j, Finset.mem_range.mp hj⟩ heq)
      simpa only [hz, zero_mul] using hasDerivAt_const label (0 : ℝ)
    · by_cases hlt : label < leveque04_burgersActionFace origin width j
      · rw [if_pos hlt, mul_zero]
        apply (hasDerivAt_const label (0 : ℝ)).congr_of_eventuallyEq
        filter_upwards [eventually_lt_nhds hlt] with y hy
        rw [max_eq_right (sub_nonpos.mpr hy.le), mul_zero]
      · have hgt : leveque04_burgersActionFace origin width j < label :=
          lt_of_le_of_ne (le_of_not_gt hlt) (Ne.symm heq)
        rw [if_neg hlt, mul_one]
        have hd := ((hasDerivAt_id label).sub_const
          (leveque04_burgersActionFace origin width j)).const_mul
            (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j)
        change HasDerivAt (fun y : ℝ =>
          (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) *
            (y - leveque04_burgersActionFace origin width j))
          ((leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) * 1) label at hd
        have hd' : HasDerivAt (fun y : ℝ =>
            (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) *
              (y - leveque04_burgersActionFace origin width j))
            (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) label := by
          simpa only [mul_one] using hd
        apply hd'.congr_of_eventuallyEq
        filter_upwards [eventually_gt_nhds hgt] with y hy
        rw [max_eq_left (sub_nonneg.mpr hy.le)]
  have hsum := HasDerivAt.sum hterm
  have hbase := ((hasDerivAt_id label).sub_const origin).const_mul (leveque04_burgersActionState old 0)
  change HasDerivAt (fun y : ℝ => leveque04_burgersActionState old 0 * (y - origin))
    (leveque04_burgersActionState old 0 * 1) label at hbase
  have hfun : ((fun y : ℝ => leveque04_burgersActionState old 0 * (y - origin)) +
      ∑ j ∈ Finset.range (N + 1), fun y : ℝ =>
        (leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j) *
          max (y - leveque04_burgersActionFace origin width j) 0) =
      leveque04_burgersInitialPrimitive old origin width := by
    funext y
    simp only [Pi.add_apply, Finset.sum_apply, leveque04_burgersInitialPrimitive]
  have hproof := hbase.add hsum
  rw [hfun] at hproof
  simpa only [leveque04_burgersFiniteActionInitialData, mul_one] using hproof

/-- Actual stationarity at a differentiable minimizing label fixes its
observation. This is derived from the global action minimum itself. -/
theorem leveque04_burgersFiniteAction_minimizingLabel_observation_eq {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time x slope : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hmin : label ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time)
    (hslope : HasDerivAt (leveque04_burgersInitialPrimitive old origin width) slope label) :
    x = label + slope * time := by
  have ha : HasDerivAt (leveque04_burgersAction old origin width x time)
      (slope - (x - label) / time) label := by
    convert hslope.add
      ((((hasDerivAt_const label x).sub (hasDerivAt_id label)).pow 2).div_const (2 * time)) using 1
    simp only [Pi.sub_apply, id_eq]
    field_simp [htime.ne']
    ring
  have hlocal : IsLocalMin (leveque04_burgersAction old origin width x time) label :=
    Eventually.of_forall ((leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
      old origin width x time label hwidth htime).mp hmin)
  have hz := hlocal.hasDerivAt_eq_zero ha
  have hd : slope = (x - label) / time := by linarith
  have hm := (eq_div_iff htime.ne').mp hd
  linarith

theorem leveque04_burgersFiniteActionLabelBoundaries_eq_of_hasDerivAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time slope : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hslope : HasDerivAt (leveque04_burgersInitialPrimitive old origin width) slope label) :
    leveque04_burgersFiniteActionLabelLeft old origin width label time =
      leveque04_burgersFiniteActionLabelRight old origin width label time := by
  let L := leveque04_burgersFiniteActionLabelLeft old origin width label time
  let R := leveque04_burgersFiniteActionLabelRight old origin width label time
  have horder : L ≤ R := leveque04_burgersFiniteActionLabelBoundaries_ordered old origin width label time hwidth htime
  by_contra hne
  have hlt : L < R := lt_of_le_of_ne horder hne
  let x₁ := (2 * L + R) / 3
  let x₂ := (L + 2 * R) / 3
  have h₁ := (leveque04_burgersFiniteActionEvolution_label_plateau old origin width label time x₁ hwidth htime
    (by dsimp [x₁]; linarith) (by dsimp [x₁]; linarith)).1
  have h₂ := (leveque04_burgersFiniteActionEvolution_label_plateau old origin width label time x₂ hwidth htime
    (by dsimp [x₂]; linarith) (by dsimp [x₂]; linarith)).1
  have hm₁ : label ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x₁ time := by
    simpa only [h₁] using leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x₁ time
  have hm₂ : label ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x₂ time := by
    simpa only [h₂] using leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x₂ time
  have ho₁ := leveque04_burgersFiniteAction_minimizingLabel_observation_eq old origin width label time x₁ slope
    hwidth htime hm₁ hslope
  have ho₂ := leveque04_burgersFiniteAction_minimizingLabel_observation_eq old origin width label time x₂ slope
    hwidth htime hm₂ hslope
  dsimp [x₁, x₂] at ho₁ ho₂
  linarith

theorem leveque04_burgersFiniteActionLabelBoundaries_eq_of_no_jump {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hzero : ∀ j : Fin (N + 1), label = leveque04_burgersActionFace origin width j.val →
      leveque04_burgersActionState old (j.val + 1) = leveque04_burgersActionState old j.val) :
    leveque04_burgersFiniteActionLabelLeft old origin width label time =
      leveque04_burgersFiniteActionLabelRight old origin width label time :=
  leveque04_burgersFiniteActionLabelBoundaries_eq_of_hasDerivAt old origin width label time
    (leveque04_burgersFiniteActionInitialData old origin width label) hwidth htime
    (leveque04_burgersInitialPrimitive_hasDerivAt_of_no_jump old origin width label hzero)

/-- A nonempty open plateau must originate at an actual nonzero initial jump,
not at an arbitrary material interface inserted into a constant region. -/
theorem leveque04_burgersFiniteActionLabelPlateau_exists_initial_jump {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hopen : leveque04_burgersFiniteActionLabelLeft old origin width label time <
      leveque04_burgersFiniteActionLabelRight old origin width label time) :
    ∃ j : Fin (N + 1), label = leveque04_burgersActionFace origin width j.val ∧
      leveque04_burgersActionState old (j.val + 1) ≠ leveque04_burgersActionState old j.val := by
  by_contra hn
  have hzero (j : Fin (N + 1)) (hj : label = leveque04_burgersActionFace origin width j.val) :
      leveque04_burgersActionState old (j.val + 1) = leveque04_burgersActionState old j.val := by
    by_contra hne
    exact hn ⟨j, hj, hne⟩
  have heq := leveque04_burgersFiniteActionLabelBoundaries_eq_of_no_jump
    old origin width label time hwidth htime hzero
  rw [heq] at hopen
  exact lt_irrefl _ hopen

end NumStability
