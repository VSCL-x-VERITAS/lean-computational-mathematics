/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Complex.Order
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.Algebra.Star.Unitary

set_option autoImplicit false
noncomputable section
open scoped Matrix ComplexOrder
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Positive operators and their prescribed source characterizations. All primary predicates are actual library
objects. Hermitian qualification precedes each real quadratic comparison.
Positive/semidefinite uses IsPositive and Loewner non-strict LE. Strict
positive/definite uses Matrix.PosDef in every actual ONB; it never uses
Loewner LT and introduces no operator strict-positivity wrapper. -/
def positiveTerminologyUsingPosDef : Prop :=
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    A = LinearMap.adjoint A →
      (∀ x : H, inner ℂ x (A x) = ((inner ℂ x (A x)).re : ℂ)) ∧
      (A.IsPositive ↔ ∀ x : H, 0 ≤ (inner ℂ x (A x)).re) ∧
      (((0 : H →ₗ[ℂ] H) ≤ A) ↔ A.IsPositive) ∧
      (∀ (n : ℕ) (E : OrthonormalBasis (Fin n) ℂ H),
        (LinearMap.toMatrix E.toBasis E.toBasis A).PosDef ↔
          ∀ x : H, x ≠ 0 → 0 < (inner ℂ x (A x)).re)) ∧
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A B : H →ₗ[ℂ] H),
    A = LinearMap.adjoint A → B = LinearMap.adjoint B →
      ((B ≤ A) ↔ (A - B).IsPositive))

end NumStability.Bhatia.Chapter01.Targets
