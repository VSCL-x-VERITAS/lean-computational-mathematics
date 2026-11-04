import ComputationalMathematics.HDP.Coding.GilbertVarshamov

/-!
# A fixed binary code of length thirty

The finite packing bound constructs a single uniform encoder and decoder for
all twelve-bit messages and all corruptions of at most two bits.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Coding

private theorem binaryBallVolumeThirtyFour : hammingBallVolume 30 4 = 31931 := by
  decide

/-- A binary code from twelve bits to thirty bits correcting two Hamming
errors. This statement concerns bits; it does not encode an English phrase. -/
noncomputable def binaryCode12To30Correcting2 : ErrorCorrectingCode 12 30 2 := by
  have hnum : 2 ^ 12 * hammingBallVolume 30 4 ≤ 2 ^ 30 := by
    rw [binaryBallVolumeThirtyFour]
    norm_num
  have hnat := pow_two_le_packingNumberAt_toNat_mul_hammingBallVolume 30 4
  have hpackNat : 2 ^ 12 ≤ (binaryHammingPackingNumberAt 30 4).toNat :=
    Nat.le_of_mul_le_mul_right (hnum.trans hnat) (hammingBallVolume_pos 30 4)
  have hsame : binaryHammingPackingNumberAt 30 4 =
      binaryHammingPackingNumber 30 2 := rfl
  have hpack : ENat.card (BinaryWord 12) ≤ binaryHammingPackingNumber 30 2 := by
    rw [ENat.card_eq_coe_fintype_card, card_binaryWord]
    calc
      (2 ^ 12 : ℕ∞) ≤ ((binaryHammingPackingNumberAt 30 4).toNat : ℕ∞) :=
        ENat.coe_le_coe.mpr hpackNat
      _ ≤ binaryHammingPackingNumber 30 2 := by
        rw [← hsame]
        exact ENat.coe_toNat_le_self _
  exact errorCorrectingCodeOfPacking hpack

end NumStability.HDP.Coding
