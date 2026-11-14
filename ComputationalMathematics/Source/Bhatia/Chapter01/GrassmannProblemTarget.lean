/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.LinearAlgebra.Finsupp.LinearCombination
import Mathlib.Data.Finsupp.Single
import Mathlib.LinearAlgebra.Span.Defs
import Mathlib.LinearAlgebra.Quotient.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.LinearAlgebra.ExteriorPower.Basic
import Mathlib.Data.Fin.VecNotation

/-!
# The dimension threshold for a non-elementary bivector

Transparent statement contracts for Bhatia, Matrix Analysis (1997), I.6.4.
The degree is two. The exterior space is the span of the normalized
antisymmetric tensors in the literal tensor quotient. No inner product on W
is required for this algebraic construction.
-/

set_option autoImplicit false

noncomputable section

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Non-elementary bivectors exist exactly from dimension four onward.
Every element in smaller dimensions is one elementary wedge. The sufficient
clause supplies the sum of two wedges from four independent vectors in every
allowed dimension, including the first one. Zero is included as elementary. -/
def nonElementaryBivectorDimensionThreshold : Prop :=
  ∀ (W : Type u) [AddCommGroup W] [Module ℂ W] [FiniteDimensional ℂ W],
    let F := (W × W) →₀ ℂ
    let symbol : W → W → F := fun x y => Finsupp.single (x, y) 1
    let generators : Set F :=
      {r | (∃ (a : ℂ) (x y : W),
              r = a • symbol x y - symbol (a • x) y) ∨
           (∃ (a : ℂ) (x y : W),
              r = a • symbol x y - symbol x (a • y)) ∨
           (∃ x₁ x₂ y : W,
              r = symbol x₁ y + symbol x₂ y - symbol (x₁ + x₂) y) ∨
           (∃ x y₁ y₂ : W,
              r = symbol x y₁ + symbol x y₂ - symbol x (y₁ + y₂))}
    let R := Submodule.span ℂ generators
    let Q := F ⧸ R
    let project : F →ₗ[ℂ] Q := R.mkQ
    let wedge : W → W → Q := fun x y =>
      ((Real.sqrt 2 : ℝ) : ℂ)⁻¹ • (project (symbol x y) - project (symbol y x))
    let S : Submodule ℂ Q :=
      Submodule.span ℂ (Set.range (fun p : W × W => wedge p.1 p.2))
    ((∃ X : S, ∀ x y : W, (X : Q) ≠ wedge x y) ↔ 4 ≤ Module.finrank ℂ W) ∧
    (Module.finrank ℂ W < 4 →
      ∀ X : S, ∃ x y : W, (X : Q) = wedge x y) ∧
    (4 ≤ Module.finrank ℂ W →
      ∃ b : Fin 4 → W,
        LinearIndependent ℂ b ∧
        wedge (b 0) (b 1) + wedge (b 2) (b 3) ∈ S ∧
        (∀ x y : W, wedge (b 0) (b 1) + wedge (b 2) (b 3) ≠ wedge x y))

/-- The canonical exterior-square model is related to the literal normalized
antisymmetric span by an actual linear equivalence with the exact elementary
wedge formula. The equivalence is a conclusion, not input data. -/
def normalizedExteriorSquareLiteralBridge : Prop :=
  ∀ (W : Type u) [AddCommGroup W] [Module ℂ W] [FiniteDimensional ℂ W],
    let F := (W × W) →₀ ℂ
    let symbol : W → W → F := fun x y => Finsupp.single (x, y) 1
    let generators : Set F :=
      {r | (∃ (a : ℂ) (x y : W),
              r = a • symbol x y - symbol (a • x) y) ∨
           (∃ (a : ℂ) (x y : W),
              r = a • symbol x y - symbol x (a • y)) ∨
           (∃ x₁ x₂ y : W,
              r = symbol x₁ y + symbol x₂ y - symbol (x₁ + x₂) y) ∨
           (∃ x y₁ y₂ : W,
              r = symbol x y₁ + symbol x y₂ - symbol x (y₁ + y₂))}
    let R := Submodule.span ℂ generators
    let Q := F ⧸ R
    let project : F →ₗ[ℂ] Q := R.mkQ
    let wedge : W → W → Q := fun x y =>
      ((Real.sqrt 2 : ℝ) : ℂ)⁻¹ • (project (symbol x y) - project (symbol y x))
    let S : Submodule ℂ Q :=
      Submodule.span ℂ (Set.range (fun p : W × W => wedge p.1 p.2))
    ∃ e : (⋀[ℂ]^2 W) ≃ₗ[ℂ] S,
      ∀ x y : W,
        (e (exteriorPower.ιMulti ℂ 2 ![x, y]) : Q) = wedge x y

end NumStability.Bhatia.Chapter01.Targets
