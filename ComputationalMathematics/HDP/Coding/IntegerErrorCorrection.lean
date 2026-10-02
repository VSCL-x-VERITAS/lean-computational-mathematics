import ComputationalMathematics.HDP.Coding.ErrorCorrection

/-!
# Binary codes at integer error thresholds

For a negative threshold, no received word satisfies the Hamming-distance
premise. This extends the natural-threshold API without changing its contracts.
-/

namespace NumStability.HDP.Coding

/-- A particular decoder corrects `r` errors for an integer-parameter
encoder when it recovers every message from every received word within
Hamming distance `r` of that message's encoding. -/
def IntegerCorrectsErrors {k n : ℤ} (r : ℤ)
    (E : BinaryWord k.toNat → BinaryWord n.toNat)
    (D : BinaryWord n.toNat → BinaryWord k.toNat) : Prop :=
  ∀ (x : BinaryWord k.toNat) (y : BinaryWord n.toNat),
    (hammingDist y (E x) : ℤ) ≤ r → D y = x

/-- An encoder is an integer-parameter error-correcting code when some
decoder corrects the prescribed number of errors. -/
def IntegerIsErrorCorrectingCode {k n : ℤ} (r : ℤ)
    (E : BinaryWord k.toNat → BinaryWord n.toNat) : Prop :=
  ∃ D : BinaryWord n.toNat → BinaryWord k.toNat,
    IntegerCorrectsErrors r E D

/-- The codebook (also called the image code) of an encoder. -/
def integerCodebook {k n : ℤ}
    (E : BinaryWord k.toNat → BinaryWord n.toNat) :
    Set (BinaryWord n.toNat) :=
  Set.range E

/-- A codeword is an element of the encoder's codebook. -/
def IntegerIsCodeword {k n : ℤ}
    (E : BinaryWord k.toNat → BinaryWord n.toNat)
    (w : BinaryWord n.toNat) : Prop :=
  w ∈ integerCodebook E

/-- An encoder/decoder pair at an integer error threshold. -/
structure IntegerErrorCorrectingCode (k n r : ℤ) where
  encode : BinaryWord k.toNat → BinaryWord n.toNat
  decode : BinaryWord n.toNat → BinaryWord k.toNat
  corrects : ∀ (x : BinaryWord k.toNat) (y : BinaryWord n.toNat),
    (hammingDist y (encode x) : ℤ) ≤ r → decode y = x

theorem IntegerErrorCorrectingCode.correctsErrors {k n r : ℤ}
    (C : IntegerErrorCorrectingCode k n r) :
    IntegerCorrectsErrors r C.encode C.decode :=
  C.corrects

theorem IntegerErrorCorrectingCode.isErrorCorrectingCode {k n r : ℤ}
    (C : IntegerErrorCorrectingCode k n r) :
    IntegerIsErrorCorrectingCode r C.encode :=
  ⟨C.decode, C.corrects⟩

/-- The image of the integer-parameter encoder is its codebook. -/
def IntegerErrorCorrectingCode.codebook {k n r : ℤ}
    (C : IntegerErrorCorrectingCode k n r) : Set (BinaryWord n.toNat) :=
  integerCodebook C.encode

end NumStability.HDP.Coding
