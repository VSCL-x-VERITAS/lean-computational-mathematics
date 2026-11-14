/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Order.Fin.Basic
import Mathlib.Order.Monotone.Defs

/-!
Proof-free definitions for Bhatia, Matrix Analysis (1997), Chapter I.5,
printed page 16, PDF page 28. Fin n uses zero-based indices; adding one in
each coordinate gives the source bounds 1 through n. The tensor degree is
positive. Lexicographic ordering is the conventional first-difference order.
The adjacent binomial cardinality and exterior dimension are separate claims.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- The source Q_{k,n}, represented by strictly increasing indexed tuples. -/
def increasingIndexSet (n k : ℕ) : Set (Fin k → Fin n) :=
  {I | StrictMono I}

/-- The conventional dictionary order on tuples. -/
def increasingIndexLex (n k : ℕ) (I J : Fin k → Fin n) : Prop :=
  ∃ j : Fin k, (∀ i : Fin k, i < j → I i = J i) ∧ I j < J j

/-- Both the complete membership condition and the declared ordering. -/
def increasingIndicesDefinition : Prop :=
  ∀ (n k : ℕ), 0 < k →
    (∀ I : Fin k → Fin n,
      I ∈ increasingIndexSet n k ↔
        ∀ i j : Fin k, i < j → I i < I j) ∧
    (∀ I J : Fin k → Fin n,
      increasingIndexLex n k I J ↔
        ∃ j : Fin k, (∀ i : Fin k, i < j → I i = J i) ∧ I j < J j)

end NumStability.Bhatia.Chapter01.Targets
