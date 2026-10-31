import ComputationalMathematics.HDP.Coding.HammingBalls
import ComputationalMathematics.HDP.Coding.PackingCode

/-!
# Covering and packing bounds for the binary Hamming cube
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Coding

/-- Internal covering number of the binary Hamming cube at integer radius
`m`. -/
noncomputable def binaryHammingCoveringNumber (n m : ℕ) : ℕ∞ :=
  Metric.coveringNumber (m : ℝ≥0)
    (Set.univ : Set (BinaryHammingSpace n))

/-- Packing number of the binary Hamming cube at integer separation `m`. -/
noncomputable def binaryHammingPackingNumberAt (n m : ℕ) : ℕ∞ :=
  Metric.packingNumber (m : ℝ≥0)
    (Set.univ : Set (BinaryHammingSpace n))

private theorem binaryHammingCoveringNumber_ne_top (n m : ℕ) :
    binaryHammingCoveringNumber n m ≠ ⊤ := by
  apply ne_of_lt
  exact (Metric.coveringNumber_le_encard_self
    (ε := (m : ℝ≥0)) (Set.univ : Set (BinaryHammingSpace n))).trans_lt (by simp)

private theorem binaryHammingPackingNumberAt_ne_top (n m : ℕ) :
    binaryHammingPackingNumberAt n m ≠ ⊤ := by
  apply ne_of_lt
  exact (Metric.packingNumber_le_encard_self
    (ε := (m : ℝ≥0)) (Set.univ : Set (BinaryHammingSpace n))).trans_lt (by simp)

/-- The exact binomial-volume bounds of Exercise 4.2.16, written without
division in `ℕ∞`.  Since both Hamming-ball volumes are positive, these are
equivalent to the displayed fractional inequalities in the source. -/
theorem binaryHamming_covering_packing_binomial_bounds (n m : ℕ) :
    (2 ^ n : ℕ∞) ≤
        binaryHammingCoveringNumber n m * hammingBallVolume n m ∧
      binaryHammingCoveringNumber n m ≤
        binaryHammingPackingNumberAt n m ∧
      binaryHammingPackingNumberAt n m * hammingBallVolume n (m / 2) ≤
        (2 ^ n : ℕ∞) := by
  let K : Set (BinaryHammingSpace n) := Set.univ
  let C : Set (BinaryHammingSpace n) :=
    Metric.minimalCover (m : ℝ≥0) K
  let P : Set (BinaryHammingSpace n) :=
    Metric.maximalSeparatedSet (m : ℝ≥0) K
  have hCfin : C.Finite := Metric.finite_minimalCover
  have hPfin : P.Finite := by
    apply Set.encard_lt_top_iff.mp
    rw [Metric.encard_maximalSeparatedSet
      (binaryHammingPackingNumberAt_ne_top n m)]
    exact (binaryHammingPackingNumberAt_ne_top n m).lt_top
  have hCcover : Metric.IsCover (m : ℝ≥0) K C :=
    Metric.isCover_minimalCover (binaryHammingCoveringNumber_ne_top n m)
  have hPsep : Metric.IsSeparated (m : ℝ≥0) P :=
    Metric.isSeparated_maximalSeparatedSet
  have hcoverNat : ∀ y : BinaryWord n, ∃ x ∈ C, hammingDist x y ≤ m := by
    intro y
    obtain ⟨x, hxC, hxy⟩ := hCcover (Set.mem_univ y)
    refine ⟨x, hxC, ?_⟩
    change edist (Hamming.toHamming y) x ≤ ((m : ℝ≥0) : ℝ≥0∞) at hxy
    rw [edist_nndist, Hamming.nndist_eq_hammingDist] at hxy
    simpa [hammingDist_comm] using hxy
  have hsepNat : ∀ x ∈ P, ∀ z ∈ P, x ≠ z → m < hammingDist x z := by
    intro x hx z hz hxz
    have h := hPsep hx hz hxz
    change ((m : ℝ≥0) : ℝ≥0∞) < edist x z at h
    rw [edist_nndist, Hamming.nndist_eq_hammingDist] at h
    exact_mod_cast h
  have hcoverCard :=
    card_le_card_mul_hammingBallVolume_of_cover C hCfin hcoverNat
  have hpackingCard :=
    card_mul_hammingBallVolume_half_le_of_separated P hPfin hsepNat
  have hcoverCast : (2 ^ n : ℕ∞) ≤
      (Set.ncard C : ℕ∞) * hammingBallVolume n m := by
    simpa only [Nat.cast_mul] using ENat.coe_le_coe.mpr hcoverCard
  have hpackingCast : (Set.ncard P : ℕ∞) *
      hammingBallVolume n (m / 2) ≤ (2 ^ n : ℕ∞) := by
    simpa only [Nat.cast_mul] using ENat.coe_le_coe.mpr hpackingCard
  have hCcard : C.encard = binaryHammingCoveringNumber n m := by
    exact Metric.encard_minimalCover (binaryHammingCoveringNumber_ne_top n m)
  have hPcard : P.encard = binaryHammingPackingNumberAt n m := by
    exact Metric.encard_maximalSeparatedSet (binaryHammingPackingNumberAt_ne_top n m)
  rw [hCfin.cast_ncard_eq, hCcard] at hcoverCast
  rw [hPfin.cast_ncard_eq, hPcard] at hpackingCast
  refine ⟨hcoverCast, ?_, hpackingCast⟩
  exact Metric.coveringNumber_le_packingNumber (m : ℝ≥0) K

end NumStability.HDP.Coding
