/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.LinearAlgebra.Span.Basic

/-!
# Uniqueness of a biorthogonal tuple

Proof-free target for the uniqueness clause of Bhatia, Matrix Analysis (1997),
Exercise I.1.1, printed page 2 / PDF page 14. An independent tuple spans the
ambient finite-dimensional space exactly when its length is the dimension.
The spanning formulation includes the empty tuple in dimension zero.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- A full independent tuple has at most one ordered biorthogonal tuple.
Both candidate tuples range over the entire ambient complex Hilbert space. -/
def biorthogonalUniqueSpanning : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (X : Fin k → H),
    LinearIndependent ℂ X →
    Submodule.span ℂ (Set.range X) = ⊤ →
      ∀ Y Z : Fin k → H,
        (∀ i j, inner ℂ (Y i) (X j) = (if i = j then 1 else 0 : ℂ)) →
        (∀ i j, inner ℂ (Z i) (X j) = (if i = j then 1 else 0 : ℂ)) →
        Y = Z

end NumStability.Bhatia.Chapter01.Targets
