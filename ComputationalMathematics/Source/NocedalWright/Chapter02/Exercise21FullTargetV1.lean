import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21GradientTargetV1
import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21HessianTargetV1
import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21UniqueLocalMinimizerTargetV1
import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21PositiveHessianTargetV1

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- All four requests in Nocedal and Wright, Exercise 2.1. -/
def exercise21FullTargetV1 : Prop :=
  exercise21GradientTargetV1 ∧
  exercise21HessianTargetV1 ∧
  exercise21UniqueLocalMinimizerTargetV1 ∧
  exercise21PositiveHessianTargetV1

end ComputationalMathematics.Source.NocedalWright.Chapter02
