import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD

/-!
# Vershynin, Chapter 4, singular-value decomposition definition

Source-correspondence contract asserting existence of the rank, ordered
singular values, left and right singular vectors, zero extension, and rank-one
reconstruction described at the start of Section 4.1.1.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Chapter 4, Section 4.1.1:
every finite real rectangular matrix admits a rank-length singular-value
decomposition.  The returned certificate also fixes the book's convenient
zero extension and records the orthonormality stated immediately after the
displayed decomposition. -/
theorem hdp_04_svd_definition {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ (r : ℕ) (s : Fin n → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin n)),
      NumStability.IsRealMatrixSVD A r s u v :=
  NumStability.exists_isRealMatrixSVD A

end NumStability.HDP.Contract
