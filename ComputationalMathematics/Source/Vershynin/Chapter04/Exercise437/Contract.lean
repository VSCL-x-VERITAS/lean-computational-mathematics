import ComputationalMathematics.HDP.Coding.HammingConverse

/-!
# Vershynin Chapter 4, Exercise 4.3.7
-/

noncomputable section

open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Exercise 4.3.7 (Optimality).  For every code correcting `r` errors,
its codebook is bounded by the `2r`-packing number, its radius-`r` Hamming
balls satisfy the sphere-packing count, and (when `0 < r ≤ n`) its rate
satisfies the literal bound from the exercise
`R ≤ 1 - δ log₂(1/δ)`, where `δ = r/n`. -/
theorem hdp_04_exercise_4_3_7_converse
    {k n r : ℕ} (C : NumStability.HDP.Coding.ErrorCorrectingCode k n r)
    (hk : 0 < k) (hr : 0 < r) :
    Metric.IsSeparated (((2 * r : ℕ) : ℝ≥0) : ℝ≥0∞)
        (Set.range fun x : NumStability.HDP.Coding.BinaryWord k ↦
          Hamming.toHamming (C.encode x) :
            Set (NumStability.HDP.Coding.BinaryHammingSpace n)) ∧
      ENat.card (NumStability.HDP.Coding.BinaryWord k) ≤
        NumStability.HDP.Coding.binaryHammingPackingNumber n r ∧
      2 ^ k * NumStability.HDP.Coding.hammingBallVolume n r ≤ 2 ^ n ∧
      NumStability.HDP.Coding.codingRate k n ≤
        1 - NumStability.HDP.Coding.errorFraction r n *
          Real.logb 2 (1 / NumStability.HDP.Coding.errorFraction r n) := by
  let x₀ : NumStability.HDP.Coding.BinaryWord k := 0
  let x₁ : NumStability.HDP.Coding.BinaryWord k := fun _ ↦ 1
  have hx : x₀ ≠ x₁ := by
    intro heq
    have hcoord := congrFun heq ⟨0, hk⟩
    simp [x₀, x₁] at hcoord
  have hdist := C.two_mul_lt_hammingDist_encode hx
  have hdist_le :
      hammingDist (C.encode x₀) (C.encode x₁) ≤ n := by
    simpa only [Fintype.card_fin] using
      (hammingDist_le_card_fintype (x := C.encode x₀) (y := C.encode x₁))
  have hrn : r ≤ n := by omega
  exact ⟨C.codebook_isSeparated, C.card_messages_le_packingNumber,
    C.pow_two_mul_hammingBallVolume_le,
    C.codingRate_le_one_sub_errorFraction_mul_logb hr hrn⟩

end NumStability.HDP.Contract
