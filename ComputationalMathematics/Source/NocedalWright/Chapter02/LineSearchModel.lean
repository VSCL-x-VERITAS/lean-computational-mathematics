import ComputationalMathematics.Source.NocedalWright.Chapter02.LineSearchModelTarget

/-! Exact wrapper for Nocedal and Wright, Chapter 2, model (2.10). -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The positive-step line-search model has exactly the feasible set and
one-dimensional objective displayed in (2.10). The last conjunct interprets
an exact solution only when one is supplied. -/
theorem lineSearchModel : lineSearchModelTarget := by
  intro n hn f hf x p α
  simp [lineSearchSteps, lineSearchObjective, isMinOn_iff]

end ComputationalMathematics.Source.NocedalWright.Chapter02
