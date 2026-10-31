import ComputationalMathematics.HDP.Coding.PackingCode
import Mathlib.Analysis.SpecialFunctions.Log.Base

/-!
# Vershynin Chapter 4, Lemma 4.3.4
-/

noncomputable section

open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Lemma 4.3.4: if the base-two logarithm of the packing number
of the binary Hamming cube at separation `2r` is at least `k`, then there is
an `n`-bit encoding of `k`-bit strings which corrects `r` errors. The
source uses positive integer parameters; natural lengths and error counts
also allow the valid zero boundary cases. -/
theorem hdp_04_lemma_4_3_4 (k n r : ℕ)
    (hlog : (k : ℝ) ≤ Real.logb 2
      (NumStability.HDP.Coding.binaryHammingPackingNumber n r).toNat) :
    Nonempty (NumStability.HDP.Coding.ErrorCorrectingCode k n r) := by
  let P := NumStability.HDP.Coding.binaryHammingPackingNumber n r
  have hPtop : P ≠ ⊤ := by
    apply ne_of_lt
    exact (Metric.packingNumber_le_encard_self
      (ε := ((2 * r : ℕ) : ℝ≥0))
      (Set.univ : Set (NumStability.HDP.Coding.BinaryHammingSpace n))).trans_lt (by simp)
  have hPzero : P ≠ 0 := by
    exact ne_of_gt (Metric.packingNumber_pos_iff.mpr Set.univ_nonempty)
  have hPnat_pos : 0 < P.toNat := by
    exact Nat.pos_of_ne_zero (by simp [ENat.toNat_eq_zero, hPzero, hPtop])
  have hrpow : (2 : ℝ) ^ (k : ℝ) ≤ (P.toNat : ℝ) :=
    (Real.le_logb_iff_rpow_le (by norm_num) (by exact_mod_cast hPnat_pos)).mp hlog
  rw [Real.rpow_natCast] at hrpow
  have hnat : 2 ^ k ≤ P.toNat := by exact_mod_cast hrpow
  have hpack : ENat.card (NumStability.HDP.Coding.BinaryWord k) ≤ P := by
    rw [ENat.card_eq_coe_fintype_card, Fintype.card_fun, Fintype.card_fin,
      Fintype.card_fin, ← ENat.coe_toNat hPtop]
    exact ENat.coe_le_coe.mpr hnat
  exact ⟨NumStability.HDP.Coding.errorCorrectingCodeOfPacking hpack⟩

end NumStability.HDP.Contract
