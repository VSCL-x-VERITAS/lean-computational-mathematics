import ComputationalMathematics.Analysis.MatrixNorms.Comparisons
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix
import ComputationalMathematics.Analysis.SingularValues.Realification

/-!
# Real operator norms and complexification

This module identifies the subordinate Euclidean operator norm of a finite
real rectangular matrix with the spectral norm of its complexification.
-/

namespace NumStability

open scoped RealInnerProductSpace

noncomputable section

/-- The real Euclidean operator norm is unchanged by complexifying a finite
rectangular matrix. -/
theorem realMatrixOperatorNorm_eq_complexMatrixOp2_realRectToCMatrix
    {m n : Nat} (A : Fin m → Fin n → Real) :
    realMatrixOperatorNorm A =
      complexMatrixOp2 (realRectToCMatrix A) := by
  have hnorm {d : Nat} (x : Fin d → Real) :
      ‖WithLp.toLp 2 x‖ = vecNorm2 x := by
    rw [EuclideanSpace.norm_eq]
    simp only [Real.norm_eq_abs, sq_abs]
    rw [show ∑ i, x i ^ 2 = vecNorm2 x ^ 2 by
      exact (vecNorm2_sq x).symm]
    exact Real.sqrt_sq (vecNorm2_nonneg x)
  apply le_antisymm
  · have hbound :
        rectOpNorm2Le A (complexMatrixOp2 (realRectToCMatrix A)) :=
      rectOpNorm2Le_of_complexMatrixOp2_realRectToCMatrix_le A le_rfl
    rw [realMatrixOperatorNorm]
    apply ContinuousLinearMap.opNorm_le_bound
      (realMatrixContinuousLinearMap A)
      (complexMatrixOp2_nonneg (realRectToCMatrix A))
    intro x
    have hxnorm : ‖x‖ = vecNorm2 (WithLp.ofLp x) := by
      rw [← hnorm (WithLp.ofLp x)]
    have haction : ‖realMatrixContinuousLinearMap A x‖ =
        vecNorm2 (rectMatMulVec A (WithLp.ofLp x)) := by
      rw [← hnorm]
      congr 1
    rw [haction, hxnorm]
    exact hbound (WithLp.ofLp x)
  · apply complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le A
      (norm_nonneg (realMatrixContinuousLinearMap A))
    intro x
    have h := ContinuousLinearMap.le_opNorm
      (realMatrixContinuousLinearMap A) (WithLp.toLp 2 x)
    have haction : ‖realMatrixContinuousLinearMap A (WithLp.toLp 2 x)‖ =
        vecNorm2 (rectMatMulVec A x) := by
      rw [← hnorm]
      congr 1
    rw [haction, hnorm] at h
    simpa [realMatrixOperatorNorm] using h

/-- The Euclidean operator norm of a real rectangular matrix is bounded by
its Frobenius norm, including the zero-dimensional case. -/
theorem realMatrixOperatorNorm_le_frobNormRect {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) :
    realMatrixOperatorNorm A ≤ frobNormRect A := by
  by_cases hn : n = 0
  · subst n
    simp [realMatrixOperatorNorm, realMatrixContinuousLinearMap,
      frobNormRect, frobNormSqRect]
  · have hnpos : 0 < n := Nat.pos_of_ne_zero hn
    rw [realMatrixOperatorNorm_eq_complexMatrixOp2_realRectToCMatrix,
      frobNormRect_eq_complexMatrixFrobenius_realRectToCMatrix]
    exact complexMatrixOp2_le_complexMatrixFrobenius hnpos _

/-- Rank-sensitive upper comparison between the Frobenius and Euclidean
operator norms of a real rectangular matrix. -/
theorem frobNormRect_le_sqrt_rank_mul_realMatrixOperatorNorm {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) :
    frobNormRect A ≤
      Real.sqrt (realRectMatrixRank A : Real) * realMatrixOperatorNorm A := by
  rw [realMatrixOperatorNorm_eq_complexMatrixOp2_realRectToCMatrix,
    frobNormRect_eq_complexMatrixFrobenius_realRectToCMatrix]
  exact complexMatrixFrobenius_le_sqrt_rank_mul_complexMatrixOp2 _

/-- Complexification gives the real identity matrix full rank. -/
theorem realRectMatrixRank_one (r : Nat) :
    realRectMatrixRank (1 : Matrix (Fin r) (Fin r) Real) = r := by
  have hcomplex :
      realRectToCMatrix (1 : Matrix (Fin r) (Fin r) Real) =
        (1 : Matrix (Fin r) (Fin r) Complex) := by
    ext i j
    by_cases hij : i = j
    · simp [realRectToCMatrix, Matrix.one_apply, hij]
    · simp [realRectToCMatrix, hij]
  rw [realRectMatrixRank, hcomplex]
  unfold complexMatrixRank
  simp

/-- The Frobenius norm of the `r`-dimensional real identity is `sqrt r`. -/
theorem frobNormRect_one (r : Nat) :
    frobNormRect (1 : Matrix (Fin r) (Fin r) Real) =
      Real.sqrt (r : Real) := by
  unfold frobNormRect frobNormSqRect
  congr 1
  simp [Matrix.one_apply]

/-- The Euclidean operator norm of a positive-dimensional identity is one. -/
theorem realMatrixOperatorNorm_one (r : Nat) (hr : 0 < r) :
    realMatrixOperatorNorm (1 : Matrix (Fin r) (Fin r) Real) = 1 := by
  letI : Nonempty (Fin r) := ⟨⟨0, hr⟩⟩
  unfold realMatrixOperatorNorm realMatrixContinuousLinearMap
  have hlin : Matrix.toEuclideanLin
      (1 : Matrix (Fin r) (Fin r) Real) = LinearMap.id := by
    ext x i
    simp
  rw [hlin]
  simpa using (ContinuousLinearMap.norm_id (𝕜 := Real)
    (E := EuclideanSpace Real (Fin r)))

/-- The constants in the real operator/Frobenius comparison are optimal.

The first conjunct says that no coefficient larger than one can replace the
coefficient of the operator norm in the lower bound. The second says that,
at each positive rank `r`, no coefficient smaller than `sqrt r` can replace
the upper coefficient uniformly over real matrices of rank `r`. -/
def RealOperatorFrobeniusRelationIsBestPossible : Prop :=
  (∀ c : Real,
      (∀ (m n : Nat) (A : Matrix (Fin m) (Fin n) Real),
        c * realMatrixOperatorNorm A ≤ frobNormRect A) →
      c ≤ 1) ∧
    ∀ r : Nat, 0 < r → ∀ c : Real,
      (∀ (m n : Nat) (A : Matrix (Fin m) (Fin n) Real),
        realRectMatrixRank A = r →
          frobNormRect A ≤ c * realMatrixOperatorNorm A) →
      Real.sqrt (r : Real) ≤ c

/-- The identity matrices witness optimality of both constants in the real
operator/Frobenius relation. -/
theorem realOperatorFrobeniusRelation_isBestPossible :
    RealOperatorFrobeniusRelationIsBestPossible := by
  constructor
  · intro c hbound
    have h := hbound 1 1 (1 : Matrix (Fin 1) (Fin 1) Real)
    rw [realMatrixOperatorNorm_one 1 (by norm_num), frobNormRect_one] at h
    norm_num at h ⊢
    exact h
  · intro r hr c hbound
    have h := hbound r r (1 : Matrix (Fin r) (Fin r) Real)
      (realRectMatrixRank_one r)
    rw [frobNormRect_one, realMatrixOperatorNorm_one r hr, mul_one] at h
    exact h

end

end NumStability
