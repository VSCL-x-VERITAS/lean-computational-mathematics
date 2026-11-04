import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD

/-!
# Vershynin, Chapter 4, singular-vector/eigenvalue relations

Source-correspondence contract for the paragraph following Equation (4.1).
-/

namespace NumStability.HDP.Contract

/-- Printed pages 75–76: the left and right singular-vector families are
orthonormal eigenvectors of `A Aᵀ` and `Aᵀ A`; their Gram eigenvalue is the
square of the corresponding nonnegative singular value. -/
theorem hdp_04_singular_eigenvalue_relations {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ (r : ℕ) (s : Fin n → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin n)),
      NumStability.IsRealMatrixSVDWithGramEigenrelations A r s u v :=
  NumStability.exists_isRealMatrixSVDWithGramEigenrelations A

end NumStability.HDP.Contract
