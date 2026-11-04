/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteGridRecipe
import Mathlib.Data.Finset.Max
import Mathlib.Topology.Algebra.Order.Field

/-!
# Finite actions for supplied-ghost Burgers data

This constructs a continuous initial primitive from the actual `Fin (N + 2)`
data of `BurgersFiniteGridRecipe`. The two exterior segments are half-lines;
the other `N` segments are the original physical cells. The finite hinge sum
has exactly the supplied slopes, without a periodic or zero-tail convention.

For positive time each affine segment has an explicit clamped minimizing foot.
The resulting `N + 2` action values have an attained finite minimum. These are
variational construction facts only: no weak law, entropy law, active-wave
ancestry, or Godunov face-flux identity is asserted here. In particular no
duration or propagation bound is an input to the construction.
-/

open scoped BigOperators

namespace NumStability

/-- Supplied states, extended only to make finite natural-index sums convenient. -/
def leveque04_burgersActionState {N : ℕ} (old : Fin (N + 2) → ℝ) (j : ℕ) : ℝ :=
  old ⟨min j (N + 1), by omega⟩

theorem leveque04_burgersActionState_eq {N : ℕ} (old : Fin (N + 2) → ℝ)
    (j : Fin (N + 2)) : leveque04_burgersActionState old j.val = old j := by
  simp only [leveque04_burgersActionState, min_eq_left (by omega : j.val ≤ N + 1)]

/-- Physical face positions, with the same origin and width as the grid recipe. -/
def leveque04_burgersActionFace (origin width : ℝ) (j : ℕ) : ℝ :=
  leveque04_uniformInterface origin width (j : ℤ)

theorem leveque04_burgersActionFace_eq (origin width : ℝ) (j : ℕ) :
    leveque04_burgersActionFace origin width j = origin + (j : ℝ) * width := by
  simp [leveque04_burgersActionFace, leveque04_uniformInterface]

/-- The actual continuous piecewise-affine primitive, normalized at the left face. -/
noncomputable def leveque04_burgersInitialPrimitive {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width y : ℝ) : ℝ :=
  leveque04_burgersActionState old 0 * (y - origin) +
    ∑ j ∈ Finset.range (N + 1),
      (leveque04_burgersActionState old (j + 1) -
        leveque04_burgersActionState old j) *
        max (y - leveque04_burgersActionFace origin width j) 0

theorem leveque04_burgersInitialPrimitive_continuous {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    Continuous (leveque04_burgersInitialPrimitive old origin width) := by
  unfold leveque04_burgersInitialPrimitive
  exact (continuous_const.mul (continuous_id.sub continuous_const)).add
    (continuous_finset_sum _ fun _ _ =>
      continuous_const.mul ((continuous_id.sub continuous_const).max continuous_const))

theorem leveque04_burgersInitialPrimitive_origin {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (hwidth : 0 ≤ width) :
    leveque04_burgersInitialPrimitive old origin width origin = 0 := by
  unfold leveque04_burgersInitialPrimitive
  have hface (j : ℕ) : origin ≤ leveque04_burgersActionFace origin width j := by
    rw [leveque04_burgersActionFace_eq]
    exact le_add_of_nonneg_right (mul_nonneg (Nat.cast_nonneg j) hwidth)
  simp only [sub_self, mul_zero, zero_add]
  apply Finset.sum_eq_zero
  intro j _
  rw [max_eq_right (sub_nonpos.mpr (hface j)), mul_zero]

/-- Closed segment membership. For index `0` this is the left half-line; for
index `N + 1` it is the right half-line. Shared endpoints belong to both cells. -/
def leveque04_burgersActionSegment {N : ℕ} (origin width : ℝ)
    (k : Fin (N + 2)) (y : ℝ) : Prop :=
  ∀ j : Fin (N + 1),
    (j.val < k.val → leveque04_burgersActionFace origin width j.val ≤ y) ∧
    (k.val ≤ j.val → y ≤ leveque04_burgersActionFace origin width j.val)

private theorem action_prefix_affine (q : ℕ → ℝ) (face : ℕ → ℝ)
    (origin y z : ℝ) (k : ℕ) :
    (q 0 * (y - origin) + ∑ j ∈ Finset.range k, (q (j + 1) - q j) * (y - face j)) -
      (q 0 * (z - origin) + ∑ j ∈ Finset.range k, (q (j + 1) - q j) * (z - face j)) =
        q k * (y - z) := by
  induction k with
  | zero => simp; ring
  | succ k ih =>
    simp only [Finset.sum_range_succ]
    linear_combination ih

private theorem action_primitive_on_segment {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (k : Fin (N + 2))
    (y : ℝ) (hy : leveque04_burgersActionSegment origin width k y) :
    leveque04_burgersInitialPrimitive old origin width y =
      leveque04_burgersActionState old 0 * (y - origin) +
        ∑ j ∈ Finset.range k.val,
          (leveque04_burgersActionState old (j + 1) -
            leveque04_burgersActionState old j) *
            (y - leveque04_burgersActionFace origin width j) := by
  unfold leveque04_burgersInitialPrimitive
  congr 1
  calc
    _ = ∑ j ∈ Finset.range k.val,
        (leveque04_burgersActionState old (j + 1) -
          leveque04_burgersActionState old j) *
          max (y - leveque04_burgersActionFace origin width j) 0 := by
      symm
      apply Finset.sum_subset (Finset.range_mono (by omega : k.val ≤ N + 1))
      intro j hj hnot
      have hj' : j < N + 1 := Finset.mem_range.mp hj
      have hk : k.val ≤ j := Nat.le_of_not_gt (by simpa using hnot)
      rw [max_eq_right (sub_nonpos.mpr ((hy ⟨j, hj'⟩).2 hk)), mul_zero]
    _ = _ := by
      apply Finset.sum_congr rfl
      intro j hj
      have hjk := Finset.mem_range.mp hj
      have hj' : j < N + 1 := by omega
      rw [max_eq_left (sub_nonneg.mpr ((hy ⟨j, hj'⟩).1 hjk))]

/-- The primitive has exactly the supplied slope on every closed original
segment, including each supplied constant tail. -/
theorem leveque04_burgersInitialPrimitive_sub_on_segment {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (k : Fin (N + 2))
    (y z : ℝ) (hy : leveque04_burgersActionSegment origin width k y)
    (hz : leveque04_burgersActionSegment origin width k z) :
    leveque04_burgersInitialPrimitive old origin width y -
      leveque04_burgersInitialPrimitive old origin width z = old k * (y - z) := by
  rw [action_primitive_on_segment old origin width k y hy,
    action_primitive_on_segment old origin width k z hz]
  simpa only [leveque04_burgersActionState_eq] using
    action_prefix_affine (leveque04_burgersActionState old)
      (leveque04_burgersActionFace origin width) origin y z k.val

/-- Projection to the original closed segment, using one-sided projection on
the exterior tails. There is no artificial bound on the minimizing foot. -/
noncomputable def leveque04_burgersClampedFoot {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (k : Fin (N + 2)) : ℝ :=
  let z := x - old k * time
  if k.val = 0 then min z origin
  else if k.val = N + 1 then max z (origin + (N : ℝ) * width)
  else max (origin + ((k.val - 1 : ℕ) : ℝ) * width)
    (min (origin + (k.val : ℝ) * width) z)

private theorem action_face_mono (origin width : ℝ) (hwidth : 0 ≤ width)
    {i j : ℕ} (hij : i ≤ j) :
    leveque04_burgersActionFace origin width i ≤
      leveque04_burgersActionFace origin width j := by
  simp only [leveque04_burgersActionFace_eq]
  have hcast : (i : ℝ) ≤ (j : ℝ) := by exact_mod_cast hij
  simpa only [add_comm] using
    add_le_add_left (mul_le_mul_of_nonneg_right hcast hwidth) origin

/-- The original closed cells and two half-lines cover every possible foot. -/
theorem leveque04_burgersActionSegment_cover {N : ℕ}
    (origin width : ℝ) (hwidth : 0 ≤ width) (y : ℝ) :
    ∃ k : Fin (N + 2), leveque04_burgersActionSegment origin width k y := by
  by_cases hy : y ≤ origin
  · refine ⟨0, ?_⟩
    intro j
    change (j.val < 0 → _) ∧ (0 ≤ j.val → _)
    constructor
    · omega
    · intro _
      apply hy.trans
      simpa [leveque04_burgersActionFace_eq] using
        action_face_mono origin width hwidth (Nat.zero_le j.val)
  · let s := Finset.univ.filter (fun j : Fin (N + 1) =>
      leveque04_burgersActionFace origin width j.val ≤ y)
    have hzero : (0 : Fin (N + 1)) ∈ s := by
      simp [s, leveque04_burgersActionFace_eq, (le_of_not_ge hy)]
    obtain ⟨j, hj, hmax⟩ := Finset.exists_max_image s (fun j => j.val) ⟨0, hzero⟩
    have hjy : leveque04_burgersActionFace origin width j.val ≤ y :=
      (Finset.mem_filter.mp hj).2
    refine ⟨⟨j.val + 1, by omega⟩, ?_⟩
    intro i
    change (i.val < j.val + 1 → _) ∧ (j.val + 1 ≤ i.val → _)
    constructor
    · intro hi
      exact (action_face_mono origin width hwidth (show i.val ≤ j.val by omega)).trans hjy
    · intro hi
      apply le_of_not_gt
      intro hiy
      have his : i ∈ s := Finset.mem_filter.mpr ⟨Finset.mem_univ i, hiy.le⟩
      have himax := hmax i his
      omega

theorem leveque04_burgersClampedFoot_mem {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (hwidth : 0 ≤ width)
    (k : Fin (N + 2)) :
    leveque04_burgersActionSegment origin width k
      (leveque04_burgersClampedFoot old origin width x time k) := by
  intro j
  unfold leveque04_burgersClampedFoot
  split_ifs with hk0 hkN
  · constructor
    · omega
    · intro _
      exact (min_le_right _ _).trans (by
        simpa [leveque04_burgersActionFace_eq] using
          action_face_mono origin width hwidth (Nat.zero_le j.val))
  · constructor
    · intro _
      apply le_trans (action_face_mono origin width hwidth (show j.val ≤ N by omega))
      simp [leveque04_burgersActionFace_eq]
    · omega
  · have hk : 1 ≤ k.val ∧ k.val ≤ N := by omega
    have hfaces := action_face_mono origin width hwidth
      (show k.val - 1 ≤ k.val by omega)
    constructor
    · intro hj
      apply le_trans (action_face_mono origin width hwidth (show j.val ≤ k.val - 1 by omega))
      simp [leveque04_burgersActionFace_eq]
    · intro hj
      apply le_trans _ (action_face_mono origin width hwidth hj)
      have hlr : origin + ((k.val - 1 : ℕ) : ℝ) * width ≤
          origin + (k.val : ℝ) * width := by
        simpa only [leveque04_burgersActionFace_eq] using hfaces
      have hm : max (origin + ((k.val - 1 : ℕ) : ℝ) * width)
          (min (origin + (k.val : ℝ) * width) (x - old k * time)) ≤
          origin + (k.val : ℝ) * width :=
        max_le hlr (min_le_left _ _)
      simpa only [leveque04_burgersActionFace_eq] using hm

private theorem sq_min_le (z a y : ℝ) (hy : y ≤ a) :
    (min z a - z) ^ 2 ≤ (y - z) ^ 2 := by
  by_cases hz : z ≤ a
  · rw [min_eq_left hz]; nlinarith [sq_nonneg (y - z)]
  · rw [min_eq_right (le_of_not_ge hz)]; nlinarith

private theorem sq_max_le (z a y : ℝ) (hy : a ≤ y) :
    (max z a - z) ^ 2 ≤ (y - z) ^ 2 := by
  by_cases hz : a ≤ z
  · rw [max_eq_left hz]; nlinarith [sq_nonneg (y - z)]
  · rw [max_eq_right (le_of_not_ge hz)]; nlinarith

private theorem sq_clamp_le (z a b y : ℝ) (hab : a ≤ b)
    (hy : a ≤ y ∧ y ≤ b) :
    (max a (min b z) - z) ^ 2 ≤ (y - z) ^ 2 := by
  by_cases hza : z ≤ a
  · rw [min_eq_right (hza.trans hab), max_eq_left hza]
    nlinarith
  · by_cases hzb : b ≤ z
    · rw [min_eq_left hzb, max_eq_right hab]
      nlinarith
    · rw [min_eq_right (le_of_not_ge hzb), max_eq_right (le_of_not_ge hza)]
      nlinarith [sq_nonneg (y - z)]

theorem leveque04_burgersClampedFoot_sq_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (hwidth : 0 ≤ width)
    (k : Fin (N + 2)) (y : ℝ)
    (hy : leveque04_burgersActionSegment origin width k y) :
    (leveque04_burgersClampedFoot old origin width x time k - (x - old k * time)) ^ 2 ≤
      (y - (x - old k * time)) ^ 2 := by
  unfold leveque04_burgersClampedFoot
  split_ifs with hk0 hkN
  · apply sq_min_le
    simpa [leveque04_burgersActionFace_eq] using
      (hy ⟨0, by omega⟩).2 (by omega)
  · apply sq_max_le
    simpa [leveque04_burgersActionFace_eq] using
      (hy ⟨N, by omega⟩).1 (by omega)
  · have hk : 1 ≤ k.val ∧ k.val ≤ N := by omega
    apply sq_clamp_le
    · simpa [leveque04_burgersActionFace_eq] using
        action_face_mono origin width hwidth (show k.val - 1 ≤ k.val by omega)
    · constructor
      · simpa [leveque04_burgersActionFace_eq] using
          (hy ⟨k.val - 1, by omega⟩).1 (by change k.val - 1 < k.val; omega)
      · simpa [leveque04_burgersActionFace_eq] using
          (hy ⟨k.val, by omega⟩).2 (by change k.val ≤ k.val; omega)

/-- The actual initial-data action, not an assumed solution or a PDE callback. -/
noncomputable def leveque04_burgersAction {N : ℕ} (old : Fin (N + 2) → ℝ)
    (origin width x time y : ℝ) : ℝ :=
  leveque04_burgersInitialPrimitive old origin width y + (x - y) ^ 2 / (2 * time)

/-- Complete-square identity on one original affine segment. -/
theorem leveque04_burgersAction_completeSquare {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (htime : 0 < time)
    (k : Fin (N + 2)) (y z : ℝ)
    (hy : leveque04_burgersActionSegment origin width k y)
    (hz : leveque04_burgersActionSegment origin width k z) :
    leveque04_burgersAction old origin width x time y -
      leveque04_burgersAction old origin width x time z =
      ((y - (x - old k * time)) ^ 2 - (z - (x - old k * time)) ^ 2) / (2 * time) := by
  have hp := leveque04_burgersInitialPrimitive_sub_on_segment old origin width k y z hy hz
  unfold leveque04_burgersAction
  rw [show leveque04_burgersInitialPrimitive old origin width y =
      leveque04_burgersInitialPrimitive old origin width z + old k * (y - z) by linarith]
  field_simp [htime.ne']
  ring

/-- One explicit candidate for each of the `N + 2` original segments. -/
noncomputable def leveque04_burgersActionCandidate {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (k : Fin (N + 2)) : ℝ :=
  leveque04_burgersAction old origin width x time
    (leveque04_burgersClampedFoot old origin width x time k)

theorem leveque04_burgersActionCandidate_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (k : Fin (N + 2)) (y : ℝ)
    (hy : leveque04_burgersActionSegment origin width k y) :
    leveque04_burgersActionCandidate old origin width x time k ≤
      leveque04_burgersAction old origin width x time y := by
  have hid := leveque04_burgersAction_completeSquare old origin width x time htime k y
    (leveque04_burgersClampedFoot old origin width x time k) hy
    (leveque04_burgersClampedFoot_mem old origin width x time hwidth k)
  have hsq := leveque04_burgersClampedFoot_sq_le old origin width x time hwidth k y hy
  have hnonneg : 0 ≤ ((y - (x - old k * time)) ^ 2 -
      (leveque04_burgersClampedFoot old origin width x time k -
        (x - old k * time)) ^ 2) / (2 * time) :=
    div_nonneg (sub_nonneg.mpr hsq) (by positivity)
  unfold leveque04_burgersActionCandidate
  linarith

/-- The finite action minimum is attained; no coercivity or existence oracle is used. -/
theorem leveque04_burgersActionCandidate_exists_min {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) :
    ∃ k : Fin (N + 2), ∀ j : Fin (N + 2),
      leveque04_burgersActionCandidate old origin width x time k ≤
        leveque04_burgersActionCandidate old origin width x time j := by
  obtain ⟨k, _, hk⟩ := Finset.exists_min_image Finset.univ
    (leveque04_burgersActionCandidate old origin width x time)
    (show (Finset.univ : Finset (Fin (N + 2))).Nonempty from ⟨0, Finset.mem_univ _⟩)
  exact ⟨k, fun j => hk j (Finset.mem_univ j)⟩

/-- The finite attained minimum is also the minimum over **all real feet**,
because the original cells and supplied tails cover the whole line. -/
theorem leveque04_burgersAction_exists_global_min {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    ∃ k : Fin (N + 2), ∀ y : ℝ,
      leveque04_burgersAction old origin width x time
        (leveque04_burgersClampedFoot old origin width x time k) ≤
          leveque04_burgersAction old origin width x time y := by
  obtain ⟨k, hk⟩ := leveque04_burgersActionCandidate_exists_min old origin width x time
  refine ⟨k, ?_⟩
  intro y
  obtain ⟨j, hj⟩ := leveque04_burgersActionSegment_cover origin width hwidth y
  exact (hk j).trans
    (leveque04_burgersActionCandidate_le old origin width x time hwidth htime j y hj)

/-- Among the finitely many action-minimizing feet there is a largest one.
This is a concrete finite tie rule, independent of a duration or speed bound. -/
theorem leveque04_burgersActionCandidate_exists_largest_min {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) :
    ∃ k : Fin (N + 2),
      (∀ j, leveque04_burgersActionCandidate old origin width x time k ≤
        leveque04_burgersActionCandidate old origin width x time j) ∧
      (∀ j, leveque04_burgersActionCandidate old origin width x time j =
          leveque04_burgersActionCandidate old origin width x time k →
        leveque04_burgersClampedFoot old origin width x time j ≤
          leveque04_burgersClampedFoot old origin width x time k) := by
  obtain ⟨k₀, hk₀⟩ := leveque04_burgersActionCandidate_exists_min old origin width x time
  let s := Finset.univ.filter (fun j : Fin (N + 2) =>
    leveque04_burgersActionCandidate old origin width x time j =
      leveque04_burgersActionCandidate old origin width x time k₀)
  have hk₀s : k₀ ∈ s := by simp [s]
  obtain ⟨k, hks, hkmax⟩ := Finset.exists_max_image s
    (leveque04_burgersClampedFoot old origin width x time) ⟨k₀, hk₀s⟩
  have hkeq := (Finset.mem_filter.mp hks).2
  refine ⟨k, ?_, ?_⟩
  · intro j
    rw [hkeq]
    exact hk₀ j
  · intro j hj
    apply hkmax j
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ j, hj.trans hkeq⟩

end NumStability
