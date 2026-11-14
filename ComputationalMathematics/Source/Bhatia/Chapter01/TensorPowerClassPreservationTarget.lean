/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.TensorProduct
import Mathlib.Analysis.InnerProductSpace.Positive

/-!
Proof-free statement for Bhatia, Matrix Analysis (1997),
I.4 tensor-power property 4, printed p. 15 / PDF p. 27.

The helper bundle contains only actual carrier structures. Its recursion starts
at H (one factor) and adds H on the left at each step using the actual binary
TensorProduct quotient, its pinned product inner product, and its finite-module
instance. There is no supplied tensor action or law assumption. The operator
recursion is the actual TensorProduct.map. Positive k is represented by k-1
steps, so all positive arities occur and no empty tensor convention is used.

Any identification with the separately used PiTensorProduct model is a distinct
correspondence obligation. No equivalence or transfer receipt is assumed here.
-/

set_option autoImplicit false
noncomputable section
universe u
open scoped TensorProduct

namespace NumStability.Bhatia.Chapter01.Targets

/-- Transparent structure packaging for the actual recursive construction. -/
structure TensorPowerFiniteHilbert where
  carrier : Type u
  [normed : NormedAddCommGroup carrier]
  [innerProduct : InnerProductSpace ℂ carrier]
  [finiteDimensional : FiniteDimensional ℂ carrier]

attribute [instance] TensorPowerFiniteHilbert.normed
  TensorPowerFiniteHilbert.innerProduct
  TensorPowerFiniteHilbert.finiteDimensional

/-- The one-factor space is H with its supplied Hilbert structures. -/
def tensorPowerFiniteHilbertOf (H : Type u)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] : TensorPowerFiniteHilbert where
  carrier := H
  normed := inferInstance
  innerProduct := inferInstance
  finiteDimensional := inferInstance

/-- Each binary step uses the existing product Hilbert instances. -/
def tensorPowerFiniteHilbertStep
    (X Y : TensorPowerFiniteHilbert.{u}) : TensorPowerFiniteHilbert where
  carrier := X.carrier ⊗[ℂ] Y.carrier
  normed := inferInstance
  innerProduct := inferInstance
  finiteDimensional := by
    letI := X.finiteDimensional
    letI := Y.finiteDimensional
    exact Module.Finite.tensorProduct (R := ℂ) (M := X.carrier) (N := Y.carrier)

/-- r counts binary steps; r=0 has one factor and r+1 has r+2 factors. -/
def tensorPowerFiniteHilbert (H : Type u)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] : ℕ → TensorPowerFiniteHilbert
  | 0 => tensorPowerFiniteHilbertOf H
  | r + 1 => tensorPowerFiniteHilbertStep
      (tensorPowerFiniteHilbertOf H) (tensorPowerFiniteHilbert H r)

/-- The prescribed operator, with no operator-valued callback input. -/
def tensorPowerFiniteHilbertMap (H : Type u)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] :
    (r : ℕ) → (H →ₗ[ℂ] H) →
      ((tensorPowerFiniteHilbert H r).carrier →ₗ[ℂ]
        (tensorPowerFiniteHilbert H r).carrier)
  | 0, A => A
  | r + 1, A => TensorProduct.map A (tensorPowerFiniteHilbertMap H r A)

/-- Four independent forward implications on the actual Hilbert tensor power.
LinearMap.IsPositive includes symmetry and nonnegativity on every vector.
The unconditional tensor-adjoint identity is a separate source item. -/
def tensorPowerClassPreservationTarget : Prop :=
  ∀ (H : Type u)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (k : ℕ), 0 < k →
    ∀ A : H →ₗ[ℂ] H,
      let T := (tensorPowerFiniteHilbert H (k - 1)).carrier
      let P : T →ₗ[ℂ] T := tensorPowerFiniteHilbertMap H (k - 1) A
      (LinearMap.adjoint A = A → LinearMap.adjoint P = P) ∧
      ((A.comp (LinearMap.adjoint A) = LinearMap.id ∧
          (LinearMap.adjoint A).comp A = LinearMap.id) →
        (P.comp (LinearMap.adjoint P) = LinearMap.id ∧
          (LinearMap.adjoint P).comp P = LinearMap.id)) ∧
      (A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A →
        P.comp (LinearMap.adjoint P) = (LinearMap.adjoint P).comp P) ∧
      (LinearMap.IsPositive A → LinearMap.IsPositive P)

end NumStability.Bhatia.Chapter01.Targets
