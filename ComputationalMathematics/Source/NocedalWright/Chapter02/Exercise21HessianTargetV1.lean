import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21GradientTargetV1
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The matrix of second coordinate partials of the Exercise 2.1 polynomial. -/
def rosenbrockHessianFormulaV1
    (x : EuclideanSpace ℝ (Fin 2)) (i j : Fin 2) : ℝ :=
  if i = 0 then
    if j = 0 then 1200 * (x 0)^2 - 400 * x 1 + 2 else -400 * x 0
  else
    if j = 0 then -400 * x 0 else 200

/-- Exercise 2.1 computes the Hessian entrywise at every point of ℝ². -/
def exercise21HessianTargetV1 : Prop :=
  ∀ x : EuclideanSpace ℝ (Fin 2),
    (∀ i : Fin 2,
      DifferentiableAt ℝ
        (fun s : ℝ =>
          rosenbrockObjectiveV1 (x + s • EuclideanSpace.single i 1)) 0) ∧
    (∀ i j : Fin 2,
      HasDerivAt
        (fun t : ℝ =>
          deriv
            (fun s : ℝ =>
              rosenbrockObjectiveV1
                ((x + t • EuclideanSpace.single j 1) +
                  s • EuclideanSpace.single i 1)) 0)
        (rosenbrockHessianFormulaV1 x i j) 0)

end ComputationalMathematics.Source.NocedalWright.Chapter02
