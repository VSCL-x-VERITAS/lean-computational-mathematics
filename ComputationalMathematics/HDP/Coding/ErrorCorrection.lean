import Mathlib.InformationTheory.Hamming

/-!
# Elementary binary error-correcting codes

The definitions and repetition-code construction used in Chapter 4 of
Vershynin's *High-Dimensional Probability*.
-/

open Finset Function

namespace NumStability.HDP.Coding

/-- Binary words of length `n`. -/
abbrev BinaryWord (n : ℕ) := Fin n → Fin 2

private theorem finTwo_eq_one_iff_ne_zero (b : Fin 2) : b = 1 ↔ b ≠ 0 := by
  rcases Nat.le_one_iff_eq_zero_or_eq_one.mp (Nat.le_of_lt_succ b.isLt) with h | h
  · have hb : b = (0 : Fin 2) := Fin.ext h
    rw [hb]
    simp
  · have hb : b = (1 : Fin 2) := Fin.ext h
    rw [hb]
    simp

/-- An encoder/decoder pair which corrects every pattern of at most `r`
Hamming errors. -/
structure ErrorCorrectingCode (k n r : ℕ) where
  /-- Encode a message as a binary codeword. -/
  encode : BinaryWord k → BinaryWord n
  /-- Decode a received binary word to a message. -/
  decode : BinaryWord n → BinaryWord k
  corrects : ∀ (x : BinaryWord k) (y : BinaryWord n),
    hammingDist y (encode x) ≤ r → decode y = x

/-- The codebook is the range of the encoding map. -/
def ErrorCorrectingCode.codebook {k n r : ℕ} (C : ErrorCorrectingCode k n r) :
    Set (BinaryWord n) := Set.range C.encode

/-- Repetition encoding, indexed as a rectangular array of `2r+1` copies. -/
def repetitionEncode (r : ℕ) {k : ℕ} (x : BinaryWord k) :
    Fin (2 * r + 1) × Fin k → Fin 2 := fun p ↦ x p.2

/-- The usual coordinatewise majority decoder for `2r+1` repeated copies. -/
def majorityDecode (r k : ℕ)
    (y : Fin (2 * r + 1) × Fin k → Fin 2) : BinaryWord k := fun i ↦
  if r < (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) = 1).card then 1 else 0

private theorem coordinate_disagreements_le (r : ℕ) {k : ℕ}
    (x : BinaryWord k) (y : Fin (2 * r + 1) × Fin k → Fin 2) (i : Fin k) :
    (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) ≠ x i).card ≤
      hammingDist y (repetitionEncode r x) := by
  classical
  let s := Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) ≠ x i
  let t := Finset.univ.filter fun p : Fin (2 * r + 1) × Fin k ↦
    y p ≠ repetitionEncode r x p
  have hsub : s.image (fun j ↦ (j, i)) ⊆ t := by
    intro p hp
    simp only [Finset.mem_image] at hp
    obtain ⟨j, hj, rfl⟩ := hp
    simpa [s, t, repetitionEncode] using hj
  have hinj : Function.Injective (fun j : Fin (2 * r + 1) ↦ (j, i)) :=
    fun _ _ h ↦ congrArg Prod.fst h
  calc
    s.card = (s.image (fun j ↦ (j, i))).card :=
      (Finset.card_image_of_injective _ hinj).symm
    _ ≤ t.card := Finset.card_le_card hsub
    _ = hammingDist y (repetitionEncode r x) := rfl

/-- Majority decoding recovers every message after at most `r` corruptions. -/
theorem majorityDecode_correct (r k : ℕ) (x : BinaryWord k)
    (y : Fin (2 * r + 1) × Fin k → Fin 2)
    (hy : hammingDist y (repetitionEncode r x) ≤ r) :
    majorityDecode r k y = x := by
  classical
  funext i
  have hi := le_trans (coordinate_disagreements_le r x y i) hy
  have hxi : x i = 0 ∨ x i = 1 := by
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp (Nat.le_of_lt_succ (x i).isLt) with h | h
    · exact Or.inl (Fin.ext h)
    · exact Or.inr (Fin.ext h)
  rcases hxi with hzero | hone
  · have hone_iff : ∀ j : Fin (2 * r + 1), y (j, i) = 1 ↔ y (j, i) ≠ 0 :=
      fun j ↦ finTwo_eq_one_iff_ne_zero (y (j, i))
    have : (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) = 1).card ≤ r := by
      simpa only [hone_iff, hzero] using hi
    simp [majorityDecode, hzero, not_lt.mpr this]
  ·
    have hzero_iff : ∀ j : Fin (2 * r + 1), y (j, i) ≠ 1 ↔ ¬ y (j, i) = 1 :=
      fun _ ↦ Iff.rfl
    have hzeros :
        (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ ¬ y (j, i) = 1).card ≤ r := by
      simpa only [hzero_iff, hone] using hi
    have hpartition := Finset.card_filter_add_card_filter_not
      (s := (Finset.univ : Finset (Fin (2 * r + 1))))
      (fun j ↦ y (j, i) = 1)
    simp only [Finset.card_univ, Fintype.card_fin] at hpartition
    have hmany : r <
        (Finset.univ.filter fun j : Fin (2 * r + 1) ↦ y (j, i) = 1).card := by
      omega
    simp [majorityDecode, hone, hmany]

private theorem repetitionEncode_separated (r : ℕ) {k : ℕ}
    {x x' : BinaryWord k} (hxx' : x ≠ x') :
    2 * r + 1 ≤ hammingDist (repetitionEncode r x) (repetitionEncode r x') := by
  classical
  obtain ⟨i, hi⟩ := Function.ne_iff.mp hxx'
  let s : Finset (Fin (2 * r + 1) × Fin k) :=
    Finset.univ.filter fun p ↦ repetitionEncode r x p ≠ repetitionEncode r x' p
  have hsub : Finset.univ.image (fun j : Fin (2 * r + 1) ↦ (j, i)) ⊆ s := by
    intro p hp
    simp only [Finset.mem_image, Finset.mem_univ, true_and] at hp
    obtain ⟨j, rfl⟩ := hp
    simp [s, repetitionEncode, hi]
  calc
    2 * r + 1 = (Finset.univ.image (fun j : Fin (2 * r + 1) ↦ (j, i))).card := by
      rw [Finset.card_image_of_injective _ (fun _ _ h ↦ congrArg Prod.fst h)]
      simp
    _ ≤ s.card := Finset.card_le_card hsub
    _ = hammingDist (repetitionEncode r x) (repetitionEncode r x') := rfl

private theorem repetitionEncode_unique_nearby (r : ℕ) {k : ℕ}
    (y : Fin (2 * r + 1) × Fin k → Fin 2) {x x' : BinaryWord k}
    (hx : hammingDist y (repetitionEncode r x) ≤ r)
    (hx' : hammingDist y (repetitionEncode r x') ≤ r) : x = x' := by
  by_contra hne
  have hsep := repetitionEncode_separated r hne
  have htri := hammingDist_triangle
    (repetitionEncode r x) y (repetitionEncode r x')
  rw [hammingDist_comm (repetitionEncode r x) y] at htri
  omega

/-- Decode a received repeated word by selecting its unique message within `r`
errors, when such a message exists. -/
noncomputable def repetitionDecode (r k : ℕ)
    (y : Fin (2 * r + 1) × Fin k → Fin 2) : BinaryWord k :=
  if h : ∃ x : BinaryWord k, hammingDist y (repetitionEncode r x) ≤ r then
    Classical.choose h
  else 0

/-- Repeating a binary message `2r+1` times and decoding by the unique nearby
message recovers it after any `r` corruptions. -/
theorem repetitionDecode_correct (r k : ℕ) (x : BinaryWord k)
    (y : Fin (2 * r + 1) × Fin k → Fin 2)
    (hy : hammingDist y (repetitionEncode r x) ≤ r) :
    repetitionDecode r k y = x := by
  classical
  let h : ∃ x' : BinaryWord k, hammingDist y (repetitionEncode r x') ≤ r := ⟨x, hy⟩
  rw [repetitionDecode, dif_pos h]
  exact repetitionEncode_unique_nearby r y (Classical.choose_spec h) hy

/-! ## Codes from separated codebooks -/

/-- A decoder that selects a message whose codeword is within `r` errors,
when such a message exists. -/
noncomputable def separatedCodeDecode {k n : ℕ} (r : ℕ)
    (encode : BinaryWord k → BinaryWord n) (y : BinaryWord n) : BinaryWord k :=
  if h : ∃ x : BinaryWord k, hammingDist y (encode x) ≤ r then
    Classical.choose h
  else 0

private theorem separatedCode_unique_nearby {k n r : ℕ}
    (encode : BinaryWord k → BinaryWord n)
    (hsep : ∀ x x', x ≠ x' → 2 * r < hammingDist (encode x) (encode x'))
    (y : BinaryWord n) {x x' : BinaryWord k}
    (hx : hammingDist y (encode x) ≤ r)
    (hx' : hammingDist y (encode x') ≤ r) : x = x' := by
  by_contra hne
  have hfar := hsep x x' hne
  have htri := hammingDist_triangle (encode x) y (encode x')
  rw [hammingDist_comm (encode x) y] at htri
  omega

/-- An encoding whose distinct codewords are more than `2r` apart admits a
decoder correcting every pattern of at most `r` Hamming errors. -/
noncomputable def errorCorrectingCodeOfSeparated {k n r : ℕ}
    (encode : BinaryWord k → BinaryWord n)
    (hsep : ∀ x x', x ≠ x' → 2 * r < hammingDist (encode x) (encode x')) :
    ErrorCorrectingCode k n r where
  encode := encode
  decode := separatedCodeDecode r encode
  corrects := by
    intro x y hy
    let h : ∃ x' : BinaryWord k, hammingDist y (encode x') ≤ r := ⟨x, hy⟩
    rw [separatedCodeDecode, dif_pos h]
    exact separatedCode_unique_nearby encode hsep y (Classical.choose_spec h) hy

end NumStability.HDP.Coding
