import ComputationalMathematics.HDP.Coding.PackingCode
import Mathlib.Analysis.SpecialFunctions.Log.Base

/-!
# Packing bound forced by error correction
-/

open Function Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Coding

/-- Two words at Hamming distance at most `2r` have a common word within
distance `r` of both. -/
theorem exists_hamming_midpoint_of_dist_le_two_mul
    {n r : ℕ} (x z : BinaryWord n) (hdist : hammingDist x z ≤ 2 * r) :
    ∃ y : BinaryWord n, hammingDist y x ≤ r ∧ hammingDist y z ≤ r := by
  classical
  let S : Finset (Fin n) := Finset.univ.filter fun i ↦ x i ≠ z i
  have hScard : S.card = hammingDist x z := by rfl
  obtain ⟨T, hTS, hTcard⟩ :=
    Finset.exists_subset_card_eq (show min r S.card ≤ S.card from min_le_right _ _)
  let y : BinaryWord n := fun i ↦ if i ∈ T then z i else x i
  have hyx : hammingDist y x = T.card := by
    unfold hammingDist
    congr 1
    ext i
    by_cases hi : i ∈ T
    · have hiS := hTS hi
      simp only [S, Finset.mem_filter, Finset.mem_univ, true_and] at hiS
      simp only [Finset.mem_filter, Finset.mem_univ, true_and, y, hi, if_true]
      constructor
      · intro _
        trivial
      · intro _ h
        exact hiS h.symm
    · simp [y, hi]
  have hyz : hammingDist y z = (S \ T).card := by
    unfold hammingDist
    congr 1
    ext i
    by_cases hi : i ∈ T
    · simp [y, hi]
    · simp only [S, Finset.mem_filter, Finset.mem_univ, true_and,
        Finset.mem_sdiff, hi, not_false_eq_true, and_true]
      simp [y, hi]
  refine ⟨y, ?_, ?_⟩
  · rw [hyx, hTcard]
    exact min_le_left _ _
  · rw [hyz, Finset.card_sdiff_of_subset hTS, hTcard, hScard]
    omega

/-- An error-correcting encoder is injective. -/
theorem ErrorCorrectingCode.encode_injective {k n r : ℕ}
    (C : ErrorCorrectingCode k n r) : Function.Injective C.encode := by
  intro x z hxz
  have hx : C.decode (C.encode x) = x :=
    C.corrects x (C.encode x) (by simp)
  have hz : C.decode (C.encode z) = z :=
    C.corrects z (C.encode z) (by simp)
  rw [← hx, ← hz, hxz]

/-- Distinct codewords of a code correcting `r` errors are strictly farther
than `2r` apart. -/
theorem ErrorCorrectingCode.two_mul_lt_hammingDist_encode
    {k n r : ℕ} (C : ErrorCorrectingCode k n r)
    {x z : BinaryWord k} (hxz : x ≠ z) :
    2 * r < hammingDist (C.encode x) (C.encode z) := by
  by_contra hfar
  have hle : hammingDist (C.encode x) (C.encode z) ≤ 2 * r :=
    Nat.le_of_not_gt hfar
  obtain ⟨y, hyx, hyz⟩ :=
    exists_hamming_midpoint_of_dist_le_two_mul (C.encode x) (C.encode z) hle
  have hx := C.corrects x y hyx
  have hz := C.corrects z y hyz
  exact hxz (hx.symm.trans hz)

/-- The codebook of a code correcting `r` errors is a `2r`-separated subset
of the binary Hamming cube. -/
theorem ErrorCorrectingCode.codebook_isSeparated
    {k n r : ℕ} (C : ErrorCorrectingCode k n r) :
    Metric.IsSeparated (((2 * r : ℕ) : ℝ≥0) : ℝ≥0∞)
      (Set.range fun x : BinaryWord k ↦
        Hamming.toHamming (C.encode x) : Set (BinaryHammingSpace n)) := by
  rintro _ ⟨x, rfl⟩ _ ⟨z, rfl⟩ hne
  have hxz : x ≠ z := by
    intro h
    subst z
    exact hne rfl
  have hdist := C.two_mul_lt_hammingDist_encode hxz
  rw [edist_nndist, Hamming.nndist_eq_hammingDist]
  exact_mod_cast hdist

/-- Converse packing bound: any code correcting `r` errors has at most the
packing number of the binary Hamming cube at separation `2r` codewords. -/
theorem ErrorCorrectingCode.card_messages_le_packingNumber
    {k n r : ℕ} (C : ErrorCorrectingCode k n r) :
    ENat.card (BinaryWord k) ≤ binaryHammingPackingNumber n r := by
  let E : BinaryWord k → BinaryHammingSpace n := fun x ↦ Hamming.toHamming (C.encode x)
  have hEinj : Function.Injective E := by
    intro x z h
    apply C.encode_injective
    simpa using congrArg Hamming.ofHamming h
  have hsep : Metric.IsSeparated (((2 * r : ℕ) : ℝ≥0) : ℝ≥0∞) (Set.range E) := by
    simpa [E] using C.codebook_isSeparated
  calc
    ENat.card (BinaryWord k) ≤ (Set.range E).encard := hEinj.encard_range
    _ ≤ Metric.packingNumber ((2 * r : ℕ) : ℝ≥0)
        (Set.univ : Set (BinaryHammingSpace n)) :=
      hsep.encard_le_packingNumber (Set.subset_univ _)
    _ = binaryHammingPackingNumber n r := rfl

/-- Logarithmic form of the converse packing bound. -/
theorem ErrorCorrectingCode.messageBits_le_logb_packingNumber
    {k n r : ℕ} (C : ErrorCorrectingCode k n r) :
    (k : ℝ) ≤ Real.logb 2 (binaryHammingPackingNumber n r).toNat := by
  let P := binaryHammingPackingNumber n r
  have hPtop : P ≠ ⊤ := by
    apply ne_of_lt
    exact (Metric.packingNumber_le_encard_self
      (ε := ((2 * r : ℕ) : ℝ≥0))
      (Set.univ : Set (BinaryHammingSpace n))).trans_lt (by simp)
  have hPzero : P ≠ 0 := by
    exact ne_of_gt (Metric.packingNumber_pos_iff.mpr Set.univ_nonempty)
  have hPnat_pos : 0 < P.toNat := by
    exact Nat.pos_of_ne_zero (by simp [ENat.toNat_eq_zero, hPzero, hPtop])
  have hcard := C.card_messages_le_packingNumber
  have hnat : 2 ^ k ≤ P.toNat := by
    rw [ENat.card_eq_coe_fintype_card, Fintype.card_fun, Fintype.card_fin,
      Fintype.card_fin] at hcard
    change (↑(2 ^ k) : ℕ∞) ≤ P at hcard
    rw [← ENat.coe_toNat hPtop] at hcard
    exact ENat.coe_le_coe.mp hcard
  apply (Real.le_logb_iff_rpow_le (by norm_num) (by exact_mod_cast hPnat_pos)).2
  rw [Real.rpow_natCast]
  exact_mod_cast hnat

end NumStability.HDP.Coding
