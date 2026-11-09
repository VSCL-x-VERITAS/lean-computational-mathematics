import Mathlib.Data.Real.Basic

/-!
# Exercise 2.13: convergence of the reciprocal sequence

Proof-free target for the convergence assertion in Nocedal and Wright,
*Numerical Optimization*, second edition, printed page 29. Positive tail
thresholds keep every denominator inside the source sequence's domain.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The Appendix A.2 epsilon–threshold definition of convergence to zero for `1 / k`. -/
def exercise213LimitTargetV1 : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ K : ℕ, 0 < K ∧
    ∀ k : ℕ, K ≤ k → |(1 : ℝ) / (k : ℝ)| ≤ ε

end ComputationalMathematics.Source.NocedalWright.Chapter02
