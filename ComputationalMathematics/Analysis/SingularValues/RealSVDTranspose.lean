import ComputationalMathematics.Analysis.SingularValues.RealSVD

/-!
# Transpose transport for real singular-value decompositions

Transpose an existing rectangular SVD certificate, preserving its rank and
singular families and resizing only its scalar zero tail. This module does not
construct another SVD or impose a matrix-shape assumption.
-/

namespace NumStability

open scoped BigOperators

/-- Resize only the scalar sequence when transposing a rectangular SVD.
Values at indices present in the original column dimension are retained;
the remaining indices of the new column dimension are zero. -/
def realSVDTransposeSingularValues {m n : ℕ} (s : Fin n → ℝ) : Fin m → ℝ :=
  fun i => if hi : i.val < n then s ⟨i.val, hi⟩ else 0

/-- Resizing preserves the scalar at every index in both dimensions. -/
theorem realSVDTransposeSingularValues_eq {m n : ℕ} (s : Fin n → ℝ)
    (i : Fin m) (hi : i.val < n) :
    realSVDTransposeSingularValues s i = s ⟨i.val, hi⟩ := by
  simp [realSVDTransposeSingularValues, hi]

/-- The rank in a real SVD is bounded by the row dimension as well as the
column dimension, including when either dimension is zero. -/
theorem IsRealMatrixSVD.rank_le_height {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) : r ≤ m :=
  h.rank_eq.trans_le (Matrix.rank_le_height A)

/-- Transpose an arbitrary real SVD certificate by swapping its existing
singular families and resizing its scalar zero tail. No shape or positive-rank
assumption is needed. -/
theorem IsRealMatrixSVD.transpose {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) :
    IsRealMatrixSVD A.transpose r (realSVDTransposeSingularValues s) v u := by
  refine
    { rank_eq := h.rank_eq.trans (Matrix.rank_transpose A).symm
      rank_le_width := h.rank_le_height
      singularValues_nonnegative := ?_
      singularValues_antitone := ?_
      singularValues_zero_of_rank_le := ?_
      leftSingularVectors_orthonormal := h.rightSingularVectors_orthonormal
      rightSingularVectors_orthonormal := h.leftSingularVectors_orthonormal
      reconstruction := ?_ }
  · intro i
    unfold realSVDTransposeSingularValues
    split
    · exact h.singularValues_nonnegative _
    · exact le_refl 0
  · intro i j hij
    by_cases hj : j.val < n
    · have hi : i.val < n := lt_of_le_of_lt hij hj
      rw [realSVDTransposeSingularValues_eq s j hj,
        realSVDTransposeSingularValues_eq s i hi]
      exact h.singularValues_antitone hij
    · simp only [realSVDTransposeSingularValues, dif_neg hj]
      split
      · exact h.singularValues_nonnegative _
      · exact le_refl 0
  · intro i hi
    unfold realSVDTransposeSingularValues
    split
    · exact h.singularValues_zero_of_rank_le _ hi
    · rfl
  · intro i j
    change A j i = _
    rw [h.reconstruction j i]
    apply Finset.sum_congr rfl
    intro k _
    rw [realSVDTransposeSingularValues_eq s (Fin.castLE h.rank_le_height k)
      (k.isLt.trans_le h.rank_le_width)]
    change s (Fin.castLE h.rank_le_width k) * u k j * v k i =
      s (Fin.castLE h.rank_le_width k) * v k i * u k j
    ring

/-- Transposition also swaps the two Gram eigenvector equations of an
existing enriched SVD certificate. -/
theorem IsRealMatrixSVDWithGramEigenrelations.transpose {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVDWithGramEigenrelations A r s u v) :
    IsRealMatrixSVDWithGramEigenrelations A.transpose r
      (realSVDTransposeSingularValues s) v u := by
  refine
    { h.toIsRealMatrixSVD.transpose with
      leftGram_eigenvector := ?_
      rightGram_eigenvector := ?_ }
  · intro a i
    rw [realSVDTransposeSingularValues_eq s
      (Fin.castLE h.toIsRealMatrixSVD.rank_le_height a)
      (a.isLt.trans_le h.rank_le_width)]
    exact h.rightGram_eigenvector a i
  · intro a j
    rw [realSVDTransposeSingularValues_eq s
      (Fin.castLE h.toIsRealMatrixSVD.rank_le_height a)
      (a.isLt.trans_le h.rank_le_width)]
    exact h.leftGram_eigenvector a j

end NumStability
