/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Real.Basic
import Mathlib.Order.Interval.Finset.Fin

/-!
# Positive support of a decreasing finite sequence

The positive entries of a nonincreasing real sequence form an initial segment.
Their number therefore determines the positivity of each legal index. For a
nonnegative sequence the complementary tail consists exactly of the zeros.
Both results include the empty sequence and allow repeated positive values.
-/

set_option autoImplicit false

namespace NumStability

/-- In a decreasing finite real sequence, an entry is positive exactly when
its index is smaller than the number of positive entries. -/
theorem antitone_pos_iff_lt_card_filter {n : ℕ} (s : Fin n → ℝ)
    (hs : Antitone s) (i : Fin n) :
    0 < s i ↔ i.val < (Finset.univ.filter (fun j => 0 < s j)).card := by
  classical
  constructor
  · intro hi
    have hsub : Finset.Iic i ⊆ Finset.univ.filter (fun j => 0 < s j) := by
      intro j hj
      exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,
        lt_of_lt_of_le hi (hs (Finset.mem_Iic.mp hj))⟩
    have hc := Finset.card_le_card hsub
    exact Nat.lt_of_succ_le (by simpa only [Fin.card_Iic] using hc)
  · intro hi
    by_contra hn
    have hsub : Finset.univ.filter (fun j => 0 < s j) ⊆ Finset.Iio i := by
      intro j hj
      apply Finset.mem_Iio.mpr
      by_contra hji
      exact hn (lt_of_lt_of_le (Finset.mem_filter.mp hj).2 (hs (le_of_not_gt hji)))
    have hc : (Finset.univ.filter (fun j => 0 < s j)).card ≤ i.val := by
      simpa only [Fin.card_Iio] using Finset.card_le_card hsub
    exact (Nat.not_le_of_gt hi) hc

/-- In a nonnegative decreasing finite real sequence, the zeros occur exactly
at the indices at least the number of positive entries. -/
theorem nonneg_antitone_eq_zero_iff_card_filter_le {n : ℕ} (s : Fin n → ℝ)
    (hn : ∀ i, 0 ≤ s i) (hs : Antitone s) (i : Fin n) :
    s i = 0 ↔ (Finset.univ.filter (fun j => 0 < s j)).card ≤ i.val := by
  constructor
  · intro hi
    apply Nat.le_of_not_gt
    intro hlt
    have hpos := (antitone_pos_iff_lt_card_filter s hs i).mpr hlt
    rw [hi] at hpos
    exact (lt_irrefl 0) hpos
  · intro hi
    apply le_antisymm _ (hn i)
    apply le_of_not_gt
    intro hpos
    exact (Nat.not_lt_of_ge hi) ((antitone_pos_iff_lt_card_filter s hs i).mp hpos)

end NumStability
