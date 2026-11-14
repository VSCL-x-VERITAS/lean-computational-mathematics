/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), I.5, printed pages 16–17 and 19.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.SymmetricProductTarget
import ComputationalMathematics.Source.Bhatia.Chapter01.SymmetricMultiplicityTarget
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.Defs

/-!
The prescribed normalized vector family in the existing algebraic tensor
quotient. This is a function into PiTensorProduct, not an OrthonormalBasis
and not yet a family bundled in the symmetric submodule. Its membership,
product Hilbert interpretation, orthonormality and spanning remain obligations.
No tensor Hilbert structure, correspondence or invariant operator is assumed.

Every ambient size n is retained, every degree k is positive, and indices
belong to the existing nondecreasingIndexSet. Fin labels are zero based.
There is no bound k ≤ n and no positive-dimension hypothesis.
The indexing is compatible with the existing lexicographic relation; an ordered
enumeration is a separate construction.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- The source family I ↦ m(I)^(-1/2) e_I, with e_I formed using the
existing unsigned sum and its single 1/sqrt(k!) coefficient. The multiplicity
factor is the existing factorial product of actual occurrence counts. -/
def normalizedSymmetricVectorFamily {H : Type u} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H] {n : ℕ}
    (e : OrthonormalBasis (Fin n) ℂ H) (k : ℕ) (hk : 0 < k) :
    nondecreasingIndexSet n k → PiTensorProduct ℂ (fun _ : Fin k => H) :=
  fun I =>
    (((Real.sqrt (tupleMultiplicityFactor I.val : ℝ))⁻¹ : ℝ) : ℂ) •
      normalizedSymmetricProduct k hk (fun r : Fin k => e (I.val r))

/-- The later G-indexed meaning of A[I|J]. It retains each occurrence of
row I(r) and column J(s), even when indices repeat. It need not be a submatrix
in the source's strict-index sense. No sorting or deduplication is performed. -/
def repeatedIndexMatrix {n k : ℕ} (_hk : 0 < k)
    (A : Matrix (Fin n) (Fin n) ℂ)
    (I J : nondecreasingIndexSet n k) : Matrix (Fin k) (Fin k) ℂ :=
  Matrix.submatrix A I.val J.val

/-- Proof-free entry correspondence obligation for the repeated-index helper.
This is a proposition, not an asserted theorem or assumed entry formula for
an induced symmetric operator. -/
def repeatedIndexMatrixDefinition : Prop :=
  ∀ (n k : ℕ) (hk : 0 < k) (A : Matrix (Fin n) (Fin n) ℂ)
    (I J : nondecreasingIndexSet n k) (r s : Fin k),
    repeatedIndexMatrix hk A I J r s = A (I.val r) (J.val s)

end

end NumStability.Bhatia.Chapter01.Targets
