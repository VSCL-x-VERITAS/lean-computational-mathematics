import ComputationalMathematics.Optimization.Convex.Euclidean
import Mathlib.Analysis.InnerProductSpace.EuclideanDist

/-!
# Nocedal--Wright Euclidean unit-ball target, revision 2
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The Euclidean unit ball in real finite-dimensional space is convex. Using
`EuclideanSpace` fixes the intended Euclidean norm rather than the product
supremum norm on plain function spaces. -/
def euclideanUnitBallConvexTargetV2 : Prop :=
  ∀ n : ℕ, Convex ℝ {y : EuclideanSpace ℝ (Fin n) | ‖y‖ ≤ 1}

end ComputationalMathematics.Source.NocedalWright.Chapter01
