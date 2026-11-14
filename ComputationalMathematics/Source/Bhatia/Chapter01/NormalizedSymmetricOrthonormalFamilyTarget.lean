/-
SPDX-License-Identifier: MIT
Proof-free source target proposal: Bhatia, Matrix Analysis (1997), I.5,
printed pages 16–17 / PDF pages 28–29. No theorem acceptance is asserted by this definition.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NormalizedSymmetricFamily
import ComputationalMathematics.Source.Bhatia.Chapter01.TensorPowerHilbertEquiv
import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.LinearAlgebra.Span.Defs

/-!
The prescribed normalized symmetric family lies in, is orthonormal in, and
spans the actual symmetric subspace transported to the recursive Hilbert
carrier. The transport is the existing concrete linear equivalence, never a
supplied equivalence or an extracted witness of an unproved correspondence.

All finite dimensions n, including zero, and every positive degree r + 1 are
retained. No k ≤ n, nonzero-dimension, or nonempty-index hypothesis is added.
The input e is an orthonormal basis of all H. No orthonormal basis of the
symmetric subspace, membership proof, or tensor inner-product law is assumed.

The two normalization factors occur in the existing vector producer: one
1/sqrt((r+1)!) in normalizedSymmetricProduct and one 1/sqrt(m(I)) outside.
The symmetric space is the image of the full span over all H-valued tuples;
it is not defined as the span of this proposed basis.

This is the normalized-basis claim, a prerequisite of the later normalized
symmetric matrix-entry formula. It does not state that formula or the adjacent
dimension formula. The index type consists of nondecreasing tuples. The existing
increasingIndexLex relation expresses the source lexicographic convention; this
basis proposition does not choose an ordered enumeration.
The concrete map's generator and product-inner-product correspondence still
require proof; this definition of Prop does not assert those facts or this goal.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Proof-free normalized symmetric basis obligation in the prescribed Hilbert
carrier. Ambient orthonormality together with membership and full spanning
expresses the source's basis assertion without presupposing a bundled basis. -/
def normalizedSymmetricOrthonormalFamilyTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (n : ℕ)
      (e : OrthonormalBasis (Fin n) ℂ H) (r : ℕ),
    let C := tensorPowerHilbertEquiv H r
    let W : Submodule ℂ (tensorPowerFiniteHilbert H r).carrier :=
      (symmetricSpace H (r + 1) (Nat.succ_pos r)).map C.toLinearMap
    let v : nondecreasingIndexSet n (r + 1) →
        (tensorPowerFiniteHilbert H r).carrier :=
      fun I => C (normalizedSymmetricVectorFamily e (r + 1) (Nat.succ_pos r) I)
    (∀ I : nondecreasingIndexSet n (r + 1), v I ∈ W) ∧
      Orthonormal ℂ v ∧
      Submodule.span ℂ (Set.range v) = W

end NumStability.Bhatia.Chapter01.Targets
