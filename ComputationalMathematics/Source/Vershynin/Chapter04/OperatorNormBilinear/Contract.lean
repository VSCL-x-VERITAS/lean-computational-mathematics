import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Vershynin, Chapter 4, bilinear operator norm

Source-correspondence contract for the bilinear two-sphere characterization of
the Euclidean operator norm.
-/

namespace NumStability.HDP.Contract

/-- Printed page 76: for a real `m` by `n` matrix with nonzero domain and
codomain dimensions, the operator norm is the maximum of `⟪A x, y⟫_ℝ` over
unit vectors `x` and `y`. -/
theorem hdp_04_operator_norm_bilinear {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (A : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.IsRealMatrixBilinearOperatorNorm A
      (NumStability.realMatrixOperatorNorm A) :=
  NumStability.realMatrixOperatorNorm_bilinear_characterization hm hn A

end NumStability.HDP.Contract
