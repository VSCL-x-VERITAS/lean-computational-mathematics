import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Tensor.Specializations

/-!
# Vershynin Chapter 4: Frobenius norm from the matrix inner product

Thin source contract for the norm-square identity induced by the canonical
inner product of real rectangular matrices.
-/

namespace NumStability.HDP.Contract

open scoped BigOperators

/-- Vershynin, Chapter 4, p. 77: the canonical matrix inner product generates
the Frobenius norm. -/
theorem hdp_04_frobenius_norm_sq_eq_inner_self {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.frobNormRect A ^ 2 =
      NumStability.HDP.Tensor.inner
        (NumStability.HDP.Tensor.matrixTensor A)
        (NumStability.HDP.Tensor.matrixTensor A) := by
  rw [NumStability.frobNormRect_sq,
    NumStability.HDP.Tensor.inner_matrixTensor_eq_sum]
  unfold NumStability.frobNormSqRect
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  ring

end NumStability.HDP.Contract
