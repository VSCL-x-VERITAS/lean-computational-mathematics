/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPlateauOrigins
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionStrictMidpoint

/-!
# Actual constant-cell regions of the finite Burgers evolution

A true minimizer in a specified original affine segment equals that segment's
actual clamped candidate. An interior foot therefore gives the original
supplied constant state, with separate unbounded exterior-tail statements.
These are identities of the SAME constructed evolution, with no assumed
solution, locality, wave-speed or Godunov certificate.
-/

noncomputable section
open Set

namespace NumStability

private theorem face_mono (origin width : ℝ) (hwidth : 0 ≤ width)
    {i j : ℕ} (hij : i ≤ j) :
    leveque04_burgersActionFace origin width i ≤ leveque04_burgersActionFace origin width j := by
  simp only [leveque04_burgersActionFace_eq]
  have hc : (i : ℝ) ≤ (j : ℝ) := by exact_mod_cast hij
  simpa only [add_comm] using add_le_add_left (mul_le_mul_of_nonneg_right hc hwidth) origin

/-- The specified segment is retained, rather than replaced by an arbitrary
candidate index obtained from the cover. Shared faces may use either segment. -/
theorem leveque04_burgersFiniteActionMinimizingFeet_eq_clampedFoot_of_segment {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y : ℝ) (k : Fin (N + 2))
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hy : y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time)
    (hsegment : leveque04_burgersActionSegment origin width k y) :
    y = leveque04_burgersClampedFoot old origin width x time k := by
  let c := leveque04_burgersClampedFoot old origin width x time k
  have hc : leveque04_burgersActionSegment origin width k c :=
    leveque04_burgersClampedFoot_mem old origin width x time hwidth k
  have hm : leveque04_burgersActionSegment origin width k ((y + c) / 2) := by
    intro j
    constructor
    · intro hj; linarith [(hsegment j).1 hj, (hc j).1 hj]
    · intro hj; linarith [(hsegment j).2 hj, (hc j).2 hj]
  have h₁ := leveque04_burgersInitialPrimitive_sub_on_segment old origin width k ((y + c) / 2) y hm hsegment
  have h₂ := leveque04_burgersInitialPrimitive_sub_on_segment old origin width k c y hc hsegment
  have haffine : leveque04_burgersInitialPrimitive old origin width ((y + c) / 2) =
      (leveque04_burgersInitialPrimitive old origin width y +
        leveque04_burgersInitialPrimitive old origin width c) / 2 := by linarith
  have hmin := (leveque04_burgersFiniteActionMinimizingFeet_iff_global_min old origin width x time y hwidth htime).mp hy
  have hcle : leveque04_burgersAction old origin width x time c ≤
      leveque04_burgersAction old origin width x time y :=
    leveque04_burgersActionCandidate_le old origin width x time hwidth htime k y hsegment
  exact quadraticAction_minimizers_eq_of_affine_midpoint
    (leveque04_burgersInitialPrimitive old origin width) time x y c htime haffine
    (hmin _) (hcle.trans (hmin _))

private theorem open_cell_mem_segment {N : ℕ} (origin width y : ℝ)
    (k : Fin (N + 2)) (hwidth : 0 ≤ width) (hk0 : 0 < k.val)
    (hylo : origin + ((k.val - 1 : ℕ) : ℝ) * width < y)
    (hyhi : y < origin + (k.val : ℝ) * width) :
    leveque04_burgersActionSegment origin width k y := by
  intro j
  constructor
  · intro hj
    have h := face_mono origin width hwidth (show j.val ≤ k.val - 1 by omega)
    simp only [leveque04_burgersActionFace_eq] at h ⊢
    exact h.trans hylo.le
  · intro hj
    have h := face_mono origin width hwidth hj
    simp only [leveque04_burgersActionFace_eq] at h ⊢
    exact hyhi.le.trans h

private theorem clamp_eq_free_of_interior (a b z y : ℝ)
    (hlo : a < y) (hhi : y < b) (hy : y = max a (min b z)) : y = z := by
  by_cases hza : z ≤ a
  · rw [max_eq_left ((min_le_right b z).trans hza)] at hy
    linarith
  · by_cases hbz : b ≤ z
    · rw [min_eq_left hbz, max_eq_right (hlo.trans hhi).le] at hy
      linarith
    · rwa [min_eq_right (le_of_not_ge hbz), max_eq_right (le_of_not_ge hza)] at hy

theorem leveque04_burgersFiniteActionEvolution_eq_state_of_foot_in_cell {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (k : Fin (N + 2))
    (hwidth : 0 ≤ width) (htime : 0 < time) (hk0 : 0 < k.val) (hkN : k.val < N + 1)
    (hylo : origin + ((k.val - 1 : ℕ) : ℝ) * width <
      leveque04_burgersFiniteActionFoot old origin width x time)
    (hyhi : leveque04_burgersFiniteActionFoot old origin width x time <
      origin + (k.val : ℝ) * width) :
    leveque04_burgersFiniteActionEvolution old origin width x time = old k := by
  let y := leveque04_burgersFiniteActionFoot old origin width x time
  have hc := leveque04_burgersFiniteActionMinimizingFeet_eq_clampedFoot_of_segment old origin width x time y k
    hwidth htime (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time)
    (open_cell_mem_segment origin width y k hwidth hk0 hylo hyhi)
  simp only [leveque04_burgersClampedFoot, if_neg (Nat.ne_of_gt hk0), if_neg (Nat.ne_of_lt hkN)] at hc
  have hfree := clamp_eq_free_of_interior _ _ _ y hylo hyhi hc
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width x time htime]
  change (x - y) / time = old k
  apply (div_eq_iff htime.ne').mpr
  linarith

theorem leveque04_burgersFiniteActionEvolution_eq_left_state_of_foot_lt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hylt : leveque04_burgersFiniteActionFoot old origin width x time < origin) :
    leveque04_burgersFiniteActionEvolution old origin width x time = old 0 := by
  let y := leveque04_burgersFiniteActionFoot old origin width x time
  have hy : leveque04_burgersActionSegment origin width (0 : Fin (N + 2)) y := by
    intro j
    constructor
    · intro hj; change j.val < 0 at hj; omega
    · intro _
      have h := face_mono origin width hwidth (Nat.zero_le j.val)
      simp only [leveque04_burgersActionFace_eq, Nat.cast_zero, zero_mul, add_zero] at h ⊢
      exact hylt.le.trans h
  have hc := leveque04_burgersFiniteActionMinimizingFeet_eq_clampedFoot_of_segment old origin width x time y 0
    hwidth htime (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time) hy
  have hc' : y = min (x - old 0 * time) origin := by
    simpa [leveque04_burgersClampedFoot] using hc
  have hfree : y = x - old 0 * time := by
    by_cases hz : x - old 0 * time ≤ origin
    · simpa only [min_eq_left hz] using hc'
    · rw [min_eq_right (le_of_not_ge hz)] at hc'
      linarith
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width x time htime]
  change (x - y) / time = old 0
  apply (div_eq_iff htime.ne').mpr
  linarith

theorem leveque04_burgersFiniteActionEvolution_eq_right_state_of_foot_gt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hygt : origin + (N : ℝ) * width < leveque04_burgersFiniteActionFoot old origin width x time) :
    leveque04_burgersFiniteActionEvolution old origin width x time = old ⟨N + 1, by omega⟩ := by
  let y := leveque04_burgersFiniteActionFoot old origin width x time
  let k : Fin (N + 2) := ⟨N + 1, by omega⟩
  have hy : leveque04_burgersActionSegment origin width k y := by
    intro j
    constructor
    · intro _
      have h := face_mono origin width hwidth (show j.val ≤ N by omega)
      simp only [leveque04_burgersActionFace_eq] at h ⊢
      exact h.trans hygt.le
    · intro hj; dsimp [k] at hj; omega
  have hc := leveque04_burgersFiniteActionMinimizingFeet_eq_clampedFoot_of_segment old origin width x time y k
    hwidth htime (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time) hy
  have hc' : y = max (x - old k * time) (origin + (N : ℝ) * width) := by
    simpa [leveque04_burgersClampedFoot, k] using hc
  have hfree : y = x - old k * time := by
    by_cases hz : origin + (N : ℝ) * width ≤ x - old k * time
    · simpa only [max_eq_left hz] using hc'
    · rw [max_eq_right (le_of_not_ge hz)] at hc'
      linarith
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width x time htime]
  change (x - y) / time = old k
  apply (div_eq_iff htime.ne').mpr
  linarith

end NumStability
