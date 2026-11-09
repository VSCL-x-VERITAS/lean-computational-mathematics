import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The two-variable Rosenbrock function in Exercise 2.1. -/
def rosenbrockObjectiveV1 (x : EuclideanSpace ℝ (Fin 2)) : ℝ :=
  100 * (x 1 - (x 0)^2)^2 + (1 - x 0)^2

/-- Exercise 2.1 asks for the gradient at every point of ℝ². -/
def exercise21GradientTargetV1 : Prop :=
  ∀ x : EuclideanSpace ℝ (Fin 2),
    DifferentiableAt ℝ rosenbrockObjectiveV1 x ∧
    gradient rosenbrockObjectiveV1 x =
      EuclideanSpace.single 0
        (-400 * x 0 * (x 1 - (x 0)^2) - 2 * (1 - x 0)) +
      EuclideanSpace.single 1
        (200 * (x 1 - (x 0)^2))

end ComputationalMathematics.Source.NocedalWright.Chapter02
