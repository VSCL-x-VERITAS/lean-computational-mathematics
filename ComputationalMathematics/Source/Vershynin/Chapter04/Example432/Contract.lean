import ComputationalMathematics.HDP.Coding.GeneralRepetition

/-!
# Vershynin Chapter 4, Example 4.3.2
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Example 4.3.2: over any finite nonempty alphabet, after
repeating a message `2r+1` times, coordinatewise majority decoding recovers it
from any received word with at most `r` corrupted letters. -/
theorem hdp_04_example_4_3_2
    {α : Type*} [Fintype α] [Nonempty α] [DecidableEq α]
    (r k : ℕ) (x : NumStability.HDP.Coding.AlphabetWord α k)
    (y : Fin (2 * r + 1) × Fin k → α)
    (hy : hammingDist y
      (NumStability.HDP.Coding.generalRepetitionEncode r x) ≤ r) :
    NumStability.HDP.Coding.generalMajorityDecode r k y = x :=
  NumStability.HDP.Coding.generalMajorityDecode_correct r k x y hy

end NumStability.HDP.Contract
