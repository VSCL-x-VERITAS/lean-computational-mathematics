/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionNearFace
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionCFLFootLocality

/-!
# The original two-state primitive beyond equal-state material faces

A foot which stays on the original side of every foreign active jump sees
exactly the original face's two-state primitive plus its original additive
constant. Arbitrarily many equal-state cells and both supplied infinite tails
are allowed. The actual CFL locality theorem supplies this condition for
EVERY true real minimizing foot at EVERY original observation face.
-/

noncomputable section
open Set
open scoped BigOperators

namespace NumStability

private theorem telescoping_state (q : ℕ → ℝ) (n : ℕ) :
    q 0 + ∑ k ∈ Finset.range n, (q (k + 1) - q k) = q n := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ]
    linarith

/-- The compatibility condition concerns only foreign NONZERO jumps.
Equal-state faces impose no restriction on the real foot. -/
theorem leveque04_burgersInitialPrimitive_of_compatible_foot {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width y : ℝ) (j : Fin (N + 1)) (hwidth : 0 < width)
    (hside : ∀ k : Fin (N + 1),
      leveque04_burgersActionState old k.val ≠ leveque04_burgersActionState old (k.val + 1) →
        (k.val < j.val → leveque04_burgersActionFace origin width k.val ≤ y) ∧
        (j.val < k.val → y ≤ leveque04_burgersActionFace origin width k.val)) :
    leveque04_burgersInitialPrimitive old origin width y =
      leveque04_burgersInitialPrimitive old origin width (leveque04_burgersActionFace origin width j.val) +
        leveque04_burgersActionState old j.val * (y - leveque04_burgersActionFace origin width j.val) +
        (leveque04_burgersActionState old (j.val + 1) - leveque04_burgersActionState old j.val) *
          max (y - leveque04_burgersActionFace origin width j.val) 0 := by
  let q := leveque04_burgersActionState old
  let a := leveque04_burgersActionFace origin width j.val
  let d (k : ℕ) := (q (k + 1) - q k) *
    (max (y - leveque04_burgersActionFace origin width k) 0 -
      max (a - leveque04_burgersActionFace origin width k) 0)
  have hm := (leveque04_burgersActionFace_strictMono origin width hwidth).monotone
  have hleft (k : ℕ) (hk : k < j.val) : d k = (q (k + 1) - q k) * (y - a) := by
    by_cases heq : q k = q (k + 1)
    · simp only [d, heq, sub_self, zero_mul]
    · have hkN : k < N + 1 := by omega
      have hy := (hside ⟨k, hkN⟩ heq).1 hk
      have ha := hm hk.le
      dsimp [d]
      rw [max_eq_left (sub_nonneg.mpr hy), max_eq_left (sub_nonneg.mpr ha)]
      ring
  have hright (k : ℕ) (hk : j.val < k) (hkN : k < N + 1) : d k = 0 := by
    by_cases heq : q k = q (k + 1)
    · simp only [d, heq, sub_self, zero_mul]
    · have hy := (hside ⟨k, hkN⟩ heq).2 hk
      have ha : a ≤ leveque04_burgersActionFace origin width k := hm hk.le
      simp only [d, max_eq_right (sub_nonpos.mpr hy), max_eq_right (sub_nonpos.mpr ha), sub_self, mul_zero]
  have hj : d j.val = (q (j.val + 1) - q j.val) * max (y - a) 0 := by
    simp only [d, a, sub_self, max_self, sub_zero]
  have htruncate : ∑ k ∈ Finset.range (N + 1), d k = ∑ k ∈ Finset.range (j.val + 1), d k := by
    symm
    apply Finset.sum_subset (Finset.range_mono (by omega : j.val + 1 ≤ N + 1))
    intro k hk hnot
    have hle : j.val + 1 ≤ k := by
      simpa only [Finset.mem_range, not_lt] using hnot
    exact hright k (by omega) (Finset.mem_range.mp hk)

  have hprefix : ∑ k ∈ Finset.range j.val, d k =
      (∑ k ∈ Finset.range j.val, (q (k + 1) - q k)) * (y - a) := by
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro k hk
    exact hleft k (Finset.mem_range.mp hk)
  have hdiff : leveque04_burgersInitialPrimitive old origin width y -
      leveque04_burgersInitialPrimitive old origin width a = q 0 * (y - a) + ∑ k ∈ Finset.range (N + 1), d k := by
    have hsum : (∑ k ∈ Finset.range (N + 1), (q (k + 1) - q k) * max (y - leveque04_burgersActionFace origin width k) 0) -
        (∑ k ∈ Finset.range (N + 1), (q (k + 1) - q k) * max (a - leveque04_burgersActionFace origin width k) 0) =
        ∑ k ∈ Finset.range (N + 1), d k := by
      rw [← Finset.sum_sub_distrib]
      apply Finset.sum_congr rfl
      intro k _
      dsimp [d]
      ring
    unfold leveque04_burgersInitialPrimitive
    dsimp [q] at hsum ⊢
    linear_combination hsum
  rw [htruncate, Finset.sum_range_succ, hprefix, hj] at hdiff
  have htel := telescoping_state q j.val
  have hmain : q 0 * (y - a) +
      ((∑ k ∈ Finset.range j.val, (q (k + 1) - q k)) * (y - a) +
        (q (j.val + 1) - q j.val) * max (y - a) 0) =
      q j.val * (y - a) + (q (j.val + 1) - q j.val) * max (y - a) 0 := by
    calc
      _ = (q 0 + ∑ k ∈ Finset.range j.val, (q (k + 1) - q k)) * (y - a) +
          (q (j.val + 1) - q j.val) * max (y - a) 0 := by ring
      _ = _ := by rw [htel]
  rw [hmain] at hdiff
  change leveque04_burgersInitialPrimitive old origin width y =
    leveque04_burgersInitialPrimitive old origin width a + q j.val * (y - a) +
      (q (j.val + 1) - q j.val) * max (y - a) 0
  linarith

/-- This equality holds for every actual minimizing foot at each original
face during the open integration-time interval of the full Courant-one step. -/
theorem leveque04_burgersFiniteAction_minimizer_CFL_primitive {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time y : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) (htime : time ∈ Ioo (0 : ℝ) horizon)
    (hy : y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
      (leveque04_burgersActionFace origin width j.val) time) :
    leveque04_burgersInitialPrimitive old origin width y =
      leveque04_burgersInitialPrimitive old origin width (leveque04_burgersActionFace origin width j.val) +
        leveque04_burgersActionState old j.val * (y - leveque04_burgersActionFace origin width j.val) +
        (leveque04_burgersActionState old (j.val + 1) - leveque04_burgersActionState old j.val) *
          max (y - leveque04_burgersActionFace origin width j.val) 0 := by
  apply leveque04_burgersInitialPrimitive_of_compatible_foot old origin width y j hwidth
  intro k hk
  have hf := leveque04_burgersFiniteActionPropagationBound_foreignFace_feet
    old origin width horizon bound time j k hwidth hk hprop hCFL htime
  exact ⟨fun hkj => (hf.1 hkj y hy).le, fun hjk => (hf.2 hjk y hy).le⟩

end NumStability
