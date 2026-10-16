import ComputationalMathematics.Optimization.Convex.Euclidean

/-!
# Nocedal--Wright linear-function convexity target
-/

open scoped BigOperators

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Every affine scalar function `x ↦ cᵀx + α` is convex. -/
def linearFunctionConvexTarget : Prop :=
  ∀ {n : ℕ} (c : Fin n → ℝ) (α : ℝ),
    ConvexOn ℝ Set.univ (fun x : Fin n → ℝ => (∑ i, c i * x i) + α)

end ComputationalMathematics.Source.NocedalWright.Chapter01
