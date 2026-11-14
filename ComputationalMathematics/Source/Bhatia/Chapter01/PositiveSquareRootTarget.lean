/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Logic.ExistsUnique

/-!
# Positive square root in Bhatia, Chapter I

The source assertion on page 5 concerns every positive semidefinite operator on
a finite-dimensional complex Hilbert space. Both existence and uniqueness are
restricted to positive square roots; singular operators remain in scope.
-/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The positive square root assertion in Bhatia, Chapter I, page 5. -/
def positiveSquareRoot : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    A.IsPositive → ∃! B : H →ₗ[ℂ] H, B.IsPositive ∧ B.comp B = A

end NumStability.Bhatia.Chapter01.Targets
