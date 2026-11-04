import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.DotProduct

/-!
# Euclidean norm of a matrix-vector product
-/

open Matrix WithLp

namespace NumStability.HDP.Matrix

/-- The squared Euclidean norm of `Ax` is the sum of the squared row
inner-products with `x`. -/
theorem norm_sq_toLp_mulVec {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (x : Fin n → ℝ) :
  ‖(WithLp.toLp 2 (A.mulVec x) : EuclideanSpace ℝ (Fin m))‖ ^ 2 =
      ∑ i, (dotProduct (A i) x) ^ 2 := by
  rw [← real_inner_self_eq_norm_sq]
  change (∑ i, (∑ j, A i j * x j) * (∑ j, A i j * x j)) =
    ∑ i, (∑ j, A i j * x j) ^ 2
  simp only [pow_two]

end NumStability.HDP.Matrix
