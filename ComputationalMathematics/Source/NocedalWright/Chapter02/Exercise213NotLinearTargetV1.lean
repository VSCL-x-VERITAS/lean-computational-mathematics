import Mathlib.Data.Real.Basic

/-!
# Exercise 2.13: failure of Q-linear convergence

Proof-free target for the rate assertion in Nocedal and Wright,
*Numerical Optimization*, second edition, printed page 29. It negates the
eventual contraction bound in Appendix A.2, equation (A.34), at the fixed limit zero.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Every proposed contraction factor fails on every positive tail of `1 / k`. -/
def exercise213NotLinearTargetV1 : Prop :=
  ∀ r : ℝ, 0 < r → r < 1 → ∀ K : ℕ, 0 < K →
    ∃ k : ℕ, K ≤ k ∧
      r < |(1 : ℝ) / ((k + 1 : ℕ) : ℝ)| / |(1 : ℝ) / (k : ℝ)|

end ComputationalMathematics.Source.NocedalWright.Chapter02
