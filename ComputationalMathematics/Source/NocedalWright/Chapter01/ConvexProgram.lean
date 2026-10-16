import ComputationalMathematics.Source.NocedalWright.Chapter01.ConvexProgramTargetV4

/-! # Nocedal--Wright convex programs -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

open ComputationalMathematics.Optimization.Modeling

/-- The convex-program classification uses the objective, equality, and
inequality conditions on their respective declared domains. -/
theorem convexProgramDefinition : convexProgramDefinitionTargetV4 := by
  unfold convexProgramDefinitionTargetV4 IsConvexProgramOnDomains
  intro n ε ι objectiveDomain equalityDomain inequalityDomain objective equality inequality
  rfl

end ComputationalMathematics.Source.NocedalWright.Chapter01
