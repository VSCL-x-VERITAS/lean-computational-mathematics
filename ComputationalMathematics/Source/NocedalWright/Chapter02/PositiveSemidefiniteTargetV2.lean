import ComputationalMathematics.Source.NocedalWright.Chapter02.PositiveDefiniteTargetV2

/-!
Proof-free quadratic-form positive-semidefiniteness definition from Chapter 2.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Positive semidefiniteness as the book defines it, with no symmetry premise. -/
def IsBookPositiveSemidefiniteV2 {n : ℕ} (B : Fin n → Fin n → ℝ) : Prop :=
  ∀ p : Fin n → ℝ, 0 ≤ bookQuadraticFormV2 B p

/-- The printed Chapter 2 definition of positive semidefiniteness. -/
def positiveSemidefiniteTargetV2 : Prop :=
  ∀ (n : ℕ), 0 < n → ∀ (B : Fin n → Fin n → ℝ),
    IsBookPositiveSemidefiniteV2 B ↔
      ∀ p : Fin n → ℝ, 0 ≤ bookQuadraticFormV2 B p

end ComputationalMathematics.Source.NocedalWright.Chapter02
