import ComputationalMathematics.HDP.Coding.HammingNotes

/-!
# Vershynin Chapter 4 notes: Hamming bound
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Compatibility identity for the totalized implementation of the literal
plus-sign formula. The ordinary source-domain correspondence is
`hdp_04_notes_binary_entropy_ordinary_domain`; endpoint and exterior values of
this identity are implementation conventions, not claims printed in the book. -/
theorem hdp_04_notes_binary_entropy_printed_definition (x : ℝ) :
    NumStability.HDP.Coding.printedBinaryEntropy x =
      -x * Real.logb 2 x + (1 - x) * Real.logb 2 (1 - x) := by
  rfl

/-- Compatibility extension of the literal plus-sign Hamming bound.
The ordinary source-domain correspondence is
`hdp_04_notes_hamming_bound_ordinary_domain`; totalized boundary cases are
implementation conventions and do not settle the book's endpoint intent. -/
theorem hdp_04_notes_hamming_bound
    {k n r : ℕ} (C : NumStability.HDP.Coding.ErrorCorrectingCode k n r) :
    NumStability.HDP.Coding.codingRate k n ≤
      1 - NumStability.HDP.Coding.printedBinaryEntropy
        (NumStability.HDP.Coding.errorFraction r n) := by
  exact C.codingRate_le_one_sub_printedBinaryEntropy

/-- The literal printed definition on the complete ordinary real-logarithm
domain. The endpoint and exterior extensions are not source conventions. -/
theorem hdp_04_notes_binary_entropy_ordinary_domain
    (x : ℝ) (_hx : 0 < x) (_hx1 : x < 1) :
    NumStability.HDP.Coding.printedBinaryEntropy x =
      -x * Real.logb 2 x + (1 - x) * Real.logb 2 (1 - x) := by
  exact hdp_04_notes_binary_entropy_printed_definition x


/-- The literal universal Hamming bound on the complete ordinary quotient
and logarithm domain. Empty-message codes remain included; endpoint extensions
and an emended entropy formula are separate statements. -/
theorem hdp_04_notes_hamming_bound_ordinary_domain
    {k n r : ℕ} (C : NumStability.HDP.Coding.ErrorCorrectingCode k n r)
    (_hδpos : 0 < NumStability.HDP.Coding.errorFraction r n)
    (_hδone : NumStability.HDP.Coding.errorFraction r n < 1) :
    NumStability.HDP.Coding.codingRate k n ≤
      1 - NumStability.HDP.Coding.printedBinaryEntropy
        (NumStability.HDP.Coding.errorFraction r n) := by
  exact C.codingRate_le_one_sub_printedBinaryEntropy

end NumStability.HDP.Contract
