/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.InnerProductSpace.LinearMap
import Mathlib.LinearAlgebra.Finsupp.LinearCombination
import Mathlib.Data.Finsupp.Single
import Mathlib.Algebra.BigOperators.Finsupp.Basic
import Mathlib.LinearAlgebra.Span.Defs
import Mathlib.LinearAlgebra.Quotient.Basic
import Mathlib.LinearAlgebra.TensorProduct.Basic

/-!
# The literal tensor quotient and its functional descent

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.4.
The free space, all four relation families, their complex linear span, and the
actual quotient remain explicit. Complex conjugation acts on the whole value.
-/

set_option autoImplicit false

noncomputable section

universe u v

namespace NumStability.Bhatia.Chapter01.Targets

/-- The actual quotient has precisely the prescribed linear congruence.
All tensor classes have finite-sum representatives, and the elementary classes
are the values of an actual bundled bilinear map. -/
def literalTensorQuotientRealization : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K],
    let F := (H × K) →₀ ℂ
    let symbol : H → K → F := fun x y => Finsupp.single (x, y) 1
    let generators : Set F :=
      {r | (∃ (a : ℂ) (x : H) (y : K),
              r = a • symbol x y - symbol (a • x) y) ∨
           (∃ (a : ℂ) (x : H) (y : K),
              r = a • symbol x y - symbol x (a • y)) ∨
           (∃ (x₁ x₂ : H) (y : K),
              r = symbol x₁ y + symbol x₂ y - symbol (x₁ + x₂) y) ∨
           (∃ (x : H) (y₁ y₂ : K),
              r = symbol x y₁ + symbol x y₂ - symbol x (y₁ + y₂))}
    let R := Submodule.span ℂ generators
    let Q := F ⧸ R
    let project : F →ₗ[ℂ] Q := R.mkQ
    Function.Surjective project ∧
    LinearMap.ker project = R ∧
    (∀ r ∈ generators, project r = 0) ∧
    (∀ E E' : F, project E = project E' ↔ E - E' ∈ R) ∧
    (∃ b : H →ₗ[ℂ] K →ₗ[ℂ] Q,
      ∀ (x : H) (y : K), b x y = project (symbol x y))

/-- The prescribed finite-sum evaluation descends from the actual quotient
into actual conjugate-bilinear maps. Pointwise whole-value conjugation is a
conjugate-linear map into actual bilinear maps, including coefficient conjugation.
No injectivity, surjectivity, norm or identification is asserted for these maps. -/
def literalTensorFunctionalDescent : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K],
    let F := (H × K) →₀ ℂ
    let symbol : H → K → F := fun x y => Finsupp.single (x, y) 1
    let generators : Set F :=
      {r | (∃ (a : ℂ) (x : H) (y : K),
              r = a • symbol x y - symbol (a • x) y) ∨
           (∃ (a : ℂ) (x : H) (y : K),
              r = a • symbol x y - symbol x (a • y)) ∨
           (∃ (x₁ x₂ : H) (y : K),
              r = symbol x₁ y + symbol x₂ y - symbol (x₁ + x₂) y) ∨
           (∃ (x : H) (y₁ y₂ : K),
              r = symbol x y₁ + symbol x y₂ - symbol x (y₁ + y₂))}
    let R := Submodule.span ℂ generators
    let Q := F ⧸ R
    let project : F →ₗ[ℂ] Q := R.mkQ
    (∀ E E' : F, project E = project E' → ∀ (u : H) (v : K),
      E.sum (fun p c => c * (inner ℂ u p.1 * inner ℂ v p.2)) =
        E'.sum (fun p c => c * (inner ℂ u p.1 * inner ℂ v p.2))) ∧
    (∃ (Phi : Q →ₗ[ℂ] (H →ₛₗ[starRingEnd ℂ] (K →ₛₗ[starRingEnd ℂ] ℂ)))
        (Psi : Q →ₛₗ[starRingEnd ℂ] (H →ₗ[ℂ] K →ₗ[ℂ] ℂ)),
      (∀ (E : F) (u : H) (v : K),
        Phi (project E) u v =
          E.sum (fun p c => c * (inner ℂ u p.1 * inner ℂ v p.2))) ∧
      (∀ (c : ℂ) (x : H) (y : K) (u : H) (v : K),
        Phi (project (c • symbol x y)) u v =
          c * (inner ℂ u x * inner ℂ v y)) ∧
      (∀ (E : F) (u : H) (v : K),
        Psi (project E) u v =
          E.sum (fun p c => star c * (inner ℂ p.1 u * inner ℂ p.2 v))) ∧
      (∀ (t : Q) (u : H) (v : K), Psi t u v = star (Phi t u v)) ∧
      (∀ (a b : ℂ) (t : Q) (u₁ u₂ : H) (v : K),
        Phi t (a • u₁ + b • u₂) v =
          star a * Phi t u₁ v + star b * Phi t u₂ v) ∧
      (∀ (a b : ℂ) (t : Q) (u : H) (v₁ v₂ : K),
        Phi t u (a • v₁ + b • v₂) =
          star a * Phi t u v₁ + star b * Phi t u v₂) ∧
      (∀ (a b : ℂ) (t : Q) (u₁ u₂ : H) (v : K),
        Psi t (a • u₁ + b • u₂) v = a * Psi t u₁ v + b * Psi t u₂ v) ∧
      (∀ (a b : ℂ) (t : Q) (u : H) (v₁ v₂ : K),
        Psi t u (a • v₁ + b • v₂) = a * Psi t u v₁ + b * Psi t u v₂) ∧
      (∀ (c : ℂ) (t : Q) (u : H) (v : K),
        Psi (c • t) u v = star c * Psi t u v))

/-- A separate canonical bridge to Mathlib's tensor product. The free linear
combination map is fixed. Its kernel, surjectivity, quotient equivalence and
inverse supplied by the actual TensorProduct.lift are all conclusions. -/
def literalTensorCanonicalBridge : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K],
    let F := (H × K) →₀ ℂ
    let symbol : H → K → F := fun x y => Finsupp.single (x, y) 1
    let generators : Set F :=
      {r | (∃ (a : ℂ) (x : H) (y : K),
              r = a • symbol x y - symbol (a • x) y) ∨
           (∃ (a : ℂ) (x : H) (y : K),
              r = a • symbol x y - symbol x (a • y)) ∨
           (∃ (x₁ x₂ : H) (y : K),
              r = symbol x₁ y + symbol x₂ y - symbol (x₁ + x₂) y) ∨
           (∃ (x : H) (y₁ y₂ : K),
              r = symbol x y₁ + symbol x y₂ - symbol x (y₁ + y₂))}
    let R := Submodule.span ℂ generators
    let Q := F ⧸ R
    let project : F →ₗ[ℂ] Q := R.mkQ
    let canonical : F →ₗ[ℂ] TensorProduct ℂ H K :=
      Finsupp.linearCombination ℂ (fun p : H × K => TensorProduct.tmul ℂ p.1 p.2)
    LinearMap.ker canonical = R ∧
    Function.Surjective canonical ∧
    (∃ (b : H →ₗ[ℂ] K →ₗ[ℂ] Q) (e : Q ≃ₗ[ℂ] TensorProduct ℂ H K),
      (∀ (x : H) (y : K), b x y = project (symbol x y)) ∧
      (∀ E : F, e (project E) = canonical E) ∧
      (∀ (x : H) (y : K),
        e (project (symbol x y)) = TensorProduct.tmul ℂ x y) ∧
      e.symm.toLinearMap = TensorProduct.lift b)

end NumStability.Bhatia.Chapter01.Targets
