import ComputationalMathematics.Source.NocedalWright.Chapter02.GlobalMinimizerFullSpaceTargetV1

/-!
The full-space global-minimizer definition in Chapter 2 of Nocedal and Wright,
*Numerical Optimization*, second edition.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The full-space minimum predicate is exactly the book's universal inequality. -/
theorem globalMinimizerFullSpaceV1 : globalMinimizerFullSpaceTargetV1 := by
  intro n hn f hf xstar
  exact isMinOn_univ_iff

end ComputationalMathematics.Source.NocedalWright.Chapter02
