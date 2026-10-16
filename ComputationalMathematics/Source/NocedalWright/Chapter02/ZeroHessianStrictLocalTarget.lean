import ComputationalMathematics.Optimization.Convex.Euclidean
import Mathlib.Analysis.Calculus.IteratedDeriv.Defs

/-! Chapter 2: a strict local minimum need not have a positive definite Hessian. -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Proof-free source target for the univariate `x^4` example. -/
def zeroHessianStrictLocalTarget : Prop :=
  (∀ᶠ y in nhds (0 : ℝ), y ≠ 0 → ((0 : ℝ) ^ 4) < y ^ 4) ∧
    iteratedDeriv 2 (fun x : ℝ => x ^ 4) 0 = 0

end ComputationalMathematics.Source.NocedalWright.Chapter02
