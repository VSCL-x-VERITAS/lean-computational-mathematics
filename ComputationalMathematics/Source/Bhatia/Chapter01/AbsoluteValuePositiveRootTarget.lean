/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot

/-!
# Absolute value as the prescribed unique positive root

Proof-free correspondence proposal for Bhatia, *Matrix Analysis* (1997),
Section I.2, printed page 5 (PDF page 17). For every operator, its Gram
operator is positive, and its unique positive square root is denoted by |A|.
The prescribed root below is chosen from proved positive-root unique existence.

Both operators are bound from the input. The space may have dimension zero,
and uniqueness is restricted to positive semidefinite roots.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Gram positivity and the four-part characterization of the prescribed
operator absolute value as its unique positive square root. -/
def absoluteValuePositiveRootChoice : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let G := (LinearMap.adjoint A).comp A
    let absOp := NumStability.positiveSquareRoot G
      (LinearMap.isPositive_adjoint_comp_self A)
    G.IsPositive ∧
      absOp.IsPositive ∧
      absOp.comp absOp = G ∧
      ∀ B : H →ₗ[ℂ] H, B.IsPositive → B.comp B = G → B = absOp

end NumStability.Bhatia.Chapter01.Targets
