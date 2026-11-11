import Mathlib.Analysis.InnerProductSpace.Calculus
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
Proof-free target for the Hessian of f₁(x) = aᵀx in Exercise 2.3 of
Nocedal and Wright, Numerical Optimization, second edition.
The Hessian entries are iterated coordinate partial derivatives.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Exercise 2.3's linear-function Hessian claim. -/
def exercise23LinearHessianTargetV1 : Prop :=
  ∀ (n : ℕ), 0 < n →
    ∀ (a x : EuclideanSpace ℝ (Fin n)),
      (∀ i : Fin n,
        DifferentiableAt ℝ
          (fun s : ℝ => inner ℝ a (x + s • EuclideanSpace.single i 1)) 0) ∧
      (∀ i j : Fin n,
        HasDerivAt
          (fun t : ℝ => deriv
            (fun s : ℝ => inner ℝ a
              ((x + t • EuclideanSpace.single j 1) + s • EuclideanSpace.single i 1)) 0)
          0 0)

end ComputationalMathematics.Source.NocedalWright.Chapter02
