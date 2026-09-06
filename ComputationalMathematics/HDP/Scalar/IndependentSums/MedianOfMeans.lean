import Mathlib.Data.Fin.Tuple.Sort
import Mathlib.Tactic

/-!
# Median-of-means foundations

Deterministic finite-family facts used by the median-of-means amplification
argument.  The probabilistic construction is kept separate from this order-
theoretic core.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Scalar.IndependentSums.MedianOfMeans

/-- A finite-family median has a strict majority of the observations on each
side.  This formulation is especially convenient for odd-cardinality families. -/
def IsFiniteMedian {ι : Type*} [Fintype ι] (x : ι → ℝ) (m : ℝ) : Prop :=
  Fintype.card ι <
      2 * (Finset.univ.filter fun i => x i ≤ m).card ∧
    Fintype.card ι <
      2 * (Finset.univ.filter fun i => m ≤ x i).card

/-- The middle order statistic of an odd tuple. -/
def oddMedian (k : ℕ) (x : Fin (2 * k + 1) → ℝ) : ℝ :=
  x (Tuple.sort x ⟨k, by omega⟩)

private theorem card_filter_comp_sort
    {n : ℕ} (x : Fin n → ℝ) (p : ℝ → Prop) [DecidablePred p] :
    (Finset.univ.filter fun i => p (x (Tuple.sort x i))).card =
      (Finset.univ.filter fun i => p (x i)).card := by
  let s := Finset.univ.filter fun i => p (x (Tuple.sort x i))
  calc
    s.card = (s.map (Tuple.sort x).toEmbedding).card :=
      (Finset.card_map _).symm
    _ = (Finset.univ.filter fun i => p (x i)).card := by
      congr 1
      ext i
      simp [s]

/-- The middle order statistic of a tuple of length `2k+1` is a finite median. -/
theorem oddMedian_isFiniteMedian (k : ℕ) (x : Fin (2 * k + 1) → ℝ) :
    IsFiniteMedian x (oddMedian k x) := by
  classical
  let j : Fin (2 * k + 1) := ⟨k, by omega⟩
  let sorted : Fin (2 * k + 1) → ℝ := x ∘ Tuple.sort x
  have hsorted : Monotone sorted := Tuple.monotone_sort x
  have hj : sorted j = oddMedian k x := by rfl
  have hleftSorted : k <
      (Finset.univ.filter fun i => sorted i ≤ oddMedian k x).card := by
    have h := (Tuple.lt_card_le_iff_apply_le_of_monotone hsorted
      (j := j) (a := oddMedian k x)).2 (by simp [hj])
    simpa [j] using h
  have hleftCard : k <
      (Finset.univ.filter fun i => x i ≤ oddMedian k x).card := by
    rw [← card_filter_comp_sort x (fun y => y ≤ oddMedian k x)]
    simpa [sorted] using hleftSorted
  have hltSorted : ¬k <
      (Finset.univ.filter fun i => sorted i < oddMedian k x).card := by
    have h := (Tuple.lt_card_lt_iff_apply_lt_of_monotone hsorted
      (j := j) (a := oddMedian k x))
    rw [h]
    simp [hj]
  have hltCard :
      (Finset.univ.filter fun i => x i < oddMedian k x).card ≤ k := by
    rw [← card_filter_comp_sort x (fun y => y < oddMedian k x)]
    exact Nat.not_lt.mp (by simpa [sorted] using hltSorted)
  have hpartition := Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (Fin (2 * k + 1))))
    (p := fun i => x i < oddMedian k x)
  have hrightCard : k <
      (Finset.univ.filter fun i => oddMedian k x ≤ x i).card := by
    have hnotEq :
        (Finset.univ.filter fun i => ¬x i < oddMedian k x).card =
          (Finset.univ.filter fun i => oddMedian k x ≤ x i).card := by
      congr 1
      ext i
      simp
    rw [hnotEq] at hpartition
    simp only [Finset.card_univ, Fintype.card_fin] at hpartition
    omega
  constructor <;> simp only [Fintype.card_fin] <;> omega

/-- If a strict majority of a finite family lies in the open accuracy interval,
then every median of that family lies in the same interval. -/
theorem abs_sub_lt_of_majority_accurate
    {ι : Type*} [Fintype ι] (x : ι → ℝ) {m center ε : ℝ}
    (hmed : IsFiniteMedian x m)
    (hgood : Fintype.card ι <
      2 * (Finset.univ.filter fun i => |x i - center| < ε).card) :
    |m - center| < ε := by
  classical
  rw [abs_sub_lt_iff]
  constructor
  · by_contra hright
    have hm : center + ε ≤ m := by linarith
    let right : Finset ι := Finset.univ.filter fun i => m ≤ x i
    let good : Finset ι := Finset.univ.filter fun i => |x i - center| < ε
    have hrightCard : Fintype.card ι < 2 * right.card := by
      simpa [right, IsFiniteMedian] using hmed.2
    have hgoodCard : Fintype.card ι < 2 * good.card := by
      simpa [good] using hgood
    have hsum : Fintype.card ι < right.card + good.card := by omega
    obtain ⟨i, hi⟩ :=
      Finset.inter_nonempty_of_card_lt_card_add_card
        (s := Finset.univ) (t := right) (u := good)
        (by simp [right]) (by simp [good]) (by simpa using hsum)
    have hiRight : i ∈ right := (Finset.mem_inter.mp hi).1
    have hiGood : i ∈ good := (Finset.mem_inter.mp hi).2
    have hxi : m ≤ x i := by simpa [right] using hiRight
    have hacc : x i < center + ε := by
      have := (abs_sub_lt_iff.mp (by simpa [good] using hiGood)).1
      linarith
    linarith
  · by_contra hleft
    have hm : m ≤ center - ε := by linarith
    let left : Finset ι := Finset.univ.filter fun i => x i ≤ m
    let good : Finset ι := Finset.univ.filter fun i => |x i - center| < ε
    have hleftCard : Fintype.card ι < 2 * left.card := by
      simpa [left, IsFiniteMedian] using hmed.1
    have hgoodCard : Fintype.card ι < 2 * good.card := by
      simpa [good] using hgood
    have hsum : Fintype.card ι < left.card + good.card := by omega
    obtain ⟨i, hi⟩ :=
      Finset.inter_nonempty_of_card_lt_card_add_card
        (s := Finset.univ) (t := left) (u := good)
        (by simp [left]) (by simp [good]) (by simpa using hsum)
    have hiLeft : i ∈ left := (Finset.mem_inter.mp hi).1
    have hiGood : i ∈ good := (Finset.mem_inter.mp hi).2
    have hxi : x i ≤ m := by simpa [left] using hiLeft
    have hacc : center - ε < x i := by
      have := (abs_sub_lt_iff.mp (by simpa [good] using hiGood)).2
      linarith
    linarith

/-- Failure of the odd median implies that at least half of the weak estimates
fail.  This is the deterministic event inclusion used by median-of-means. -/
theorem oddMedian_failure_implies_many_failures
    (k : ℕ) (x : Fin (2 * k + 1) → ℝ) {center ε : ℝ}
    (hfail : ε ≤ |oddMedian k x - center|) :
    Fintype.card (Fin (2 * k + 1)) ≤
      2 * (Finset.univ.filter fun i => ε ≤ |x i - center|).card := by
  classical
  let bad : Finset (Fin (2 * k + 1)) :=
    Finset.univ.filter fun i => ε ≤ |x i - center|
  let good : Finset (Fin (2 * k + 1)) :=
    Finset.univ.filter fun i => |x i - center| < ε
  have hpartition : bad.card + good.card = Fintype.card (Fin (2 * k + 1)) := by
    have h := Finset.card_filter_add_card_filter_not
      (s := (Finset.univ : Finset (Fin (2 * k + 1))))
      (p := fun i => ε ≤ |x i - center|)
    have hnotEq :
        (Finset.univ.filter fun i => ¬ε ≤ |x i - center|).card = good.card := by
      congr 1
      ext i
      simp [good]
    rw [hnotEq] at h
    simpa [bad] using h
  by_contra hminority
  have hbad : 2 * bad.card < Fintype.card (Fin (2 * k + 1)) := by
    exact Nat.lt_of_not_ge (by simpa [bad] using hminority)
  have hgood : Fintype.card (Fin (2 * k + 1)) < 2 * good.card := by omega
  have haccurate := abs_sub_lt_of_majority_accurate x
    (oddMedian_isFiniteMedian k x) (by simpa [good] using hgood)
  linarith

end NumStability.HDP.Scalar.IndependentSums.MedianOfMeans
