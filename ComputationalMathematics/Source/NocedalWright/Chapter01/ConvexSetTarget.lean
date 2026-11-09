import ComputationalMathematics.Optimization.Convex.Euclidean

/-!
# Nocedal--Wright convex-set definition target
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The source's segment formulation of convexity agrees with Mathlib's
two-weight formulation over finite-dimensional real space. -/
def convexSetDefinitionTarget : Prop :=
  ∀ {n : ℕ} (s : Set (Fin n → ℝ)),
    Convex ℝ s ↔
      ∀ x ∈ s, ∀ y ∈ s, ∀ α : ℝ,
        0 ≤ α → α ≤ 1 → α • x + (1 - α) • y ∈ s

end ComputationalMathematics.Source.NocedalWright.Chapter01
