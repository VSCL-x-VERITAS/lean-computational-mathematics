/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint

/-!
# Bhatia Chapter I: elementary properties of the numerical range

Section I.2, printed page 8. For an operator `A` on a finite-dimensional complex
Hilbert space, `W(A) = {⟨x, A x⟩ : ‖x‖ = 1}`, with the inner product
conjugate-linear in the first argument. Each target writes this set out
explicitly. The four printed facts are unitary invariance, the affine formula
`W(aA + bI) = a W(A) + b W(I)`, eigenvalues lying in `W(A)`, and closedness.
-/

set_option autoImplicit false
universe u

open scoped Pointwise

namespace NumStability.Bhatia.Chapter01.Targets

/-- `W(U A U*) = W(A)` for every unitary `U` (`U U* = I = U* U`). -/
def numericalRangeUnitaryInvariant : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A U : H →ₗ[ℂ] H),
    U.comp (LinearMap.adjoint U) = LinearMap.id →
    (LinearMap.adjoint U).comp U = LinearMap.id →
      {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x ((U.comp (A.comp (LinearMap.adjoint U))) x)} =
        {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)}

/-- `W(aA + bI) = a W(A) + b W(I)` for all complex `a, b`, with pointwise scalar
multiplication of sets and Minkowski addition. -/
def numericalRangeAffine : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A : H →ₗ[ℂ] H) (a b : ℂ),
    {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x ((a • A + b • (LinearMap.id : H →ₗ[ℂ] H)) x)} =
      a • {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)} +
        b • {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x ((LinearMap.id : H →ₗ[ℂ] H) x)}

/-- Every eigenvalue of `A` lies in `W(A)`. -/
def eigenvalueMemNumericalRange : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A : H →ₗ[ℂ] H) (lam : ℂ),
    (∃ v : H, v ≠ 0 ∧ A v = lam • v) →
      lam ∈ {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)}

/-- `W(A)` is a closed subset of the complex plane. -/
def numericalRangeClosed : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A : H →ₗ[ℂ] H),
    IsClosed {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)}

end NumStability.Bhatia.Chapter01.Targets
