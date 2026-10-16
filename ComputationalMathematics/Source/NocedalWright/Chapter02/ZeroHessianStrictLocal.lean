import ComputationalMathematics.Source.NocedalWright.Chapter02.ZeroHessianStrictLocalTarget
import Mathlib.Analysis.Calculus.IteratedDeriv.Lemmas

/-! The zero-Hessian strict-local-minimum example from Nocedal and Wright, Chapter 2. -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The function `x^4` has a strict local minimum at zero, with zero second derivative there. -/
theorem zeroHessianStrictLocalExample : zeroHessianStrictLocalTarget := by
  unfold zeroHessianStrictLocalTarget
  constructor
  · apply Filter.Eventually.of_forall
    intro y hy
    have hpos : (0 : ℝ) < y ^ 4 := Even.pow_pos (by decide : Even 4) hy
    simpa using hpos
  · simp

end ComputationalMathematics.Source.NocedalWright.Chapter02
