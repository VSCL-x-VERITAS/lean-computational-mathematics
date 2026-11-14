/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.TensorProduct.Basic

/-!
# The literal algebraic conjugate dual

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.4.
-/

set_option autoImplicit false
noncomputable section
universe u v
open scoped TensorProduct BigOperators
namespace NumStability.Bhatia.Chapter01.Targets

/-- Literal printed dual: ALL algebraic conjugate-linear functionals with
pointwise addition and scalar multiplication. No norm is chosen or needed. -/
abbrev SourceConjugateDual (K : Type v) [AddCommGroup K] [Module ℂ K] :=
  K →ₛₗ[starRingEnd ℂ] ℂ

/-- Concrete quotient tensor carrier for the first named pair. -/
abbrev SourceMixedTensor (H : Type u) (K : Type v)
    [AddCommGroup H] [Module ℂ H] [AddCommGroup K] [Module ℂ K] :=
  TensorProduct ℂ H K

/-- Concrete quotient tensor carrier in the printed factor order K* tensor H.
The algebraic anti-dual does not need an assumed Hilbert structure. -/
abbrev SourceDualTensor (K : Type v) (H : Type u)
    [AddCommGroup K] [Module ℂ K] [AddCommGroup H] [Module ℂ H] :=
  TensorProduct ℂ (SourceConjugateDual K) H

/-- The four actual relations on the canonical elementary tensor constructor. -/
def sourceTensorRelations (U : Type u) (V : Type v)
    [AddCommGroup U] [Module ℂ U] [AddCommGroup V] [Module ℂ V] : Prop :=
  (∀ (a : ℂ) (x : U) (y : V),
    a • TensorProduct.tmul ℂ x y = TensorProduct.tmul ℂ (a • x) y) ∧
  (∀ (a : ℂ) (x : U) (y : V),
    a • TensorProduct.tmul ℂ x y = TensorProduct.tmul ℂ x (a • y)) ∧
  (∀ (x₁ x₂ : U) (y : V),
    TensorProduct.tmul ℂ x₁ y + TensorProduct.tmul ℂ x₂ y =
      TensorProduct.tmul ℂ (x₁ + x₂) y) ∧
  (∀ (x : U) (y₁ y₂ : V),
    TensorProduct.tmul ℂ x y₁ + TensorProduct.tmul ℂ x y₂ =
      TensorProduct.tmul ℂ x (y₁ + y₂))

/-- Printed14/PDF26. The functional characterization is an extensional check
of the full bundled carrier, not a callback replacing that carrier. The
downstream natural-identification/norm assertion is a separate held row. -/
def literalConjugateDualTarget : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K],
    (∀ g : K → ℂ,
      (∃ phi : SourceConjugateDual K, ∀ x : K, phi x = g x) ↔
        ∀ (a b : ℂ) (x y : K),
          g (a • x + b • y) = star a * g x + star b * g y) ∧
    (∀ (phi psi : SourceConjugateDual K) (a : ℂ) (x : K),
      (phi + psi) x = phi x + psi x ∧ (a • phi) x = a * phi x) ∧
    sourceTensorRelations H K ∧
    sourceTensorRelations (SourceConjugateDual K) H

end NumStability.Bhatia.Chapter01.Targets
