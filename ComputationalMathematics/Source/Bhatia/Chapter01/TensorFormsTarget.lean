/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.LinearMap
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.BilinearForm.Hom
import Mathlib.LinearAlgebra.Multilinear.Basic
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.Data.Fin.VecNotation

/-!
# Multilinear and elementary bilinear functionals

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.4.
The inner product is conjugate-linear in its first argument.
-/

set_option autoImplicit false

noncomputable section

open scoped BigOperators

universe u v w

namespace NumStability.Bhatia.Chapter01.Targets

/-- Separate linearity is precisely representation by a bundled multilinear map.
The scalar-valued specialization is a multilinear functional. The two-variable
specialization is characterized by both displayed bilinear identities.
`Fin (k + 1)` records positive finite arity without a nullary assertion. -/
def multilinearBundledCharacterization : Prop :=
  (∀ (k : ℕ) (V : Fin (k + 1) → Type u) (W : Type v)
      [∀ i, AddCommGroup (V i)] [∀ i, Module ℂ (V i)]
      [∀ i, FiniteDimensional ℂ (V i)]
      [AddCommGroup W] [Module ℂ W] [FiniteDimensional ℂ W]
      (F : (∀ i, V i) → W),
    (∃ T : MultilinearMap ℂ V W, ∀ m, T m = F m) ↔
      ∀ (i : Fin (k + 1)) (m : ∀ j, V j) (a b : ℂ) (x y : V i),
        F (Function.update m i (a • x + b • y)) =
          a • F (Function.update m i x) + b • F (Function.update m i y)) ∧
  (∀ (k : ℕ) (V : Fin (k + 1) → Type u)
      [∀ i, AddCommGroup (V i)] [∀ i, Module ℂ (V i)]
      [∀ i, FiniteDimensional ℂ (V i)] (F : (∀ i, V i) → ℂ),
    (∃ T : MultilinearMap ℂ V ℂ, ∀ m, T m = F m) ↔
      ∀ (i : Fin (k + 1)) (m : ∀ j, V j) (a b : ℂ) (x y : V i),
        F (Function.update m i (a • x + b • y)) =
          a * F (Function.update m i x) + b * F (Function.update m i y)) ∧
  (∀ (V : Type u) (W : Type v) (Z : Type w)
      [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]
      [AddCommGroup W] [Module ℂ W] [FiniteDimensional ℂ W]
      [AddCommGroup Z] [Module ℂ Z] [FiniteDimensional ℂ Z]
      (F : V → W → Z),
    (∃ B : V →ₗ[ℂ] W →ₗ[ℂ] Z, ∀ x y, B x y = F x y) ↔
      (∀ (a b : ℂ) (u : V) (v₁ v₂ : W),
        F u (a • v₁ + b • v₂) = a • F u v₁ + b • F u v₂) ∧
      (∀ (a b : ℂ) (u₁ u₂ : V) (v : W),
        F (a • u₁ + b • u₂) v = a • F u₁ v + b • F u₂ v))

/-- The fixed inner-functional product is an actual bundled bilinear form,
with its pointwise formula and both complete bilinear laws. -/
def fixedInnerProductBilinearForm : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (x y : H),
    let B : H →ₗ[ℂ] H →ₗ[ℂ] ℂ :=
      LinearMap.BilinForm.linMulLin
        (innerSL ℂ x).toLinearMap (innerSL ℂ y).toLinearMap
    (∀ u v : H, B u v = inner ℂ x u * inner ℂ y v) ∧
    (∀ (a b : ℂ) (u₁ u₂ v : H),
      B (a • u₁ + b • u₂) v = a * B u₁ v + b * B u₂ v) ∧
    (∀ (a b : ℂ) (u v₁ v₂ : H),
      B u (a • v₁ + b • v₂) = a * B u v₁ + b * B u v₂)

/-- Every prescribed identity/conjugation choice in every slot is characterized
by actual semilinear maps of the corresponding slot. The all-conjugate case,
the named conjugate-first two-slot case, and the inner-product example are
included. These are functional definitions, with no tensor construction. -/
def mixedAndSesquilinearBundledCharacterization : Prop :=
  (∀ (k : ℕ) (V : Fin (k + 1) → Type u)
      [∀ i, AddCommGroup (V i)] [∀ i, Module ℂ (V i)]
      [∀ i, FiniteDimensional ℂ (V i)]
      (conjugateSlot : Fin (k + 1) → Bool) (F : (∀ i, V i) → ℂ),
    (∀ (i : Fin (k + 1)) (m : ∀ j, V j),
      ∃ L : V i →ₛₗ[if conjugateSlot i then starRingEnd ℂ else RingHom.id ℂ] ℂ,
        ∀ x : V i, L x = F (Function.update m i x)) ↔
    (∀ (i : Fin (k + 1)) (m : ∀ j, V j) (a b : ℂ) (x y : V i),
      F (Function.update m i (a • x + b • y)) =
        (if conjugateSlot i then star a else a) * F (Function.update m i x) +
        (if conjugateSlot i then star b else b) * F (Function.update m i y))) ∧
  (∀ (k : ℕ) (V : Fin (k + 1) → Type u)
      [∀ i, AddCommGroup (V i)] [∀ i, Module ℂ (V i)]
      [∀ i, FiniteDimensional ℂ (V i)] (F : (∀ i, V i) → ℂ),
    (∀ (i : Fin (k + 1)) (m : ∀ j, V j),
      ∃ L : V i →ₛₗ[starRingEnd ℂ] ℂ,
        ∀ x : V i, L x = F (Function.update m i x)) ↔
    (∀ (i : Fin (k + 1)) (m : ∀ j, V j) (a b : ℂ) (x y : V i),
      F (Function.update m i (a • x + b • y)) =
        star a * F (Function.update m i x) + star b * F (Function.update m i y))) ∧
  (∀ (K : Type u) (H : Type v)
      [AddCommGroup K] [Module ℂ K] [FiniteDimensional ℂ K]
      [AddCommGroup H] [Module ℂ H] [FiniteDimensional ℂ H]
      (F : K → H → ℂ),
    (∃ B : K →ₛₗ[starRingEnd ℂ] (H →ₗ[ℂ] ℂ), ∀ u v, B u v = F u v) ↔
      (∀ (a b : ℂ) (u₁ u₂ : K) (v : H),
        F (a • u₁ + b • u₂) v = star a * F u₁ v + star b * F u₂ v) ∧
      (∀ (a b : ℂ) (u : K) (v₁ v₂ : H),
        F u (a • v₁ + b • v₂) = a * F u v₁ + b * F u v₂)) ∧
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    ∃ B : H →ₛₗ[starRingEnd ℂ] (H →ₗ[ℂ] ℂ),
      (∀ u : H, B u = (innerSL ℂ u).toLinearMap) ∧
      (∀ u v : H, B u v = inner ℂ u v))

/-- Every linear operator from H to K gives a sesquilinear functional on K × H.
The bundled functional is conjugate-linear in K and linear in H. -/
def operatorSesquilinearForm : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (A : H →ₗ[ℂ] K),
    ∃ B : K →ₛₗ[starRingEnd ℂ] (H →ₗ[ℂ] ℂ),
      (∀ (u : K) (v : H), B u v = inner ℂ u (A v)) ∧
      (∀ (a b : ℂ) (u₁ u₂ : K) (v : H),
        B (a • u₁ + b • u₂) v = star a * B u₁ v + star b * B u₂ v) ∧
      (∀ (a b : ℂ) (u : K) (v₁ v₂ : H),
        B u (a • v₁ + b • v₂) = a * B u v₁ + b * B u v₂)

/-- Every sesquilinear functional on K × H has one unique operator H → K.
The operator is fixed before either evaluation vector is chosen. -/
def uniqueSesquilinearOperatorRepresentation : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (B : K →ₛₗ[starRingEnd ℂ] (H →ₗ[ℂ] ℂ)),
    ∃! A : H →ₗ[ℂ] K, ∀ (u : K) (v : H), B u v = inner ℂ u (A v)

/-- Elementary means equality to one fixed actual inner-functional product,
exactly when the complete pointwise formula holds with one fixed pair.
The raw function is unrestricted; either side entails its bilinearity. -/
def elementaryBundledCharacterization : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (F : H → H → ℂ),
    (∃ x y : H, ∀ u v : H,
      F u v = LinearMap.BilinForm.linMulLin
        (innerSL ℂ x).toLinearMap (innerSL ℂ y).toLinearMap u v) ↔
    (∃ x y : H, ∀ u v : H, F u v = inner ℂ x u * inner ℂ y v)

/-- Necessary-and-sufficient elementary factorization condition for the sum
in Exercise I.4.1, retaining the jointly independent ordered triple. -/
def elementarySumScalarMultipleCharacterization : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (x y z : H),
    LinearIndependent ℂ ![x, y, z] → ∀ w : H,
      (∃ a b : H, ∀ u v : H,
        (LinearMap.BilinForm.linMulLin
          (innerSL ℂ x).toLinearMap (innerSL ℂ y).toLinearMap +
         LinearMap.BilinForm.linMulLin
          (innerSL ℂ z).toLinearMap (innerSL ℂ w).toLinearMap) u v =
        LinearMap.BilinForm.linMulLin
          (innerSL ℂ a).toLinearMap (innerSL ℂ b).toLinearMap u v) ↔
      ∃ c : ℂ, w = c • y

/-- All bilinear forms are finite complex linear combinations of actual
fixed inner-functional products, without choosing a basis as data. -/
def elementaryBilinearFormFiniteSpan : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (B : H →ₗ[ℂ] H →ₗ[ℂ] ℂ),
    ∃ m : ℕ, ∃ c : Fin m → ℂ, ∃ x y : Fin m → H,
      B = ∑ i, c i • LinearMap.BilinForm.linMulLin
        (innerSL ℂ (x i)).toLinearMap (innerSL ℂ (y i)).toLinearMap

/-- For each fixed orthonormal basis, the vector tuple for the conjugate
functional is unique. Every tuple produces an actual bundled bilinear form
with the complete displayed conjugate formula. -/
def orthonormalBilinearVectorRepresentation : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (n : ℕ) (e : OrthonormalBasis (Fin n) ℂ H),
    (∀ B : H →ₗ[ℂ] H →ₗ[ℂ] ℂ,
      ∃! x : Fin n → H, ∀ u v : H,
        star (B u v) = ∑ j, inner ℂ u (e j) * inner ℂ v (x j)) ∧
    (∀ x : Fin n → H,
      let B : H →ₗ[ℂ] H →ₗ[ℂ] ℂ :=
        ∑ j, LinearMap.BilinForm.linMulLin
          (innerSL ℂ (e j)).toLinearMap (innerSL ℂ (x j)).toLinearMap
      (∀ u v : H, B u v = ∑ j, inner ℂ (e j) u * inner ℂ (x j) v) ∧
      (∀ u v : H,
        star (B u v) = ∑ j, inner ℂ u (e j) * inner ℂ v (x j)))

/-- Both orthonormal bases are fixed independently before the bilinear form.
The unique coefficients multiply outside pointwise complex conjugation. -/
def twoOrthonormalBilinearCoefficientRepresentation : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (n : ℕ) (e f : OrthonormalBasis (Fin n) ℂ H)
      (B : H →ₗ[ℂ] H →ₗ[ℂ] ℂ),
    ∃! a : Fin n → Fin n → ℂ, ∀ u v : H,
      B u v = ∑ i, ∑ j, a i j * (inner ℂ (e i) u * inner ℂ (f j) v)

end NumStability.Bhatia.Chapter01.Targets
