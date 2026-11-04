import ComputationalMathematics.HDP.Matrix.OperatorNorm

/-!
# Whitening on the effective covariance range

A singular covariance can be represented by a rectangular square root
`B : ℝʳ → ℝⁿ`.  The whitened error then lives in dimension `r`, and mapping it
back by `B` requires no inverse of the ambient covariance.
-/

noncomputable section

namespace NumStability.HDP.Vector.Covariance

/-- Rectangular whitening factorization: if `Σ = BBᵀ` and the empirical
second moment is `B(I+R)Bᵀ`, then its error is `BRBᵀ`. -/
theorem singularWhitening_error_factorization {n r : ℕ}
    (B : Matrix (Fin n) (Fin r) ℝ)
    (R : Matrix (Fin r) (Fin r) ℝ)
    (Sigma SigmaM : Matrix (Fin n) (Fin n) ℝ)
    (hSigma : Sigma = B * B.transpose)
    (hSigmaM : SigmaM = B * (1 + R) * B.transpose) :
    SigmaM - Sigma = B * R * B.transpose := by
  rw [hSigma, hSigmaM]
  rw [Matrix.mul_add, Matrix.add_mul]
  simp

/-- The rectangular factorization gives the same operator-norm reduction,
with the two outer factors left explicit. -/
theorem singularWhitening_error_norm_le {n r : ℕ}
    (B : Matrix (Fin n) (Fin r) ℝ)
    (R : Matrix (Fin r) (Fin r) ℝ)
    (Sigma SigmaM : Matrix (Fin n) (Fin n) ℝ)
    (hSigma : Sigma = B * B.transpose)
    (hSigmaM : SigmaM = B * (1 + R) * B.transpose) :
    ‖NumStability.realMatrixContinuousLinearMap (SigmaM - Sigma)‖ ≤
      ‖NumStability.realMatrixContinuousLinearMap B‖ *
        ‖NumStability.realMatrixContinuousLinearMap R‖ *
        ‖NumStability.realMatrixContinuousLinearMap B.transpose‖ := by
  rw [singularWhitening_error_factorization B R Sigma SigmaM hSigma hSigmaM]
  calc
    ‖NumStability.realMatrixContinuousLinearMap (B * R * B.transpose)‖ ≤
        ‖NumStability.realMatrixContinuousLinearMap (B * R)‖ *
          ‖NumStability.realMatrixContinuousLinearMap B.transpose‖ :=
      NumStability.HDP.Matrix.realMatrixOperatorNorm_mul_le (B * R) B.transpose
    _ ≤ (‖NumStability.realMatrixContinuousLinearMap B‖ *
          ‖NumStability.realMatrixContinuousLinearMap R‖) *
          ‖NumStability.realMatrixContinuousLinearMap B.transpose‖ := by
      gcongr
      exact NumStability.HDP.Matrix.realMatrixOperatorNorm_mul_le B R

end NumStability.HDP.Vector.Covariance
