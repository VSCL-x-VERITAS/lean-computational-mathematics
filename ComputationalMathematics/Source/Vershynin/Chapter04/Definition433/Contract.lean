import ComputationalMathematics.HDP.Coding.IntegerErrorCorrection

/-!
# Vershynin Chapter 4, Definition 4.3.3
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Definition 4.3.3: an arbitrary encoder `E` can correct `r`
errors exactly when there is a decoder recovering every message from every
word at Hamming distance at most `r`.  Such an encoder is an error-correcting
code; its range is its code/codebook, and the members of that range are its
codewords. Integer string lengths must be nonnegative, while the integer error
threshold remains unrestricted. -/
theorem hdp_04_definition_4_3_3 (k n r : ℤ)
    (_hk : 0 ≤ k) (_hn : 0 ≤ n)
    (E : NumStability.HDP.Coding.BinaryWord k.toNat →
      NumStability.HDP.Coding.BinaryWord n.toNat)
    (D : NumStability.HDP.Coding.BinaryWord n.toNat →
      NumStability.HDP.Coding.BinaryWord k.toNat) :
    (NumStability.HDP.Coding.IntegerCorrectsErrors r E D ↔
      ∀ (x : NumStability.HDP.Coding.BinaryWord k.toNat)
          (y : NumStability.HDP.Coding.BinaryWord n.toNat),
        (hammingDist y (E x) : ℤ) ≤ r → D y = x) ∧
    (NumStability.HDP.Coding.IntegerIsErrorCorrectingCode r E ↔
      ∃ D' : NumStability.HDP.Coding.BinaryWord n.toNat →
          NumStability.HDP.Coding.BinaryWord k.toNat,
        ∀ (x : NumStability.HDP.Coding.BinaryWord k.toNat)
            (y : NumStability.HDP.Coding.BinaryWord n.toNat),
          (hammingDist y (E x) : ℤ) ≤ r → D' y = x) ∧
    NumStability.HDP.Coding.integerCodebook E = Set.range E ∧
    (∀ w : NumStability.HDP.Coding.BinaryWord n.toNat,
      NumStability.HDP.Coding.IntegerIsCodeword E w ↔ w ∈ Set.range E) := by
  exact ⟨Iff.rfl, Iff.rfl, rfl, fun _ => Iff.rfl⟩

end NumStability.HDP.Contract
