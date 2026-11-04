/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionCellRegions

/-!
# Actual initial-corner states and ascending origins of open fan regions

An original face belongs to both neighboring affine segments. If that face
is a true action-minimizing foot, both actual projections fix it; their clamp
conditions give q_left <= (x-face)/time <= q_right. Thus every nonempty open
foot plateau originates at an ascending initial jump, and the SAME physical
field has its original fan state bounds there. No wave-speed certificate or
Riemann-solver correctness assertion is an assumption.
-/

noncomputable section
open Set

namespace NumStability

theorem leveque04_burgersActionFace_strictMono (origin width : ℝ) (hwidth : 0 < width) :
    StrictMono (leveque04_burgersActionFace origin width) := by
  intro i j hij
  simp only [leveque04_burgersActionFace_eq]
  have hc : (i : ℝ) < (j : ℝ) := by exact_mod_cast hij
  simpa only [add_comm] using add_lt_add_left (mul_lt_mul_of_pos_right hc hwidth) origin

theorem leveque04_burgersActionFace_mem_adjacent_segments {N : ℕ}
    (origin width : ℝ) (j : Fin (N + 1)) (hwidth : 0 < width) :
    leveque04_burgersActionSegment origin width (⟨j.val, by omega⟩ : Fin (N + 2))
        (leveque04_burgersActionFace origin width j.val) ∧
      leveque04_burgersActionSegment origin width (⟨j.val + 1, by omega⟩ : Fin (N + 2))
        (leveque04_burgersActionFace origin width j.val) := by
  have hm := (leveque04_burgersActionFace_strictMono origin width hwidth).monotone
  constructor
  · intro i
    constructor
    · intro hi; exact hm (Nat.le_of_lt hi)
    · intro hi; exact hm hi
  · intro i
    constructor
    · intro hi; exact hm (show i.val ≤ j.val by change i.val < j.val + 1 at hi; omega)
    · intro hi; exact hm (show j.val ≤ i.val by change j.val + 1 ≤ i.val at hi; omega)

private theorem upper_of_clamp_eq_upper (a b z : ℝ) (hab : a < b)
    (heq : b = max a (min b z)) : b ≤ z := by
  by_contra hn
  have hz : z < b := lt_of_not_ge hn
  rw [min_eq_right hz.le] at heq
  have hm : max a z < b := max_lt_iff.mpr ⟨hab, hz⟩
  linarith

private theorem lower_of_clamp_eq_lower (a b z : ℝ) (hab : a < b)
    (heq : a = max a (min b z)) : z ≤ a := by
  by_contra hn
  have hz : a < z := lt_of_not_ge hn
  have hm : a < min b z := lt_min hab hz
  have hh := hm.trans_le (le_max_right a (min b z))
  linarith

theorem leveque04_burgersFiniteAction_minimizingFace_state_bounds {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hmin : leveque04_burgersActionFace origin width j.val ∈
      leveque04_burgersFiniteActionMinimizingFeet old origin width x time) :
    leveque04_burgersActionState old j.val ≤
        (x - leveque04_burgersActionFace origin width j.val) / time ∧
      (x - leveque04_burgersActionFace origin width j.val) / time ≤
        leveque04_burgersActionState old (j.val + 1) := by
  let kL : Fin (N + 2) := ⟨j.val, by omega⟩
  let kR : Fin (N + 2) := ⟨j.val + 1, by omega⟩
  have hsegments := leveque04_burgersActionFace_mem_adjacent_segments origin width j hwidth
  have hL := leveque04_burgersFiniteActionMinimizingFeet_eq_clampedFoot_of_segment
    old origin width x time _ kL hwidth.le htime hmin hsegments.1
  have hR := leveque04_burgersFiniteActionMinimizingFeet_eq_clampedFoot_of_segment
    old origin width x time _ kR hwidth.le htime hmin hsegments.2
  have hstateL : old kL = leveque04_burgersActionState old j.val :=
    (leveque04_burgersActionState_eq old kL).symm
  have hstateR : old kR = leveque04_burgersActionState old (j.val + 1) :=
    (leveque04_burgersActionState_eq old kR).symm
  have hleft : old kL * time ≤ x - leveque04_burgersActionFace origin width j.val := by
    by_cases hj0 : j.val = 0
    · have hL' : origin = min (x - old kL * time) origin := by
        simpa only [leveque04_burgersClampedFoot, kL, hj0, if_pos rfl,
          leveque04_burgersActionFace_eq, Nat.cast_zero, zero_mul, add_zero] using hL
      have h := min_le_left (x - old kL * time) origin
      rw [← hL'] at h
      simp only [leveque04_burgersActionFace_eq, hj0, Nat.cast_zero, zero_mul, add_zero]
      linarith
    · have hL' : leveque04_burgersActionFace origin width j.val =
          max (leveque04_burgersActionFace origin width (j.val - 1))
            (min (leveque04_burgersActionFace origin width j.val) (x - old kL * time)) := by
        simpa only [leveque04_burgersClampedFoot, kL, if_neg hj0,
          if_neg (show j.val ≠ N + 1 by omega), leveque04_burgersActionFace_eq] using hL
      have hb := upper_of_clamp_eq_upper _ _ _
        (leveque04_burgersActionFace_strictMono origin width hwidth
          (show j.val - 1 < j.val by omega)) hL'
      linarith
  have hright : x - leveque04_burgersActionFace origin width j.val ≤ old kR * time := by
    by_cases hjN : j.val = N
    · have hR' : leveque04_burgersActionFace origin width j.val =
          max (x - old kR * time) (leveque04_burgersActionFace origin width j.val) := by
        simpa only [leveque04_burgersClampedFoot, kR, hjN,
          if_neg (show N + 1 ≠ 0 by omega), if_pos rfl, leveque04_burgersActionFace_eq] using hR
      have h := le_max_left (x - old kR * time) (leveque04_burgersActionFace origin width j.val)
      rw [← hR'] at h
      linarith
    · have hR' : leveque04_burgersActionFace origin width j.val =
          max (leveque04_burgersActionFace origin width j.val)
            (min (leveque04_burgersActionFace origin width (j.val + 1)) (x - old kR * time)) := by
        simpa only [leveque04_burgersClampedFoot, kR,
          if_neg (show j.val + 1 ≠ 0 by omega), if_neg (show j.val + 1 ≠ N + 1 by omega),
          Nat.add_sub_cancel, leveque04_burgersActionFace_eq] using hR
      have hb := lower_of_clamp_eq_lower _ _ _
        (leveque04_burgersActionFace_strictMono origin width hwidth (Nat.lt_succ_self j.val)) hR'
      linarith
  rw [← hstateL, ← hstateR]
  exact ⟨(le_div_iff₀ htime).2 hleft, (div_le_iff₀ htime).2 hright⟩

theorem leveque04_burgersFiniteActionEvolution_face_plateau_bounds {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hxleft : leveque04_burgersFiniteActionLabelLeft old origin width
      (leveque04_burgersActionFace origin width j.val) time < x)
    (hxright : x < leveque04_burgersFiniteActionLabelRight old origin width
      (leveque04_burgersActionFace origin width j.val) time) :
    leveque04_burgersActionState old j.val ≤ leveque04_burgersFiniteActionEvolution old origin width x time ∧
      leveque04_burgersFiniteActionEvolution old origin width x time ≤ leveque04_burgersActionState old (j.val + 1) := by
  have hp := leveque04_burgersFiniteActionEvolution_label_plateau old origin width
    (leveque04_burgersActionFace origin width j.val) time x hwidth.le htime hxleft hxright
  have hmem := leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time
  rw [hp.1] at hmem
  rw [hp.2]
  exact leveque04_burgersFiniteAction_minimizingFace_state_bounds old origin width x time j hwidth htime hmem

theorem leveque04_burgersFiniteActionLabelPlateau_face_ascending {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hopen : leveque04_burgersFiniteActionLabelLeft old origin width
      (leveque04_burgersActionFace origin width j.val) time <
        leveque04_burgersFiniteActionLabelRight old origin width
          (leveque04_burgersActionFace origin width j.val) time) :
    leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1) := by
  let a := leveque04_burgersActionFace origin width j.val
  let L := leveque04_burgersFiniteActionLabelLeft old origin width a time
  let R := leveque04_burgersFiniteActionLabelRight old origin width a time
  let x₁ := (2 * L + R) / 3
  let x₂ := (L + 2 * R) / 3
  have h₁ := leveque04_burgersFiniteActionEvolution_label_plateau old origin width a time x₁ hwidth.le htime
    (by dsimp [x₁]; linarith) (by dsimp [x₁]; linarith)
  have h₂ := leveque04_burgersFiniteActionEvolution_label_plateau old origin width a time x₂ hwidth.le htime
    (by dsimp [x₂]; linarith) (by dsimp [x₂]; linarith)
  have hm₁ := leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x₁ time
  have hm₂ := leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x₂ time
  rw [h₁.1] at hm₁
  rw [h₂.1] at hm₂
  have hb₁ := leveque04_burgersFiniteAction_minimizingFace_state_bounds old origin width x₁ time j hwidth htime hm₁
  have hb₂ := leveque04_burgersFiniteAction_minimizingFace_state_bounds old origin width x₂ time j hwidth htime hm₂
  have hx : x₁ < x₂ := by dsimp [x₁, x₂]; linarith
  have hu : (x₁ - a) / time < (x₂ - a) / time :=
    div_lt_div_of_pos_right (sub_lt_sub_right hx a) htime
  exact hb₁.1.trans_lt (hu.trans_le hb₂.2)

/-- Every nonempty open fan region comes from an ascending original jump,
including when other original fans have already been truncated by interactions. -/
theorem leveque04_burgersFiniteActionLabelPlateau_exists_ascending_jump {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label time : ℝ)
    (hwidth : 0 < width) (htime : 0 < time)
    (hopen : leveque04_burgersFiniteActionLabelLeft old origin width label time <
      leveque04_burgersFiniteActionLabelRight old origin width label time) :
    ∃ j : Fin (N + 1), label = leveque04_burgersActionFace origin width j.val ∧
      leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1) := by
  obtain ⟨j, hlabel, _⟩ := leveque04_burgersFiniteActionLabelPlateau_exists_initial_jump
    old origin width label time hwidth.le htime hopen
  refine ⟨j, hlabel, leveque04_burgersFiniteActionLabelPlateau_face_ascending old origin width time j hwidth htime ?_⟩
  simpa only [hlabel] using hopen

end NumStability
