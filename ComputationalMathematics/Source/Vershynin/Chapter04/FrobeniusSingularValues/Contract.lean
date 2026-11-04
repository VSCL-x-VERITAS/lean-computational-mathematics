import ComputationalMathematics.Analysis.SingularValues.Realification

/-!
# Vershynin Chapter 4: Frobenius norm and singular values

Thin source contract for the expression of the Frobenius norm as the
Euclidean norm of the singular-value vector.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Chapter 4, p. 77: the Frobenius norm is the square root of the
sum of the squared singular values. -/
theorem hdp_04_frobenius_norm_eq_sqrt_sum_singular_values_sq
    {m n : ℕ} (A : Fin m → Fin n → ℝ) :
    NumStability.frobNormRect A =
      Real.sqrt
        (∑ i : Fin n,
          NumStability.complexMatrixSingularValue
            (NumStability.realRectToCMatrix A) i ^ 2) := by
  rw [NumStability.frobNormRect_eq_complexMatrixFrobenius_realRectToCMatrix]
  exact
    NumStability.complexMatrixFrobenius_eq_sqrt_sum_singularValue_sq
      (NumStability.realRectToCMatrix A)

end NumStability.HDP.Contract
