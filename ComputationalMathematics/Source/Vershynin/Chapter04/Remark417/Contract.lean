import ComputationalMathematics.Analysis.SingularValues.ApproximateProjections

/-!
# Vershynin Chapter 4, Remark 4.1.7

Source contract for the transpose duality between rectangular projections and
isometric embeddings, including the approximate formulation.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Remark 4.1.7: with `Q = Aᵀ`, `Q Qᵀ = I` is equivalent to
`Qᵀ Q` being the rank-`n` orthogonal projection, and an isometric embedding
is equivalently a projection after transposition.  For the source's
qualitative approximate analogue, the final conjunct uses an independent
row-Gram defect for approximate projections and records explicit quantitative
implications in both directions. -/
theorem hdp_04_remark_4_1_7 {n m : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    (NumStability.IsRealMatrixProjection A.transpose ↔
      NumStability.IsRealOrthogonalProjectionMatrix
          (A.transpose.transpose * A.transpose) ∧
        (A.transpose.transpose * A.transpose).rank = n + 1) ∧
    (NumStability.IsRealMatrixIsometry A ↔
      NumStability.IsRealMatrixProjection A.transpose) ∧
    ∀ δ : ℝ, 0 ≤ δ →
      (NumStability.ApproximateIsometryBounds A δ →
        NumStability.ApproximateProjectionDefect A.transpose
          (3 * max δ (δ ^ 2))) ∧
      (NumStability.ApproximateProjectionDefect A.transpose
          (max δ (δ ^ 2)) →
        NumStability.ApproximateIsometryBounds A δ) := by
  exact ⟨NumStability.matrixProjection_iff_gram_orthogonalProjection_rank A.transpose,
    NumStability.isRealMatrixIsometry_iff_transpose_isRealMatrixProjection A,
    fun δ hδ => ⟨
      NumStability.approximateProjectionDefect_transpose_of_approximateIsometryBounds
        A hδ,
      fun hdef => NumStability.approximateIsometryBounds_of_gramDeviation A hδ
        (by simpa [NumStability.ApproximateProjectionDefect] using hdef)⟩⟩

end NumStability.HDP.Contract
