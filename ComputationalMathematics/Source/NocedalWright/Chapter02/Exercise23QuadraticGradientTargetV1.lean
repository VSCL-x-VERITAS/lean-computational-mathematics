import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.Symmetric

/-!
Proof-free target for the gradient of f₂(x) = xᵀAx in Exercise 2.3 of
Nocedal and Wright, Numerical Optimization, second edition.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

def exercise23QuadraticGradientTargetV1 : Prop :=
  ∀ (n : ℕ), 0 < n →
    ∀ (A : Matrix (Fin n) (Fin n) ℝ), A.IsSymm →
      ∀ x : EuclideanSpace ℝ (Fin n),
        DifferentiableAt ℝ
          (fun y : EuclideanSpace ℝ (Fin n) => inner ℝ y (A.toEuclideanLin y)) x ∧
        gradient (fun y : EuclideanSpace ℝ (Fin n) => inner ℝ y (A.toEuclideanLin y)) x =
          (2 : ℝ) • A.toEuclideanLin x

end ComputationalMathematics.Source.NocedalWright.Chapter02
