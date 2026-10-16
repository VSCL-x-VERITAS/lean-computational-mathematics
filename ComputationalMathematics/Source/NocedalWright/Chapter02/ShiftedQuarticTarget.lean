import ComputationalMathematics.Optimization.Convex.Euclidean

/-! Chapter 2: the shifted quartic has a strict local minimum at two. -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Proof-free source target for the strict-local-minimum example. -/
def shiftedQuarticStrictLocalTarget : Prop :=
  ∀ᶠ y in nhds (2 : ℝ),
    y ≠ 2 → ((2 - 2 : ℝ) ^ 4) < (y - 2) ^ 4

end ComputationalMathematics.Source.NocedalWright.Chapter02
