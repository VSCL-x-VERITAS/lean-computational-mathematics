import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD
import ComputationalMathematics.Analysis.SingularValues.CourantFischer
import ComputationalMathematics.Analysis.SingularValues.EckartYoung

/-!
# Endpoints of an ordered real singular-value decomposition

This module identifies the first coefficient of a nonempty ordered real SVD
with the Euclidean operator norm.  The result is stated for an arbitrary SVD
certificate, so source-facing users do not need to choose between the
repository's equivalent right-Gram implementations.
-/

namespace NumStability

/-- The leading coefficient of a nonempty ordered real SVD is the Euclidean
operator norm of the represented matrix. -/
theorem IsRealMatrixSVD.leadingSingularValue_eq_operatorNorm
    {m n r : ℕ}
    {A : Matrix (Fin m) (Fin (n + 1)) ℝ}
    {s : Fin (n + 1) → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin (n + 1))}
    (h : IsRealMatrixSVD A r s u v) :
    s (0 : Fin (n + 1)) = realMatrixOperatorNorm A := by
  rw [h.singularValue_eq_canonical,
    realMatrixOperatorNorm_eq_complexMatrixOp2_realRectToCMatrix]
  exact (complexMatrixOp2_eq_top_singularValue (Nat.succ_pos n)
    (realRectToCMatrix A)).symm

/-- The last singular value supplied by the shared complex Gram-spectrum API
is the last value of the explicit decreasing real Courant--Fischer spectrum.
This exposes the spectral-indexing bridge needed by source contracts that use
the smallest singular value together with the Moore--Penrose pseudoinverse. -/
theorem realRectToCMatrix_last_singularValue_eq_rectCourantFischer
    {m k : ℕ} (A : Matrix (Fin m) (Fin (k + 1)) ℝ) :
    complexMatrixSingularValue (realRectToCMatrix A) (Fin.last k) =
      rectCourantFischerSingularValue A (Fin.last k) := by
  let σc := complexMatrixSingularValue (realRectToCMatrix A) (Fin.last k)
  let σr := rectCourantFischerSingularValue A (Fin.last k)
  have hnorm {d : ℕ} (x : Fin d → ℝ) :
      ‖WithLp.toLp 2 x‖ = vecNorm2 x := by
    rw [EuclideanSpace.norm_eq]
    simp only [Real.norm_eq_abs, sq_abs]
    rw [show ∑ i, x i ^ 2 = vecNorm2 x ^ 2 by
      exact (vecNorm2_sq x).symm]
    exact Real.sqrt_sq (vecNorm2_nonneg x)
  have haction (x : Fin (k + 1) → ℝ) :
      ‖Matrix.toEuclideanLin A (WithLp.toLp 2 x)‖ =
        vecNorm2 (rectMatMulVec A x) := by
    rw [Matrix.toEuclideanLin_apply, hnorm]
    rfl
  have hcLower : ∀ x : EuclideanSpace ℝ (Fin (k + 1)),
      σc * ‖x‖ ≤ ‖Matrix.toEuclideanLin A x‖ := by
    intro x
    have h := complexMatrixSingularValue_last_mul_norm_le_norm_euclideanLin
      (realRectToCMatrix A) (realVecToEuclidean (WithLp.ofLp x))
    rw [realVecToEuclidean_norm,
      realRectToCMatrix_euclideanLin_realVecToEuclidean_norm] at h
    have hxnorm : ‖x‖ = vecNorm2 (WithLp.ofLp x) := by
      rw [← hnorm (WithLp.ofLp x), WithLp.toLp_ofLp]
    have hxaction : ‖Matrix.toEuclideanLin A x‖ =
        vecNorm2 (rectMatMulVec A (WithLp.ofLp x)) := by
      rw [← WithLp.toLp_ofLp 2 x, haction]
    simpa [σc, hxnorm, hxaction] using h
  have hc_le_hr : σc ≤ σr := by
    exact
      (rectCourantFischer_extremeSingularValues_areOptimalBounds A).2.2
        σc hcLower
  obtain ⟨x, hx, hsq⟩ :=
    realRectToCMatrix_last_singularValue_exists_real_attaining_vector_sq A
  have hxnorm : 0 < vecNorm2 x := by
    rcases lt_or_eq_of_le (vecNorm2_nonneg x) with hpos | hzero
    · exact hpos
    · exfalso
      apply hx
      funext i
      exact (vecNorm2_eq_zero_iff x).mp hzero.symm i
  have hnormSq :
      vecNorm2 (rectMatMulVec A x) ^ 2 =
        (σc * vecNorm2 x) ^ 2 := by
    rw [mul_pow, vecNorm2_sq, vecNorm2_sq]
    simpa [σc] using hsq
  have hnormEq :
      vecNorm2 (rectMatMulVec A x) = σc * vecNorm2 x := by
    exact (sq_eq_sq₀ (vecNorm2_nonneg _)
      (mul_nonneg
        (complexMatrixSingularValue_nonneg
          (realRectToCMatrix A) (Fin.last k))
        (vecNorm2_nonneg x))).mp hnormSq
  have hrLower : σr * vecNorm2 x ≤ vecNorm2 (rectMatMulVec A x) := by
    have h :=
      (rectCourantFischer_extremeSingularValues_areOptimalBounds A).1
        (WithLp.toLp 2 x)
    rw [Matrix.toEuclideanLin_apply, hnorm, hnorm] at h
    simpa [σr, rectMatMulVec, Matrix.mulVec, dotProduct] using h.1
  have hr_le_hc : σr ≤ σc := by
    rw [hnormEq] at hrLower
    nlinarith
  exact le_antisymm hc_le_hr hr_le_hc

end NumStability
