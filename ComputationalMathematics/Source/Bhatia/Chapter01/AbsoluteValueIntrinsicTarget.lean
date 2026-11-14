/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AbsoluteValue

/-!
# Positive operator absolute value

Proof-free correspondence proposal for Bhatia, *Matrix Analysis* (1997),
Chapter I.2, printed page 5 (PDF page 17). The prescribed absolute value is
the actual positive square root of the Gram operator. Uniqueness is only
among positive square roots. The ambient space may have dimension zero.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Positivity of the Gram operator and the prescribed unique positive square
root denoted by the operator absolute value. -/
def absoluteValueIntrinsic : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    ((LinearMap.adjoint A).comp A).IsPositive ∧
      (linearMapAbs A).IsPositive ∧
      (linearMapAbs A).comp (linearMapAbs A) = (LinearMap.adjoint A).comp A ∧
      ∀ B : H →ₗ[ℂ] H, B.IsPositive →
        B.comp B = (LinearMap.adjoint A).comp A → B = linearMapAbs A

end NumStability.Bhatia.Chapter01.Targets
