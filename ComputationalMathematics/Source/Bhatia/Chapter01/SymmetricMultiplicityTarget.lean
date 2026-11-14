/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5. Runtime proof-free proposal.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NondecreasingIndicesTarget
import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Defs


/-!
# Multiplicity factorials for symmetric multi-indices

Proof-free contract for Bhatia, Matrix Analysis (1997), I.5, printed pages 16–17.
Actual occurrence counts define one total factorial product; unused labels
contribute 0! = 1. Its restriction to nondecreasing tuples is the source m(I).
The target also states strict-to-weak inclusion and m(I) = 1 on strict tuples.
All source assertions require positive degree and allow zero dimension.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- Actual number of positions carrying the given label, including zero for
labels absent from the tuple. -/
def indexOccurrenceCount {n k : ℕ} (I : Fin k → Fin n) (j : Fin n) : ℕ :=
  (Finset.univ.filter (fun i : Fin k => I i = j)).card

/-- One total tuple-count producer. Unused labels contribute 0! = 1. -/
def tupleMultiplicityFactor {n k : ℕ} (I : Fin k → Fin n) : ℕ :=
  ∏ j : Fin n, Nat.factorial (indexOccurrenceCount I j)

/-- The source m is the restriction of the actual tuple-count producer to G. -/
def symmetricMultiplicity {n k : ℕ}
    (I : {I : Fin k → Fin n // I ∈ nondecreasingIndexSet n k}) : ℕ :=
  tupleMultiplicityFactor I.val

/-- Product over the distinct labels that occur, together with strict-to-weak
inclusion and m(I)=1 on every strictly increasing tuple. No proofs supplied. -/
def symmetricMultiplicityDefinition : Prop :=
  ∀ (n k : ℕ), 0 < k →
    (∀ I : {I : Fin k → Fin n // I ∈ nondecreasingIndexSet n k},
      symmetricMultiplicity I =
        ∏ j ∈ Finset.univ.image I.val, Nat.factorial (indexOccurrenceCount I.val j)) ∧
    (∀ I : Fin k → Fin n,
      I ∈ increasingIndexSet n k → I ∈ nondecreasingIndexSet n k) ∧
    (∀ I : {I : Fin k → Fin n // I ∈ nondecreasingIndexSet n k},
      I.val ∈ increasingIndexSet n k → symmetricMultiplicity I = 1)

end NumStability.Bhatia.Chapter01.Targets
