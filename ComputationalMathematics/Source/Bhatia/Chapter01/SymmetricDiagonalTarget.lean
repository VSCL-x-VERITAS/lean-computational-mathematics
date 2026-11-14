/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.SymmetricProductTarget

/-!
# Equal-factor elementary tensors in the symmetric tensor power

Proof-free targets for Bhatia, Matrix Analysis (1997), Exercise I.5.2,
printed page 17 (PDF page 29).

The source asserts that equal-factor elementary tensors belong to the symmetric
subspace, then asks whether they span it. The second target specifies the
selected affirmative answer to that exercise question; it does not attribute
an answer or proof to the printed source. Both targets still require independent
statement review and mathematical proof. The desired span equality is a goal,
never an input assumption.

The ambient space is the actual complex multilinearity quotient. The primitive
equal-factor tensor is unnormalized. The existing symmetric subspace remains
the full span of normalized unsigned permutation sums, with its original
`1 / sqrt(k!)` coefficient. All finite-dimensional complex Hilbert spaces,
positive degrees, and all vectors, including zero, are retained.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- The asserted membership of every actual equal-factor elementary tensor. -/
def diagonalTensorMembership : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k) (x : H),
    PiTensorProduct.tprod ℂ (fun _ : Fin k => x) ∈ symmetricSpace H k hk

/-- The affirmative answer obligation to the source's spanning question.
The algebraic complex span ranges over all x : H, not a restricted family. -/
def diagonalTensorSpan : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k),
    Submodule.span ℂ (Set.range (fun x : H =>
      (PiTensorProduct.tprod ℂ (fun _ : Fin k => x) :
        PiTensorProduct ℂ (fun _ : Fin k => H)))) =
      symmetricSpace H k hk

end

end NumStability.Bhatia.Chapter01.Targets
