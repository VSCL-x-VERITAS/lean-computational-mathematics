import ComputationalMathematics.Analysis.SingularValues.Projections

/-!
# Vershynin Chapter 4, Exercise 4.1.8

Source contract for the isometries and projections obtained by selecting
columns or rows of an orthogonal matrix.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.1.8: any submatrix formed from distinct columns of a
real orthogonal matrix is an isometry, while the corresponding statement for
distinct rows gives a projection. -/
theorem hdp_04_exercise_4_1_8 {N k : ℕ}
    (U : Matrix (Fin N) (Fin N) ℝ)
    (hU : U ∈ Matrix.orthogonalGroup (Fin N) ℝ)
    (f : Fin k → Fin N) (hf : Function.Injective f) :
    NumStability.IsRealMatrixIsometry (U.submatrix id f) ∧
      NumStability.IsRealMatrixProjection (U.submatrix f id) :=
  ⟨NumStability.selectedColumns_isRealMatrixIsometry U hU f hf,
    NumStability.selectedRows_isRealMatrixProjection U hU f hf⟩

end NumStability.HDP.Contract
