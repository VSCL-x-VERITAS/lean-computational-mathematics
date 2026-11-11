import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise23QuadraticGradientTargetV1
import Mathlib.Analysis.InnerProductSpace.Calculus

/-!
The gradient of a symmetric quadratic form in Nocedal and Wright,
*Numerical Optimization*, second edition, Exercise 2.3.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The real symmetric quadratic form `x ↦ xᵀAx` has gradient `2Ax`. -/
theorem exercise23QuadraticGradientV1 : exercise23QuadraticGradientTargetV1 := by
  intro n _ A hA x
  let L : EuclideanSpace ℝ (Fin n) →L[ℝ] EuclideanSpace ℝ (Fin n) :=
    A.toEuclideanLin.toContinuousLinearMap
  have hsymm (u v : EuclideanSpace ℝ (Fin n)) :
      inner ℝ u (A.toEuclideanLin v) = inner ℝ (A.toEuclideanLin u) v := by
    change dotProduct (A.mulVec (WithLp.ofLp v)) (WithLp.ofLp u) =
      dotProduct (WithLp.ofLp v) (A.mulVec (WithLp.ofLp u))
    have hvec := Matrix.vecMul_transpose A (WithLp.ofLp u)
    rw [hA.eq] at hvec
    rw [dotProduct_comm, Matrix.dotProduct_mulVec, hvec]
    exact dotProduct_comm _ _
  have hD :
      (fderivInnerCLM ℝ (x, L x)).comp ((ContinuousLinearMap.id ℝ _).prod L) =
        InnerProductSpace.toDual ℝ _ ((2 : ℝ) • A.toEuclideanLin x) := by
    ext v
    change inner ℝ x (A.toEuclideanLin v) + inner ℝ v (A.toEuclideanLin x) =
      inner ℝ ((2 : ℝ) • A.toEuclideanLin x) v
    rw [hsymm, real_inner_comm (A.toEuclideanLin x) v]
    simp only [inner_smul_left, map_ofNat, two_mul]
  have hg : HasGradientAt
      (fun y : EuclideanSpace ℝ (Fin n) => inner ℝ y (A.toEuclideanLin y))
      ((2 : ℝ) • A.toEuclideanLin x) x := by
    apply hasGradientAt_iff_hasFDerivAt.mpr
    rw [← hD]
    exact (hasFDerivAt_id x).inner ℝ (L.hasFDerivAt (x := x))
  exact ⟨hg.differentiableAt, hg.gradient⟩

end ComputationalMathematics.Source.NocedalWright.Chapter02
