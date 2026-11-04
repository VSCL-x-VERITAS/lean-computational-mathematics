import ComputationalMathematics.HDP.Coding.HammingCovering

/-!
# Vershynin Chapter 4, Exercise 4.2.16
-/

noncomputable section

open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Exercise 4.2.16: the covering and packing numbers of the binary Hamming
cube are bounded by the reciprocal volumes of Hamming balls.  Multiplying by
the positive binomial sums avoids division in `ℕ∞` and is equivalent to the
three displayed inequalities in the source. -/
theorem hdp_04_exercise_4_2_16 (n m : ℕ) (hm : m ≤ n) :
    (2 ^ n : ℕ∞) ≤
        NumStability.HDP.Coding.binaryHammingCoveringNumber n m *
          (∑ j ∈ Finset.range (m + 1), n.choose j) ∧
      NumStability.HDP.Coding.binaryHammingCoveringNumber n m ≤
        NumStability.HDP.Coding.binaryHammingPackingNumberAt n m ∧
      NumStability.HDP.Coding.binaryHammingPackingNumberAt n m *
          (∑ j ∈ Finset.range (m / 2 + 1), n.choose j) ≤
        (2 ^ n : ℕ∞) := by
  have _ := hm
  simpa [NumStability.HDP.Coding.hammingBallVolume] using
    NumStability.HDP.Coding.binaryHamming_covering_packing_binomial_bounds n m

end NumStability.HDP.Contract
