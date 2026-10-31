import ComputationalMathematics.HDP.Coding.IntegerErrorCorrection

/-!
# Vershynin Chapter 4, Definition 4.3.3
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Definition 4.3.3: an arbitrary encoder `E` can correct `r`
errors exactly when there is a decoder recovering every message from every
word at Hamming distance at most `r`.  Such an encoder is an error-correcting
code; its range is its code/codebook, and the members of that range are its
codewords. String lengths are natural numbers, while the integer error
threshold remains unrestricted. -/
theorem hdp_04_definition_4_3_3 (k n : ℕ) (r : ℤ)
    (E : NumStability.HDP.Coding.BinaryWord k →
      NumStability.HDP.Coding.BinaryWord n)
    (D : NumStability.HDP.Coding.BinaryWord n →
      NumStability.HDP.Coding.BinaryWord k) :
    (NumStability.HDP.Coding.IntegerCorrectsErrors (k := (k : ℤ)) (n := (n : ℤ)) r E D ↔
      ∀ (x : NumStability.HDP.Coding.BinaryWord k)
          (y : NumStability.HDP.Coding.BinaryWord n),
        (hammingDist y (E x) : ℤ) ≤ r → D y = x) ∧
    (NumStability.HDP.Coding.IntegerIsErrorCorrectingCode (k := (k : ℤ)) (n := (n : ℤ)) r E ↔
      ∃ D' : NumStability.HDP.Coding.BinaryWord n →
          NumStability.HDP.Coding.BinaryWord k,
        ∀ (x : NumStability.HDP.Coding.BinaryWord k)
            (y : NumStability.HDP.Coding.BinaryWord n),
          (hammingDist y (E x) : ℤ) ≤ r → D' y = x) ∧
    NumStability.HDP.Coding.integerCodebook (k := (k : ℤ)) (n := (n : ℤ)) E = Set.range E ∧
    (∀ w : NumStability.HDP.Coding.BinaryWord n,
      NumStability.HDP.Coding.IntegerIsCodeword (k := (k : ℤ)) (n := (n : ℤ)) E w ↔
        w ∈ Set.range E) := by
  exact ⟨Iff.rfl, Iff.rfl, rfl, fun _ => Iff.rfl⟩

end NumStability.HDP.Contract
