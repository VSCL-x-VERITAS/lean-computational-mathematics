import ComputationalMathematics.HDP.Coding.ErrorCorrection

/-!
# Repetition and majority decoding over a finite alphabet

The elementary repetition-code argument does not depend on a binary alphabet.
For each message coordinate, the decoder selects a most frequent received
symbol among the `2r+1` copies.
-/

namespace NumStability.HDP.Coding

/-- A length-`k` word over an arbitrary alphabet. -/
abbrev AlphabetWord (α : Type*) (k : ℕ) := Fin k → α

/-- Repeat each coordinate of an alphabet-valued word `2r+1` times. -/
def generalRepetitionEncode {α : Type*} (r : ℕ) {k : ℕ}
    (x : AlphabetWord α k) : Fin (2 * r + 1) × Fin k → α :=
  fun p ↦ x p.2

/-- The number of received copies of symbol `a` at message coordinate `i`. -/
def coordinateSymbolCount {α : Type*} [DecidableEq α] (r : ℕ) {k : ℕ}
    (y : Fin (2 * r + 1) × Fin k → α) (i : Fin k) (a : α) : ℕ :=
  (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) = a).card

/-- Select a most frequent received symbol at one coordinate. -/
noncomputable def majoritySymbol {α : Type*} [Fintype α] [Nonempty α]
    [DecidableEq α] (r : ℕ) {k : ℕ}
    (y : Fin (2 * r + 1) × Fin k → α) (i : Fin k) : α :=
  Classical.choose (Finset.exists_max_image Finset.univ
    (coordinateSymbolCount r y i) Finset.univ_nonempty)

theorem coordinateSymbolCount_le_majoritySymbol
    {α : Type*} [Fintype α] [Nonempty α] [DecidableEq α]
    (r : ℕ) {k : ℕ} (y : Fin (2 * r + 1) × Fin k → α)
    (i : Fin k) (a : α) :
    coordinateSymbolCount r y i a ≤
      coordinateSymbolCount r y i (majoritySymbol r y i) := by
  exact (Classical.choose_spec (Finset.exists_max_image Finset.univ
    (coordinateSymbolCount r y i) Finset.univ_nonempty)).2
      a (Finset.mem_univ a)

/-- Coordinatewise finite-alphabet majority decoding. -/
noncomputable def generalMajorityDecode
    {α : Type*} [Fintype α] [Nonempty α] [DecidableEq α]
    (r k : ℕ) (y : Fin (2 * r + 1) × Fin k → α) : AlphabetWord α k :=
  fun i ↦ majoritySymbol r y i

private theorem general_coordinate_disagreements_le
    {α : Type*} [DecidableEq α] (r : ℕ) {k : ℕ}
    (x : AlphabetWord α k) (y : Fin (2 * r + 1) × Fin k → α)
    (i : Fin k) :
    (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) ≠ x i).card ≤
      hammingDist y (generalRepetitionEncode r x) := by
  let s := Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) ≠ x i
  let t := Finset.univ.filter fun p : Fin (2 * r + 1) × Fin k ↦
    y p ≠ generalRepetitionEncode r x p
  have hsub : s.image (fun j ↦ (j, i)) ⊆ t := by
    intro p hp
    simp only [Finset.mem_image] at hp
    obtain ⟨j, hj, rfl⟩ := hp
    simpa [s, t, generalRepetitionEncode] using hj
  have hinj : Function.Injective (fun j : Fin (2 * r + 1) ↦ (j, i)) :=
    fun _ _ h ↦ congrArg Prod.fst h
  calc
    s.card = (s.image (fun j ↦ (j, i))).card :=
      (Finset.card_image_of_injective _ hinj).symm
    _ ≤ t.card := Finset.card_le_card hsub
    _ = hammingDist y (generalRepetitionEncode r x) := rfl

/-- Majority decoding over any finite nonempty alphabet recovers every message
after at most `r` corruptions among all repeated coordinates. -/
theorem generalMajorityDecode_correct
    {α : Type*} [Fintype α] [Nonempty α] [DecidableEq α]
    (r k : ℕ) (x : AlphabetWord α k)
    (y : Fin (2 * r + 1) × Fin k → α)
    (hy : hammingDist y (generalRepetitionEncode r x) ≤ r) :
    generalMajorityDecode r k y = x := by
  funext i
  have hi := (general_coordinate_disagreements_le r x y i).trans hy
  let errors : Finset (Fin (2 * r + 1)) :=
    Finset.univ.filter fun j ↦ y (j, i) ≠ x i
  have htrueCount : r < coordinateSymbolCount r y i (x i) := by
    have hpartition := Finset.card_filter_add_card_filter_not
      (s := (Finset.univ : Finset (Fin (2 * r + 1))))
      (fun j ↦ y (j, i) = x i)
    have herr : errors.card ≤ r := by
      simpa [errors] using hi
    simp only [Finset.card_univ, Fintype.card_fin] at hpartition
    unfold coordinateSymbolCount
    have hnot :
        (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ ¬ y (j, i) = x i).card =
          errors.card := by
      rfl
    rw [hnot] at hpartition
    omega
  have hmax := coordinateSymbolCount_le_majoritySymbol r y i (x i)
  by_contra hne
  change majoritySymbol r y i ≠ x i at hne
  have hwrongSubset :
      (Finset.univ.filter fun j : Fin (2 * r + 1) ↦
          y (j, i) = majoritySymbol r y i) ⊆ errors := by
    intro j hj
    simp only [errors, Finset.mem_filter, Finset.mem_univ, true_and] at hj ⊢
    intro heq
    exact hne (hj.symm.trans heq)
  have hwrong : coordinateSymbolCount r y i (majoritySymbol r y i) ≤ r := by
    calc
      coordinateSymbolCount r y i (majoritySymbol r y i) ≤ errors.card := by
        exact Finset.card_le_card hwrongSubset
      _ ≤ r := by simpa [errors] using hi
  omega

end NumStability.HDP.Coding
