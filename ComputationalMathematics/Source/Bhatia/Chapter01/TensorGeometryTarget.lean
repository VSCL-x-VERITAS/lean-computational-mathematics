/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.TensorProduct
import Mathlib.LinearAlgebra.Dimension.Constructions

/-!
# Tensor dimension, inner product, bases and lexicographic order

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.4.
-/

set_option autoImplicit false
noncomputable section
universe u v
open scoped TensorProduct BigOperators
namespace NumStability.Bhatia.Chapter01.Targets

/-- The entire separately conjugate-linear functional space, with pointwise
complex scalar action. Neither slot is silently changed to a linear dual. -/
abbrev ConjugateBilinear (H : Type u) [AddCommGroup H] [Module ℂ H] :=
  H →ₛₗ[starRingEnd ℂ] (H →ₛₗ[starRingEnd ℂ] ℂ)

/-- Printed14/PDF26. The functional realization is a conclusion with its full
elementary evaluation rule; it is not supplied as an assumed equivalence.
The literal free-sum quotient correspondence is a separately named obligation. -/
def tensorDimensionTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    Module.finrank ℂ (TensorProduct ℂ H H) = (Module.finrank ℂ H) ^ 2 ∧
    (∃ Phi : TensorProduct ℂ H H ≃ₗ[ℂ] ConjugateBilinear H,
      ∀ (x y p q : H),
        Phi (TensorProduct.tmul ℂ x y) p q = inner ℂ p x * inner ℂ q y) ∧
    Module.finrank ℂ (ConjugateBilinear H) = (Module.finrank ℂ H) ^ 2

/-- Printed14/PDF26. The actual canonical tensor inner-product structure is
used on all tensors. Its finite-sum extension, definiteness and uniqueness
are conclusions; no later tensor-basis conclusion is assumed. -/
def tensorInnerProductTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let T := TensorProduct ℂ H H
    (∀ (x y z w : H),
      inner ℂ (TensorProduct.tmul ℂ x y) (TensorProduct.tmul ℂ z w) =
        inner ℂ x z * inner ℂ y w) ∧
    (∀ (r s : ℕ) (c : Fin r → ℂ) (d : Fin s → ℂ)
        (x y : Fin r → H) (z w : Fin s → H),
      inner ℂ (∑ i, c i • TensorProduct.tmul ℂ (x i) (y i))
        (∑ j, d j • TensorProduct.tmul ℂ (z j) (w j)) =
        ∑ i, ∑ j, star (c i) * d j * (inner ℂ (x i) (z j) * inner ℂ (y i) (w j))) ∧
    (∀ t : T, 0 ≤ (inner ℂ t t).re ∧ (inner ℂ t t = 0 ↔ t = 0)) ∧
    (∀ B : T →ₛₗ[starRingEnd ℂ] (T →ₗ[ℂ] ℂ),
      (∀ (x y z w : H),
        B (TensorProduct.tmul ℂ x y) (TensorProduct.tmul ℂ z w) =
          inner ℂ x z * inner ℂ y w) →
      ∀ (s t : T), B s t = inner ℂ s t)

/-- Printed14/PDF26. Both independent bases of the same space remain supplied
inputs. The existence of an orthonormal BASIS with these values includes full
spanning, not just orthogonality. Fin 0 is retained. -/
def tensorBasisTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H]
      (e f : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H),
    ∃ b : OrthonormalBasis
        (Fin (Module.finrank ℂ H) × Fin (Module.finrank ℂ H)) ℂ (TensorProduct ℂ H H),
      ∀ (i j : Fin (Module.finrank ℂ H)),
        b (i, j) = TensorProduct.tmul ℂ (e i) (f j)

/-- The prescribed strict first-index-major relation on the indexed tensor
family. The target below concerns basis members only; no order on arbitrary
vector-space elements or basis-independent ordering is claimed. -/
def tensorBasisPrecedes {H : Type u}
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (e f : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H)
    (s t : TensorProduct ℂ H H) : Prop :=
  ∃ (i j k l : Fin (Module.finrank ℂ H)),
    s = TensorProduct.tmul ℂ (e i) (f j) ∧
    t = TensorProduct.tmul ℂ (e k) (f l) ∧
    (i < k ∨ (i = k ∧ j < l))

/-- Printed14/PDF26. This attaches the explicit convention to the actual
source tensor family, preserving all four index binders and the strict iff. -/
def tensorLexicographicTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H]
      (e f : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H)
      (i j k l : Fin (Module.finrank ℂ H)),
    tensorBasisPrecedes e f (TensorProduct.tmul ℂ (e i) (f j))
      (TensorProduct.tmul ℂ (e k) (f l)) ↔
      i < k ∨ (i = k ∧ j < l)

end NumStability.Bhatia.Chapter01.Targets
