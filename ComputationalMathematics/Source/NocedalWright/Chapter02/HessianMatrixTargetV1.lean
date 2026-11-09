import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
Proof-free coordinate Hessian-matrix target for Chapter 2.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The matrix whose i,j entry is the j-th directional derivative of the i-th
gradient component, matching the book Hessian on a C² neighborhood. -/
noncomputable def bookHessianMatrixV1 {n : ℕ}
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (x : EuclideanSpace ℝ (Fin n)) : Fin n → Fin n → ℝ :=
  fun i j => fderiv ℝ (fun y => (gradient f y) i) x (EuclideanSpace.single j 1)

end ComputationalMathematics.Source.NocedalWright.Chapter02
