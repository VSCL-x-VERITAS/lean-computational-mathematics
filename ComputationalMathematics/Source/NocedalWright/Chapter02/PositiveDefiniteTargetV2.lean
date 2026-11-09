import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

open scoped BigOperators

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The real scalar pᵀBp for an arbitrary square matrix. -/
def bookQuadraticFormV2 {n : ℕ} (B : Fin n → Fin n → ℝ) (p : Fin n → ℝ) : ℝ :=
  ∑ i, p i * (∑ j, B i j * p j)

/-- Positive definiteness as the book defines it, with no symmetry premise. -/
def IsBookPositiveDefiniteV2 {n : ℕ} (B : Fin n → Fin n → ℝ) : Prop :=
  ∀ p : Fin n → ℝ, p ≠ 0 → 0 < bookQuadraticFormV2 B p

/-- The printed Chapter 2 definition of positive definiteness. -/
def positiveDefiniteTargetV2 : Prop :=
  ∀ (n : ℕ), 0 < n → ∀ (B : Fin n → Fin n → ℝ),
    IsBookPositiveDefiniteV2 B ↔
      ∀ p : Fin n → ℝ, p ≠ 0 → 0 < bookQuadraticFormV2 B p

end ComputationalMathematics.Source.NocedalWright.Chapter02
