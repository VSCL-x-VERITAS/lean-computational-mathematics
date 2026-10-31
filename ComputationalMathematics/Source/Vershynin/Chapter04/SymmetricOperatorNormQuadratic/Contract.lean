import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Vershynin, Chapter 4, symmetric quadratic operator norm

Source-correspondence contract for computing a real symmetric matrix's
operator norm from its quadratic form on the unit sphere.
-/

namespace NumStability.HDP.Contract

/-- Printed page 89, with the absolute-value interpretation made explicit in
Exercise 4.4.3(b): for a positive-dimensional real symmetric matrix, the
operator norm is the maximum absolute quadratic-form value on the unit sphere. -/
theorem hdp_04_symmetric_operator_norm_quadratic {n : ℕ} (hn : 0 < n)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) :
    NumStability.IsSymmetricRealMatrixQuadraticOperatorNorm A
      (NumStability.realMatrixOperatorNorm A) :=
  NumStability.symmetricRealMatrixOperatorNorm_quadratic_characterization hn A hA

end NumStability.HDP.Contract
