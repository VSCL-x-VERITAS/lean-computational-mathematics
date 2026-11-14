/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import Mathlib.Algebra.Star.Unitary

/-!
# Positive and unitary uniqueness in Bhatia's polar decomposition

Bhatia, Matrix Analysis, Exercise I.2.4(i), printed page 6
(PDF page 18), with the positive absolute value from printed page 5 (PDF page 17).
The positive factor of every unitary-times-positive factorization is the
prescribed positive square root of the Gram operator. Invertibility is a
sufficient hypothesis only for uniqueness of the unitary factor.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Positive-factor identification and conditional unitary-factor uniqueness,
for all finite-dimensional complex inner-product spaces, including dimension zero. -/
def polarPositiveRootUniqueness : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let absOp : H →ₗ[ℂ] H :=
      NumStability.positiveSquareRoot ((LinearMap.adjoint A).comp A)
        (LinearMap.isPositive_adjoint_comp_self A)
    (∀ U P : H →ₗ[ℂ] H,
      U ∈ unitary (H →ₗ[ℂ] H) → P.IsPositive → A = U.comp P → P = absOp) ∧
    (IsUnit A → ∀ U P U' P' : H →ₗ[ℂ] H,
      U ∈ unitary (H →ₗ[ℂ] H) → P.IsPositive → A = U.comp P →
      U' ∈ unitary (H →ₗ[ℂ] H) → P'.IsPositive → A = U'.comp P' → U = U')

end NumStability.Bhatia.Chapter01.Targets
