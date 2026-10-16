import ComputationalMathematics.Optimization.Convex.Euclidean

/-!
# Nocedal--Wright convex-function inequality (1.4) target
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Equation (1.4), together with convexity of the domain, is equivalent to
convexity of a real-valued function on that domain. -/
def convexFunction14Target : Prop :=
  ∀ {n : ℕ} (s : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ),
    ConvexOn ℝ s f ↔
      Convex ℝ s ∧
        ∀ x ∈ s, ∀ y ∈ s, ∀ α : ℝ,
          0 ≤ α → α ≤ 1 →
            f (α • x + (1 - α) • y) ≤ α * f x + (1 - α) * f y

end ComputationalMathematics.Source.NocedalWright.Chapter01
