import ComputationalMathematics.Source.NocedalWright.Chapter02.ConstantLocalTargetRev2

/-! The constant-two example from Nocedal and Wright, Chapter 2. -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Every point in a positive-dimensional Euclidean space is a weak local
minimizer of the constant-two objective. -/
theorem constantTwoWeakLocalMinimizer : constantTwoLocalMinTargetRev2 := by
  intro n _ x
  exact isLocalMin_const

end ComputationalMathematics.Source.NocedalWright.Chapter02
