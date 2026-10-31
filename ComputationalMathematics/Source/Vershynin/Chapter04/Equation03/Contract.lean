import ComputationalMathematics.HDP.Tensor.Specializations

/-!
# Vershynin Chapter 4: Equation (4.3)

Thin source contract for the canonical inner product of real rectangular
matrices, in trace and entrywise forms.
-/

namespace NumStability.HDP.Contract

open scoped BigOperators

/-- Vershynin, Equation (4.3): the canonical matrix inner product is both the
trace of `AᵀB` and the sum of the entrywise products. The identity also
includes matrices with an empty row or column index set. -/
theorem hdp_04_eq_4_3 {m n : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.HDP.Tensor.inner
          (NumStability.HDP.Tensor.matrixTensor A)
          (NumStability.HDP.Tensor.matrixTensor B) =
        Matrix.trace (A.transpose * B) ∧
      NumStability.HDP.Tensor.inner
          (NumStability.HDP.Tensor.matrixTensor A)
          (NumStability.HDP.Tensor.matrixTensor B) =
        ∑ i, ∑ j, A i j * B i j := by
  exact
    ⟨NumStability.HDP.Tensor.inner_matrixTensor_eq_trace A B,
      NumStability.HDP.Tensor.inner_matrixTensor_eq_sum A B⟩

end NumStability.HDP.Contract
