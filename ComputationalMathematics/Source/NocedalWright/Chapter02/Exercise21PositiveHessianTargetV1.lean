import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21GradientTargetV1
import ComputationalMathematics.Source.NocedalWright.Chapter02.HessianMatrixTargetV1
import ComputationalMathematics.Source.NocedalWright.Chapter02.PositiveDefiniteTargetV2

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Exercise 2.1: the Hessian of the fixed Rosenbrock function is positive
definite at the printed point (1,1). -/
def exercise21PositiveHessianTargetV1 : Prop :=
  let xstar : EuclideanSpace ℝ (Fin 2) :=
    EuclideanSpace.single 0 1 + EuclideanSpace.single 1 1
  IsBookPositiveDefiniteV2 (bookHessianMatrixV1 rosenbrockObjectiveV1 xstar)

end ComputationalMathematics.Source.NocedalWright.Chapter02
