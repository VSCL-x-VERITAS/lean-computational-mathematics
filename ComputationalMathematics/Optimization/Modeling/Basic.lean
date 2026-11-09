import ComputationalMathematics.Optimization.Convex.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Real.Sqrt

/-!
# Basic finite-dimensional optimization modeling imports

This reusable module supplies finite sums, finite coordinate spaces, and the
real-order API used by elementary optimization models.
-/

noncomputable section

namespace ComputationalMathematics.Optimization.Modeling

/-- A constrained problem is convex when its objective is convex, each equality
constraint is affine (both convex and concave), and each nonnegative inequality
constraint is concave. This matches the sign convention of Nocedal--Wright (1.1). -/
def IsConvexProgram {X : Type} [AddCommMonoid X] [Module ℝ X]
    {ε ι : Type} (objective : X → ℝ) (equality : ε → X → ℝ)
    (inequality : ι → X → ℝ) : Prop :=
  ConvexOn ℝ Set.univ objective ∧
    (∀ k, ConvexOn ℝ Set.univ (equality k) ∧ ConcaveOn ℝ Set.univ (equality k)) ∧
    ∀ k, ConcaveOn ℝ Set.univ (inequality k)

end ComputationalMathematics.Optimization.Modeling
