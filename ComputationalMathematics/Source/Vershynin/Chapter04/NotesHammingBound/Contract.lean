import ComputationalMathematics.HDP.Coding.HammingNotes

/-!
# Vershynin Chapter 4 notes: Hamming bound
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- The literal plus-sign definition printed in the Chapter 4 notes.  This
wrapper deliberately names the source formula without identifying it with
Mathlib's standard two-minus-sign binary entropy. -/
theorem hdp_04_notes_binary_entropy_printed_definition (x : ℝ) :
    NumStability.HDP.Coding.printedBinaryEntropy x =
      -x * Real.logb 2 x + (1 - x) * Real.logb 2 (1 - x) := by
  rfl

/-- The Chapter 4 notes' Hamming bound, preserving exactly the preceding
printed plus-sign definition
`h(t) = -t log₂ t + (1-t) log₂(1-t)` rather than replacing it silently by
the standard binary entropy. -/
theorem hdp_04_notes_hamming_bound
    {k n r : ℕ} (C : NumStability.HDP.Coding.ErrorCorrectingCode k n r) :
    NumStability.HDP.Coding.codingRate k n ≤
      1 - NumStability.HDP.Coding.printedBinaryEntropy
        (NumStability.HDP.Coding.errorFraction r n) := by
  exact C.codingRate_le_one_sub_printedBinaryEntropy

end NumStability.HDP.Contract
