import ComputationalMathematics.Source.NocedalWright.Chapter01.MaxAsMinTarget

/-! # Nocedal--Wright maximization as minimization -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Maximizing a function is minimizing its pointwise negative. -/
theorem maxAsMin : maxAsMinTarget := by
  unfold maxAsMinTarget
  aesop

end ComputationalMathematics.Source.NocedalWright.Chapter01
