import ComputationalMathematics.Optimization.Convex.Euclidean

open scoped Matrix

/-!
# Nocedal--Wright polyhedron convexity target
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- A finite-dimensional set cut out by linear equalities and componentwise
linear inequalities is convex. -/
def polyhedronConvexTarget : Prop :=
  ∀ (n m p : ℕ) (A : Matrix (Fin m) (Fin n) ℝ)
    (C : Matrix (Fin p) (Fin n) ℝ) (b : Fin m → ℝ) (d : Fin p → ℝ),
    Convex ℝ {x : Fin n → ℝ | (A *ᵥ x) = b ∧ ∀ i, (C *ᵥ x) i ≤ d i}

end ComputationalMathematics.Source.NocedalWright.Chapter01
