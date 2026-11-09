import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise23LinearHessianTargetV1
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
The Hessian of a linear functional in Nocedal and Wright,
*Numerical Optimization*, second edition, Exercise 2.3.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Every iterated coordinate partial of the linear functional is zero. -/
theorem exercise23LinearHessianV1 : exercise23LinearHessianTargetV1 := by
  intro n _ a x
  have hpartial (z : EuclideanSpace ℝ (Fin n)) (i : Fin n) :
      HasDerivAt
        (fun s : ℝ => inner ℝ a (z + s • EuclideanSpace.single i 1))
        (inner ℝ a (EuclideanSpace.single i 1)) 0 := by
    simpa using
      (hasDerivAt_const (0 : ℝ) a).inner ℝ
        (((hasDerivAt_id (x := (0 : ℝ))).smul_const
          (EuclideanSpace.single i 1)).const_add z)
  constructor
  · intro i
    exact (hpartial x i).differentiableAt
  · intro i j
    have hconstant :
        (fun t : ℝ => deriv
          (fun s : ℝ => inner ℝ a
            ((x + t • EuclideanSpace.single j 1) + s • EuclideanSpace.single i 1)) 0) =
          fun _ : ℝ => inner ℝ a (EuclideanSpace.single i 1) := by
      funext t
      exact (hpartial (x + t • EuclideanSpace.single j 1) i).deriv
    rw [hconstant]
    exact hasDerivAt_const 0 _

end ComputationalMathematics.Source.NocedalWright.Chapter02
