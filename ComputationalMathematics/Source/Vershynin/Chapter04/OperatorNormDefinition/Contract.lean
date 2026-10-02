import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Vershynin, Chapter 4, operator norm

Source-correspondence contract for the operator-norm definition and its two
attained maximum forms.
-/

namespace NumStability.HDP.Contract

/-- Printed page 76: for a real m by n matrix with nonzero domain dimension,
the subordinate Euclidean operator norm is both the maximum nonzero-vector
ratio and the maximum image norm on the unit sphere. -/
theorem hdp_04_operator_norm_definition {m n : ℕ} (hn : 0 < n)
    (A : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.IsRealMatrixOperatorNorm A
      (NumStability.realMatrixOperatorNorm A) :=
  NumStability.realMatrixOperatorNorm_characterization hn A

end NumStability.HDP.Contract
