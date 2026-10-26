/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic

/-!
# Possible reads of a three-point stencil

Every discrete cone site can be transmitted by a sequence of permitted
projection updates. This is possibility over updates; a particular update
may ignore all its inputs, as the constant-callback theorem demonstrates.
-/

open Set
open scoped BigOperators
namespace NumStability

theorem centeredStencilEvolution_shiftSequence
    {E : Type*} (offset : ℕ → ℤ) (initial : ℤ → E) (steps : ℕ) (i : ℤ) :
    centeredStencilEvolution (fun k u j => u (j + offset k)) initial steps i =
      initial (i + ∑ k ∈ Finset.range steps, offset k) := by
  induction steps generalizing i with
  | zero => simp [centeredStencilEvolution]
  | succ n ih =>
    simp only [centeredStencilEvolution, ih, Finset.sum_range_succ]
    congr 1
    omega

theorem threePointOffsets_reach_interval (steps : ℕ) (z : ℤ)
    (hz : -(steps : ℤ) ≤ z ∧ z ≤ steps) :
    ∃ offset : ℕ → ℤ,
      (∀ k < steps, -1 ≤ offset k ∧ offset k ≤ 1) ∧
      ∑ k ∈ Finset.range steps, offset k = z := by
  induction steps generalizing z with
  | zero =>
    refine ⟨fun _ => 0, ?_, ?_⟩
    · simp
    · simp only [Finset.range_zero, Finset.sum_empty]
      omega
  | succ n ih =>
    let delta : ℤ := if z < 0 then -1 else if 0 < z then 1 else 0
    have hd : -1 ≤ delta ∧ delta ≤ 1 := by dsimp [delta]; split_ifs <;> omega
    have hr : -(n : ℤ) ≤ z-delta ∧ z-delta ≤ n := by
      dsimp [delta]
      simp only [Nat.cast_add, Nat.cast_one] at hz
      split_ifs <;> omega
    obtain ⟨old, hbound, hsum⟩ := ih (z-delta) hr
    refine ⟨fun k => if k < n then old k else delta, ?_, ?_⟩
    · intro k hk
      by_cases hkn : k < n
      · simpa [hkn] using hbound k hkn
      · simpa [hkn] using hd
    · rw [Finset.sum_range_succ]
      have hs : (∑ k ∈ Finset.range n, if k < n then old k else delta) =
          ∑ k ∈ Finset.range n, old k := by
        apply Finset.sum_congr rfl
        intro k hk
        simp [Finset.mem_range.mp hk]
      simp only [hs, lt_self_iff_false, ↓reduceIte, hsum]
      omega

/-- Every point in the discrete three-point envelope can be selected by an
actual sequence of allowed reads. This asserts possibility over callbacks,
without asserting essential dependence for every callback. -/
theorem threePointEvolution_possibleRead
    {E : Type*} (steps : ℕ) (z : ℤ) (hz : -(steps : ℤ) ≤ z ∧ z ≤ steps) :
    ∃ F : ℕ → ℤ → E → E → E → E,
      ∀ initial : ℤ → E, ∀ i : ℤ,
        centeredStencilEvolution (fun k u j => F k j (u (j-1)) (u j) (u (j+1)))
          initial steps i = initial (i+z) := by
  obtain ⟨offset,hbound,hsum⟩ := threePointOffsets_reach_interval steps z hz
  refine ⟨fun k _ a b c => if offset k = -1 then a else if offset k = 0 then b else c, ?_⟩
  intro initial i
  have heq : ∀ n ≤ steps, ∀ j : ℤ,
      centeredStencilEvolution
        (fun k u j => if offset k = -1 then u (j-1) else if offset k = 0 then u j else u (j+1))
          initial n j =
      centeredStencilEvolution (fun k u j => u (j+offset k)) initial n j := by
    intro n
    induction n with
    | zero => intro hn j; rfl
    | succ n ih =>
      intro hn j
      have hb := hbound n (by omega)
      simp only [centeredStencilEvolution]
      by_cases hleft : offset n = -1
      · simp only [hleft, ↓reduceIte]
        simpa only [sub_eq_add_neg] using ih (by omega) (j-1)
      · by_cases hzero : offset n = 0
        · simp only [hzero, ↓reduceIte, add_zero]
          exact ih (by omega) j
        · have hright : offset n = 1 := by omega
          simp only [hright]
          exact ih (by omega) (j+1)
  rw [heq steps le_rfl, centeredStencilEvolution_shiftSequence, hsum]

/-- A degenerate allowed update can ignore all initial data after one step. -/
theorem threePointEvolution_constantCallback (left right : ℤ → ℝ)
    (steps : ℕ) (i : ℤ) :
    centeredStencilEvolution (fun _ _ _ => (0 : ℝ)) left (steps+1) i =
      centeredStencilEvolution (fun _ _ _ => (0 : ℝ)) right (steps+1) i := by
  rfl
end NumStability
