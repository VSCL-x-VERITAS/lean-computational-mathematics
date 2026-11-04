import ComputationalMathematics.Analysis.SingularValues.Symmetric

/-!
# Vershynin, Chapter 4, symmetric-matrix singular values

Source-correspondence contract for the symmetric-matrix specialization in
Section 4.1.1.
-/

namespace NumStability.HDP.Contract

/-- Printed page 76: for a real symmetric matrix, the singular values are the
absolute values of its eigenvalues, and both left and right singular vectors
are eigenvectors of the matrix. -/
theorem hdp_04_symmetric_singular_values {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) :
    ∃ (eigenvalue singularValue : Fin n → ℝ)
      (leftVector rightVector : Fin n → EuclideanSpace ℝ (Fin n)),
      NumStability.IsSymmetricRealMatrixSVD A eigenvalue singularValue
        leftVector rightVector :=
  NumStability.exists_isSymmetricRealMatrixSVD A hA

end NumStability.HDP.Contract
