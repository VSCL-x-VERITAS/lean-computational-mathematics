import ComputationalMathematics.Source.NocedalWright.Chapter01.Example12TargetV2

/-! # Nocedal--Wright example (1.2) -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The constrained problem (1.2) has a feasible global solution. -/
theorem example12HasSolution : example12HasSolutionTargetV2 := by
  unfold example12HasSolutionTargetV2
  refine ⟨1, 1, by norm_num, by norm_num, ?_⟩
  intro y₁ y₂ hy₁ hy₂
  nlinarith [sq_nonneg (y₁ - 1), sq_nonneg (y₂ - 1)]

end ComputationalMathematics.Source.NocedalWright.Chapter01
