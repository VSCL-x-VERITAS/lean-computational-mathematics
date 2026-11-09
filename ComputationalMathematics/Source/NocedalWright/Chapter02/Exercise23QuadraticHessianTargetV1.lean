import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.Symmetric

/-!
Proof-free target for the Hessian of f₂(x) = xᵀAx in Exercise 2.3 of
Nocedal and Wright, Numerical Optimization, second edition.
The Hessian is the matrix of iterated coordinate partial derivatives.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

def exercise23QuadraticHessianTargetV1 : Prop :=
  ∀ (n : ℕ), 0 < n →
    ∀ (A : Matrix (Fin n) (Fin n) ℝ), A.IsSymm →
      ∀ x : EuclideanSpace ℝ (Fin n),
        let f : EuclideanSpace ℝ (Fin n) → ℝ := fun y => inner ℝ y (A.toEuclideanLin y)
        (∀ i : Fin n,
          DifferentiableAt ℝ (fun s : ℝ => f (x + s • EuclideanSpace.single i 1)) 0) ∧
        (∀ i j : Fin n,
          HasDerivAt
            (fun t : ℝ => deriv
              (fun s : ℝ => f
                ((x + t • EuclideanSpace.single j 1) + s • EuclideanSpace.single i 1)) 0)
            (2 * A i j) 0)

end ComputationalMathematics.Source.NocedalWright.Chapter02
