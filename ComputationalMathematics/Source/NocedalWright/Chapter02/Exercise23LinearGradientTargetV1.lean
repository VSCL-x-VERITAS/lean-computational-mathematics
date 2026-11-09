import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.InnerProductSpace.Calculus

/-!
Proof-free target for the gradient of f₁(x) = aᵀx in Nocedal and Wright,
*Numerical Optimization*, second edition, Exercise 2.3.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

def exercise23LinearGradientTargetV1 : Prop :=
  ∀ (n : ℕ), 0 < n →
    ∀ (a x : EuclideanSpace ℝ (Fin n)),
      DifferentiableAt ℝ (fun y : EuclideanSpace ℝ (Fin n) => inner ℝ a y) x ∧
      gradient (fun y : EuclideanSpace ℝ (Fin n) => inner ℝ a y) x = a

end ComputationalMathematics.Source.NocedalWright.Chapter02
