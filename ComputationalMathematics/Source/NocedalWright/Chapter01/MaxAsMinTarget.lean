import ComputationalMathematics.Optimization.Modeling.Basic

/-!
# Nocedal--Wright maximization-as-minimization target
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Maximizing a real-valued function on a feasible set is equivalent to
minimizing its pointwise negative on the same set. -/
def maxAsMinTarget : Prop :=
  ∀ {n : ℕ} (s : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ),
    (x ∈ s ∧ ∀ y ∈ s, f y ≤ f x) ↔
      (x ∈ s ∧ ∀ y ∈ s, -f x ≤ -f y)

end ComputationalMathematics.Source.NocedalWright.Chapter01
