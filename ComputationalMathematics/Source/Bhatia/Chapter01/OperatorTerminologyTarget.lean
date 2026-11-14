/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Algebra.Star.Unitary

/-!
# Bhatia Chapter I: Hermitian, unitary and normal operators

Transparent propositions relating the library predicates to the source equations
on an arbitrary finite-dimensional complex Hilbert space.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Both names for a self-adjoint operator, and the sign in skew-Hermitian. -/
def hermitianTerminology : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    (IsSelfAdjoint A ↔ A = LinearMap.adjoint A) ∧
    (A ∈ skewAdjoint (H →ₗ[ℂ] H) ↔ A = -LinearMap.adjoint A)

/-- Both unitary equations, and normality as equality of the adjoint products. -/
def unitaryNormalTerminology : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    (A ∈ unitary (H →ₗ[ℂ] H) ↔
      A.comp (LinearMap.adjoint A) = LinearMap.id ∧
      (LinearMap.adjoint A).comp A = LinearMap.id) ∧
    (IsStarNormal A ↔
      A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A)

end NumStability.Bhatia.Chapter01.Targets
