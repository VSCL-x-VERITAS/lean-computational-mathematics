import ComputationalMathematics.HDP.Coding.ErrorCorrection
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Set.Card
import Mathlib.Tactic.FinCases

/-!
# Finite Hamming balls

The volume of a binary Hamming ball is the corresponding partial binomial
sum.  The proof uses the coordinates on which a word differs from its center.
-/

open Function

namespace NumStability.HDP.Coding

/-- The number of binary words at Hamming distance at most `m` from a fixed
word in the `n`-dimensional Hamming cube. -/
def hammingBallVolume (n m : ℕ) : ℕ :=
  ∑ j ∈ Finset.range (m + 1), n.choose j

/-- Flip precisely the coordinates in `S`. -/
def flipCoordinates {n : ℕ} (x : BinaryWord n) (S : Finset (Fin n)) :
    BinaryWord n := fun i ↦ if i ∈ S then Equiv.swap 0 1 (x i) else x i

/-- Coordinates on which two binary words differ. -/
def differingCoordinates {n : ℕ} (x y : BinaryWord n) : Finset (Fin n) :=
  Finset.univ.filter fun i ↦ x i ≠ y i

private theorem swap_zero_one_ne (a : Fin 2) : Equiv.swap 0 1 a ≠ a := by
  fin_cases a <;> simp

private theorem eq_swap_zero_one_of_ne {a b : Fin 2} (h : a ≠ b) :
    b = Equiv.swap 0 1 a := by
  fin_cases a <;> fin_cases b <;> simp_all

/-- Binary words are equivalent to their finite sets of coordinates differing
from a fixed center. -/
def binaryWordEquivFinset {n : ℕ} (x : BinaryWord n) :
    BinaryWord n ≃ Finset (Fin n) where
  toFun := differingCoordinates x
  invFun := flipCoordinates x
  left_inv y := by
    funext i
    by_cases hi : i ∈ differingCoordinates x y
    · rw [flipCoordinates]
      simp only [hi, if_true]
      exact (eq_swap_zero_one_of_ne (by
        simpa [differingCoordinates] using hi)).symm
    · rw [flipCoordinates]
      simp only [hi, if_false]
      by_contra hxy
      exact hi (by simpa [differingCoordinates] using hxy)
  right_inv S := by
    ext i
    by_cases hi : i ∈ S
    · simp only [differingCoordinates, flipCoordinates, Finset.mem_filter,
        Finset.mem_univ, true_and, hi, if_true]
      exact iff_true_intro (swap_zero_one_ne (x i)).symm
    · simp [differingCoordinates, flipCoordinates, hi]

@[simp]
theorem card_differingCoordinates {n : ℕ} (x y : BinaryWord n) :
    (differingCoordinates x y).card = hammingDist x y := by
  simp only [differingCoordinates, hammingDist]

private def finsetsUpToCard (n m : ℕ) : Finset (Finset (Fin n)) :=
  (Finset.range (m + 1)).disjiUnion
    (fun j ↦ Finset.univ.powersetCard j)
    (Finset.univ.pairwise_disjoint_powersetCard.set_pairwise _)

@[simp]
private theorem mem_finsetsUpToCard {n m : ℕ} (S : Finset (Fin n)) :
    S ∈ finsetsUpToCard n m ↔ S.card ≤ m := by
  simp [finsetsUpToCard]

private theorem card_finsetsUpToCard (n m : ℕ) :
    (finsetsUpToCard n m).card = hammingBallVolume n m := by
  rw [show (finsetsUpToCard n m).card =
      ∑ j ∈ Finset.range (m + 1), (Finset.univ.powersetCard j).card by
    unfold finsetsUpToCard
    rw [Finset.card_disjiUnion]]
  simp [hammingBallVolume]

private theorem card_finsets_card_le (n m : ℕ) :
    Fintype.card {S : Finset (Fin n) // S.card ≤ m} =
      hammingBallVolume n m := by
  rw [Fintype.card_subtype]
  change (Finset.univ.filter fun S : Finset (Fin n) ↦ S.card ≤ m).card = _
  rw [show (Finset.univ.filter fun S : Finset (Fin n) ↦ S.card ≤ m) =
      finsetsUpToCard n m by
    ext S
    simp]
  exact card_finsetsUpToCard n m

/-- Exact binary Hamming-ball cardinality, expressed as a partial binomial
sum. -/
theorem card_hammingBall {n : ℕ} (x : BinaryWord n) (m : ℕ) :
    Fintype.card {y : BinaryWord n // hammingDist x y ≤ m} =
      hammingBallVolume n m := by
  let e : {y : BinaryWord n // hammingDist x y ≤ m} ≃
      {S : Finset (Fin n) // S.card ≤ m} :=
    (binaryWordEquivFinset x).subtypeEquiv fun y ↦ by
      change hammingDist x y ≤ m ↔ (differingCoordinates x y).card ≤ m
      rw [card_differingCoordinates]
  rw [Fintype.card_congr e]
  exact card_finsets_card_le n m

@[simp]
theorem hammingDist_flipCoordinates {n : ℕ} (x : BinaryWord n)
    (S : Finset (Fin n)) :
    hammingDist x (flipCoordinates x S) = S.card := by
  rw [← card_differingCoordinates]
  exact congrArg Finset.card ((binaryWordEquivFinset x).right_inv S)

/-- The binary Hamming cube has cardinality `2^n`. -/
@[simp]
theorem card_binaryWord (n : ℕ) : Fintype.card (BinaryWord n) = 2 ^ n := by
  simpa [BinaryWord] using Fintype.card_fun (Fin n) (Fin 2)

/-- Every binary Hamming ball is nonempty. -/
theorem hammingBallVolume_pos (n m : ℕ) : 0 < hammingBallVolume n m := by
  rw [← card_hammingBall (0 : BinaryWord n) m]
  exact Fintype.card_pos_iff.mpr ⟨⟨0, by simp⟩⟩

/-- A finite family of radius-`m` Hamming balls covering the binary cube has
at least enough center--offset pairs to represent all `2^n` words. -/
theorem card_le_card_mul_hammingBallVolume_of_cover {n m : ℕ}
    (C : Set (BinaryWord n)) (hCfin : C.Finite)
    (hcover : ∀ y : BinaryWord n, ∃ x ∈ C, hammingDist x y ≤ m) :
    2 ^ n ≤ Set.ncard C * hammingBallVolume n m := by
  classical
  let center : BinaryWord n → C := fun y ↦
    ⟨(hcover y).choose, (hcover y).choose_spec.1⟩
  let offset : (y : BinaryWord n) →
      {S : Finset (Fin n) // S.card ≤ m} := fun y ↦
    ⟨differingCoordinates (center y) y, by
      rw [card_differingCoordinates]
      exact (hcover y).choose_spec.2⟩
  let f : BinaryWord n → C × {S : Finset (Fin n) // S.card ≤ m} :=
    fun y ↦ (center y, offset y)
  have hf : Function.Injective f := by
    intro y z hyz
    have hc : center y = center z := congrArg Prod.fst hyz
    have ho : (offset y).1 = (offset z).1 :=
      congrArg (fun p ↦ p.2.1) hyz
    have hcy : differingCoordinates (center y) y =
        differingCoordinates (center y) z := by
      simpa [offset, hc] using ho
    apply (binaryWordEquivFinset (center y)).injective
    exact hcy
  letI : Fintype C := hCfin.fintype
  have hcard := Fintype.card_le_of_injective f hf
  rw [card_binaryWord, Fintype.card_prod, card_finsets_card_le] at hcard
  simpa [← Nat.card_coe_set_eq, Nat.card_eq_fintype_card] using hcard

/-- A finite `m`-separated binary code has disjoint Hamming balls of radius
`⌊m/2⌋`; hence its number of codewords times that ball volume is at most
`2^n`. -/
theorem card_mul_hammingBallVolume_half_le_of_separated {n m : ℕ}
    (P : Set (BinaryWord n)) (hPfin : P.Finite)
    (hsep : ∀ x ∈ P, ∀ z ∈ P, x ≠ z → m < hammingDist x z) :
    Set.ncard P * hammingBallVolume n (m / 2) ≤ 2 ^ n := by
  classical
  let f : P × {S : Finset (Fin n) // S.card ≤ m / 2} → BinaryWord n :=
    fun p ↦ flipCoordinates p.1.1 p.2.1
  have hf : Function.Injective f := by
    rintro ⟨x, S⟩ ⟨z, T⟩ hvalue
    have hxmem : x.1 ∈ P := x.2
    have hzmem : z.1 ∈ P := z.2
    have hcenters : x.1 = z.1 := by
      by_contra hxz
      have hfar := hsep x.1 hxmem z.1 hzmem hxz
      have htri := hammingDist_triangle x.1 (f (x, S)) z.1
      have hxball : hammingDist x.1 (f (x, S)) = S.1.card := by
        exact hammingDist_flipCoordinates x.1 S.1
      have hzball : hammingDist (f (x, S)) z.1 = T.1.card := by
        rw [hvalue, hammingDist_comm]
        exact hammingDist_flipCoordinates z.1 T.1
      rw [hxball, hzball] at htri
      omega
    have hxzsub : x = z := Subtype.ext hcenters
    subst z
    have hsets : S.1 = T.1 := by
      change flipCoordinates x.1 S.1 = flipCoordinates x.1 T.1 at hvalue
      calc
        S.1 = (binaryWordEquivFinset x.1) (flipCoordinates x.1 S.1) :=
          ((binaryWordEquivFinset x.1).right_inv S.1).symm
        _ = (binaryWordEquivFinset x.1) (flipCoordinates x.1 T.1) :=
          congrArg (binaryWordEquivFinset x.1) hvalue
        _ = T.1 := (binaryWordEquivFinset x.1).right_inv T.1
    cases x
    cases S
    cases T
    simp_all
  letI : Fintype P := hPfin.fintype
  have hcard := Fintype.card_le_of_injective f hf
  rw [Fintype.card_prod, card_finsets_card_le, card_binaryWord] at hcard
  simpa [← Nat.card_coe_set_eq, Nat.card_eq_fintype_card] using hcard

end NumStability.HDP.Coding
