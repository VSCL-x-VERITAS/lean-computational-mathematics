import ComputationalMathematics.Optimization.Convex.Euclidean

/-!
# Nocedal--Wright strict-convexity definition target
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The source's strict form of (1.4) agrees with strict convexity on a convex
domain. -/
def strictConvexDefinitionTarget : Prop :=
  ∀ {n : ℕ} (s : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ),
    StrictConvexOn ℝ s f ↔
      Convex ℝ s ∧
        ∀ x ∈ s, ∀ y ∈ s, x ≠ y → ∀ α : ℝ,
          0 < α → α < 1 →
            f (α • x + (1 - α) • y) < α * f x + (1 - α) * f y

end ComputationalMathematics.Source.NocedalWright.Chapter01
