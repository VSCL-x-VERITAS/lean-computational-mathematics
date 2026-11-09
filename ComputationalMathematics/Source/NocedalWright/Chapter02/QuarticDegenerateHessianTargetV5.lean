import ComputationalMathematics.Source.NocedalWright.Chapter02.QuarticArithmeticEvidenceV1
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Order.Filter.Extr

/-!
# The quartic strict minimum and its degenerate Hessian

Proof-free target for the concrete counterexample on printed page 16 of
Nocedal and Wright, *Numerical Optimization*, second edition. The fixed
polynomial `x^4` supplies the book's ambient smoothness automatically.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The real quartic has a strict local minimum at zero, but its Hessian there
is zero and fails the one-dimensional positive-definiteness condition. -/
def quarticDegenerateHessianTargetV5 : Prop :=
  (∃ N : Set ℝ, IsOpen N ∧ (0 : ℝ) ∈ N ∧
    ∀ x ∈ N, x ≠ 0 → (0 : ℝ) ^ 4 < x ^ 4) ∧
  deriv (deriv (fun x : ℝ => x ^ 4)) 0 = 0 ∧
  ¬ (∀ p : ℝ, p ≠ 0 →
    0 < p * deriv (deriv (fun x : ℝ => x ^ 4)) 0 * p)

end ComputationalMathematics.Source.NocedalWright.Chapter02
