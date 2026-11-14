/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5. Runtime proof-free proposal.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.IncreasingIndicesTarget


/-!
# Nondecreasing multi-indices and lexicographic ordering

Proof-free contract for Bhatia, Matrix Analysis (1997), I.5, printed pages 16–17.
Each zero-based Fin label j denotes source label j+1. Weak ordering retains
repetitions for every n and positive k, with no k ≤ n assumption. The existing
first-difference lexicographic relation is reused without a second producer.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- G_{k,n}. Each zero-based Fin entry j represents source entry j+1.
Repeated entries are retained, and there is no k ≤ n restriction. -/
def nondecreasingIndexSet (n k : ℕ) : Set (Fin k → Fin n) :=
  {I | Monotone I}

/-- Complete weak-order membership and the source's conventional lex order.
The existing increasingIndexLex is defined on all tuples and is reused here. -/
def nondecreasingIndicesDefinition : Prop :=
  ∀ (n k : ℕ), 0 < k →
    (∀ I : Fin k → Fin n,
      I ∈ nondecreasingIndexSet n k ↔
        ∀ i j : Fin k, i ≤ j → I i ≤ I j) ∧
    (∀ I J : Fin k → Fin n,
      increasingIndexLex n k I J ↔
        ∃ j : Fin k, (∀ i : Fin k, i < j → I i = J i) ∧ I j < J j)

end NumStability.Bhatia.Chapter01.Targets
