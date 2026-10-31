import ComputationalMathematics.HDP.Coding.HammingBinomialEstimate
import ComputationalMathematics.HDP.Coding.HammingCovering
import Mathlib.Analysis.SpecialFunctions.Log.Base

/-!
# The elementary Gilbert--Varshamov code bound

This file packages the exact finite Hamming-ball argument separately from the
source-facing Chapter 4 contract.
-/

noncomputable section

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Coding

/-- The packing number at integer separation `m` is large enough that its
cardinality times the radius-`m` Hamming-ball volume covers the cube. -/
theorem pow_two_le_packingNumberAt_toNat_mul_hammingBallVolume (n m : ℕ) :
    2 ^ n ≤ (binaryHammingPackingNumberAt n m).toNat *
      hammingBallVolume n m := by
  have hbounds := binaryHamming_covering_packing_binomial_bounds n m
  have hfinite : binaryHammingPackingNumberAt n m ≠ ⊤ := by
    apply ne_of_lt
    exact (Metric.packingNumber_le_encard_self
      (ε := (m : ℝ≥0))
      (Set.univ : Set (BinaryHammingSpace n))).trans_lt (by simp)
  have hmono : binaryHammingCoveringNumber n m * hammingBallVolume n m ≤
      binaryHammingPackingNumberAt n m * hammingBallVolume n m := by
    simpa [mul_comm] using
      (mul_le_mul_right hbounds.2.1 (hammingBallVolume n m : ℕ∞))
  have hENat : (2 ^ n : ℕ∞) ≤
      binaryHammingPackingNumberAt n m * hammingBallVolume n m :=
    hbounds.1.trans hmono
  rw [← ENat.coe_toNat hfinite] at hENat
  exact ENat.coe_le_coe.mp (by simpa only [Nat.cast_mul] using hENat)

/-- The real logarithmic length condition implies the power comparison used
to cancel the Hamming-ball estimate. -/
private theorem two_pow_mul_hammingBall_bound_le
    {k n m : ℕ} (hm : 0 < m) (hmn : m ≤ n)
    (hlen : (k : ℝ) + (m : ℝ) *
        Real.logb 2 (Real.exp 1 * (n : ℝ) / (m : ℝ)) ≤ (n : ℝ)) :
    (2 ^ k : ℝ) * (hammingBallVolume n m : ℝ) ≤ (2 ^ n : ℝ) := by
  let a : ℝ := Real.exp 1 * (n : ℝ) / (m : ℝ)
  have hn : 0 < n := lt_of_lt_of_le hm hmn
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hmR : (0 : ℝ) < m := by exact_mod_cast hm
  have ha : 0 < a := by
    dsimp [a]
    positivity
  have hvolume := hammingBallVolume_cast_le_exp_mul_div_pow hm hmn
  change (hammingBallVolume n m : ℝ) ≤ a ^ m at hvolume
  have hrpow := Real.rpow_le_rpow_of_exponent_le
    (show (1 : ℝ) ≤ 2 by norm_num) hlen
  have hpower : (2 ^ k : ℝ) * a ^ m ≤ (2 ^ n : ℝ) := by
    rw [Real.rpow_add (by norm_num : (0 : ℝ) < 2),
      Real.rpow_natCast, Real.rpow_natCast] at hrpow
    have hlogpow : (2 : ℝ) ^ ((m : ℝ) * Real.logb 2 a) = a ^ m := by
      rw [mul_comm, Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2),
        Real.rpow_logb (by norm_num) (by norm_num) ha,
        Real.rpow_natCast]
    rw [hlogpow] at hrpow
    exact hrpow
  exact (mul_le_mul_of_nonneg_left hvolume (by positivity)).trans hpower

/-- Corrected elementary Gilbert--Varshamov guarantee.  The condition
`2r ≤ n` is required by the radius-`2r` Hamming-ball estimate. -/
noncomputable def errorCorrectingCodeOfLengthLogBound
    {k n r : ℕ} (hr : 0 < r) (h2r : 2 * r ≤ n)
    (hlen : (k : ℝ) + 2 * (r : ℝ) *
        Real.logb 2 (Real.exp 1 * (n : ℝ) / (2 * (r : ℝ))) ≤ (n : ℝ)) :
    ErrorCorrectingCode k n r := by
  have hm : 0 < 2 * r := Nat.mul_pos (by norm_num) hr
  have harg : Real.exp 1 * (n : ℝ) / ((2 * r : ℕ) : ℝ) =
      Real.exp 1 * (n : ℝ) / (2 * (r : ℝ)) := by norm_num
  have hlen' : (k : ℝ) + ((2 * r : ℕ) : ℝ) *
      Real.logb 2 (Real.exp 1 * (n : ℝ) / ((2 * r : ℕ) : ℝ)) ≤ (n : ℝ) := by
    norm_num at harg ⊢
    simpa [harg] using hlen
  have hreal := two_pow_mul_hammingBall_bound_le hm h2r hlen'
  have hnat := pow_two_le_packingNumberAt_toNat_mul_hammingBallVolume n (2 * r)
  have hvolumePos : (0 : ℝ) < hammingBallVolume n (2 * r) := by
    exact_mod_cast hammingBallVolume_pos n (2 * r)
  have hpackNat : 2 ^ k ≤
      (binaryHammingPackingNumberAt n (2 * r)).toNat := by
    have hnatReal : (2 ^ n : ℝ) ≤
        (binaryHammingPackingNumberAt n (2 * r)).toNat *
          (hammingBallVolume n (2 * r) : ℝ) := by exact_mod_cast hnat
    exact_mod_cast le_of_mul_le_mul_right (hreal.trans hnatReal) hvolumePos
  have hsame : binaryHammingPackingNumberAt n (2 * r) =
      binaryHammingPackingNumber n r := rfl
  have hfinite : binaryHammingPackingNumber n r ≠ ⊤ := by
    apply ne_of_lt
    exact (Metric.packingNumber_le_encard_self
      (ε := ((2 * r : ℕ) : ℝ≥0))
      (Set.univ : Set (BinaryHammingSpace n))).trans_lt (by simp)
  have hpack : ENat.card (BinaryWord k) ≤ binaryHammingPackingNumber n r := by
    rw [ENat.card_eq_coe_fintype_card, card_binaryWord]
    rw [← ENat.coe_toNat hfinite]
    exact ENat.coe_le_coe.mpr (by simpa [hsame] using hpackNat)
  exact errorCorrectingCodeOfPacking hpack

end NumStability.HDP.Coding
