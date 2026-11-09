import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise23QuadraticHessianTargetV1
import Mathlib.Analysis.InnerProductSpace.Calculus
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
The Hessian of a symmetric quadratic form in Nocedal and Wright,
*Numerical Optimization*, second edition, Exercise 2.3.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The iterated coordinate partials of `x ↦ xᵀAx` form the matrix `2A`. -/
theorem exercise23QuadraticHessianV1 : exercise23QuadraticHessianTargetV1 := by
  intro n _ A hA x
  let L : EuclideanSpace ℝ (Fin n) →L[ℝ] EuclideanSpace ℝ (Fin n) :=
    A.toEuclideanLin.toContinuousLinearMap
  have hpath (z v : EuclideanSpace ℝ (Fin n)) :
      HasDerivAt (fun s : ℝ => z + s • v) v 0 := by
    simpa using ((hasDerivAt_id (x := (0 : ℝ))).smul_const v).const_add z
  have hmap (z v : EuclideanSpace ℝ (Fin n)) :
      HasDerivAt (fun s : ℝ => L (z + s • v)) (L v) 0 := by
    simpa only [map_add, map_smul] using hpath (L z) (L v)
  have hpartial (z : EuclideanSpace ℝ (Fin n)) (i : Fin n) :
      HasDerivAt
        (fun s : ℝ => inner ℝ (z + s • EuclideanSpace.single i 1)
          (L (z + s • EuclideanSpace.single i 1)))
        (inner ℝ z (L (EuclideanSpace.single i 1)) +
          inner ℝ (EuclideanSpace.single i 1) (L z)) 0 := by
    simpa using (hpath z (EuclideanSpace.single i 1)).inner ℝ
      (hmap z (EuclideanSpace.single i 1))
  have hentry (i j : Fin n) :
      inner ℝ (EuclideanSpace.single i 1) (L (EuclideanSpace.single j 1)) =
        A i j := by
    change dotProduct (A.mulVec (Pi.single j 1)) (Pi.single i 1) = A i j
    simp
  constructor
  · intro i
    exact (hpartial x i).differentiableAt
  · intro i j
    have hfirst :
        (fun t : ℝ => deriv
          (fun s : ℝ => inner ℝ
            ((x + t • EuclideanSpace.single j 1) + s • EuclideanSpace.single i 1)
            (L ((x + t • EuclideanSpace.single j 1) +
              s • EuclideanSpace.single i 1))) 0) =
        fun t : ℝ =>
          inner ℝ (x + t • EuclideanSpace.single j 1) (L (EuclideanSpace.single i 1)) +
          inner ℝ (EuclideanSpace.single i 1) (L (x + t • EuclideanSpace.single j 1)) := by
      funext t
      exact (hpartial (x + t • EuclideanSpace.single j 1) i).deriv
    change HasDerivAt
      (fun t : ℝ => deriv
        (fun s : ℝ => inner ℝ
          ((x + t • EuclideanSpace.single j 1) + s • EuclideanSpace.single i 1)
          (L ((x + t • EuclideanSpace.single j 1) +
            s • EuclideanSpace.single i 1))) 0) (2 * A i j) 0
    rw [hfirst]
    have hsecond :=
      ((hpath x (EuclideanSpace.single j 1)).inner ℝ
        (hasDerivAt_const (0 : ℝ) (L (EuclideanSpace.single i 1)))).add
      ((hasDerivAt_const (0 : ℝ) (EuclideanSpace.single i 1)).inner ℝ
        (hmap x (EuclideanSpace.single j 1)))
    have hij : A j i = A i j := congrFun (congrFun hA.eq i) j
    simpa [hentry, hij, two_mul] using hsecond

end ComputationalMathematics.Source.NocedalWright.Chapter02
