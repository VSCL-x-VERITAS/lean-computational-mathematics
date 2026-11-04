import ComputationalMathematics.Analysis.SingularValues.RealSVD
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.Core
import Mathlib.Data.Fin.Tuple.Sort

/-!
# Existence of real rectangular singular-value decompositions

This module closes the rank-deficient real SVD construction supplied by the
exact right-Gram machinery in `ColumnSketches.Core`.  It identifies matrix rank
with the number of positive ordered right-Gram singular values, restricts the
Gram eigenbasis to those directions, and packages the resulting rank-one
expansion as an `IsRealMatrixSVD` certificate.
-/

namespace NumStability

open scoped BigOperators

/-- The exact right Gram is the ordinary matrix product `Aᵀ * A`. -/
theorem rectRightGram_eq_transpose_mul_self {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    (rectRightGram A : Matrix (Fin n) (Fin n) ℝ) = A.transpose * A := by
  ext j k
  simp [rectRightGram, Matrix.mul_apply]

/-- The exact right Gram has the same rank as the original real matrix. -/
theorem rectRightGram_rank_eq {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    Matrix.rank (rectRightGram A : Matrix (Fin n) (Fin n) ℝ) = A.rank := by
  rw [rectRightGram_eq_transpose_mul_self]
  exact Matrix.rank_transpose_mul_self A

/-- A basis-indexed singular value is nonzero exactly when its right-Gram
eigenvalue is nonzero. -/
theorem rectRightGramBasisSingularValue_ne_zero_iff_eigenvalue_ne_zero
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) :
    rectRightGramBasisSingularValue A i ≠ 0 ↔
      rectRightGramEigenvalue A i ≠ 0 := by
  constructor
  · intro hs he
    have hsq := rectRightGramBasisSingularValue_sq_eq A i
    rw [he] at hsq
    exact hs (sq_eq_zero_iff.mp hsq)
  · intro he hs
    apply he
    rw [← rectRightGramBasisSingularValue_sq_eq A i, hs]
    norm_num

/-- The number of nonzero ordered right-Gram singular values is the matrix
rank. -/
theorem rectSingularValue_nonzero_card_eq_rank {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    Fintype.card {i : Fin n // rectSingularValue A i ≠ 0} = A.rank := by
  let e := rectRightGramBasisOrderedEquiv n
  have he : ∀ i : Fin n,
      rectRightGramBasisSingularValue A i ≠ 0 ↔
        rectSingularValue A (e i) ≠ 0 := by
    intro i
    change rectRightGramBasisSingularValue A i ≠ 0 ↔
      rectSingularValue A (rectRightGramBasisOrderedIndex n i) ≠ 0
    rw [rectRightGramBasisSingularValue_eq_orderedIndex]
  have hcard_ordered :
      Fintype.card {i : Fin n // rectRightGramBasisSingularValue A i ≠ 0} =
        Fintype.card {i : Fin n // rectSingularValue A i ≠ 0} := by
    exact Fintype.card_congr (e.subtypeEquiv he)
  have hcard_basis_eigen :
      Fintype.card {i : Fin n // rectRightGramBasisSingularValue A i ≠ 0} =
        Fintype.card {i : Fin n // rectRightGramEigenvalue A i ≠ 0} := by
    exact Fintype.card_congr
      (Equiv.subtypeEquivRight
        (rectRightGramBasisSingularValue_ne_zero_iff_eigenvalue_ne_zero A))
  have hrank := (rectRightGram_matrix_posSemidef A).1.rank_eq_card_non_zero_eigs
  rw [← rectRightGram_rank_eq A]
  rw [hrank]
  exact hcard_ordered.symm.trans hcard_basis_eigen

/-- An ordered real right-Gram singular value is positive exactly before the
matrix-rank cutoff. -/
theorem rectSingularValue_pos_iff_lt_rank {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) :
    0 < rectSingularValue A i ↔ i.val < A.rank := by
  have hcount :
      (Finset.univ.filter fun j : Fin n => 0 < rectSingularValue A j).card =
        A.rank := by
    calc
      (Finset.univ.filter fun j : Fin n => 0 < rectSingularValue A j).card =
          Fintype.card {j : Fin n // 0 < rectSingularValue A j} :=
        (Fintype.card_subtype _).symm
      _ = Fintype.card {j : Fin n // rectSingularValue A j ≠ 0} := by
        apply Fintype.card_congr
        exact Equiv.subtypeEquivRight fun j => by
          constructor
          · exact ne_of_gt
          · intro hne
            exact lt_of_le_of_ne (rectSingularValue_nonneg A j) (Ne.symm hne)
      _ = A.rank := rectSingularValue_nonzero_card_eq_rank A
  have hiff :=
    Tuple.lt_card_gt_iff_apply_gt_of_antitone
      (f := rectSingularValue A) (j := i) (a := 0)
      (rectSingularValue_antitone A)
  rw [hcount] at hiff
  exact hiff.symm

/-- Ordered singular values vanish at and beyond the rank cutoff. -/
theorem rectSingularValue_eq_zero_of_rank_le {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) (hi : A.rank ≤ i.val) :
    rectSingularValue A i = 0 := by
  apply le_antisymm
  · apply le_of_not_gt
    intro hpos
    exact (Nat.not_lt_of_ge hi)
      ((rectSingularValue_pos_iff_lt_rank A i).mp hpos)
  · exact rectSingularValue_nonneg A i

/-- Every ordered right-Gram direction selected before the rank cutoff has a
strictly positive singular value. -/
theorem rectRightGramOrderedTop_rank_basisSingularValue_pos {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (a : Fin A.rank) :
    0 < rectRightGramBasisSingularValue A
      (rectRightGramOrderedTopEmbedding (Matrix.rank_le_width A) a) := by
  rw [(rectRightGramOrderedTopEmbedding_certificate
    A (Matrix.rank_le_width A)).singularValue_eq a]
  apply (rectSingularValue_pos_iff_lt_rank A _).2
  exact a.isLt

/-- Every right-Gram basis direction outside the ordered rank block has zero
singular value. -/
theorem rectRightGramOrderedTop_rank_complement_basisSingularValue_zero
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) {b : Fin n}
    (hb : b ∉ rectRightGramSelectedIndexSet
      (rectRightGramOrderedTopEmbedding (Matrix.rank_le_width A))) :
    rectRightGramBasisSingularValue A b = 0 := by
  rw [rectRightGramBasisSingularValue_eq_orderedIndex]
  apply rectSingularValue_eq_zero_of_rank_le
  exact rectRightGramOrderedTopEmbedding_not_mem_index_ge
    (Matrix.rank_le_width A) hb

/-- A nonzero right-Gram singular branch satisfies the transpose-side
singular-pair equation `Aᵀ u = σ v`. -/
theorem rectRightGramLeftSingularZeroSafe_transpose_action_of_ne
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (a : Fin n)
    (hσ : rectRightGramBasisSingularValue A a ≠ 0) (j : Fin n) :
    (∑ i : Fin m,
      A i j * rectRightGramLeftSingularZeroSafe A i a) =
        rectRightGramBasisSingularValue A a *
          rectRightGramEigenbasis A j a := by
  let σ := rectRightGramBasisSingularValue A a
  have heig := rectRightGramEigenbasis_eigenvector A a j
  have hsq := rectRightGramBasisSingularValue_sq_eq A a
  calc
    ∑ i : Fin m, A i j * rectRightGramLeftSingularZeroSafe A i a =
        (1 / σ) * ∑ i : Fin m,
          A i j * rectRightGramProjectedColumn A i a := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      rw [rectRightGramLeftSingularZeroSafe_eq_inv_mul_of_singularValue_ne_zero
        A a hσ i]
      ring
    _ = (1 / σ) * ∑ k : Fin n,
        rectRightGram A j k * rectRightGramEigenbasis A k a := by
      congr 1
      unfold rectRightGramProjectedColumn rectRightGram
      calc
        ∑ i : Fin m,
            A i j * (∑ k : Fin n,
              A i k * rectRightGramEigenbasis A k a) =
            ∑ i : Fin m, ∑ k : Fin n,
              A i j * (A i k * rectRightGramEigenbasis A k a) := by
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.mul_sum]
        _ = ∑ k : Fin n, ∑ i : Fin m,
              A i j * (A i k * rectRightGramEigenbasis A k a) := by
          rw [Finset.sum_comm]
        _ = ∑ k : Fin n, (∑ i : Fin m, A i j * A i k) *
              rectRightGramEigenbasis A k a := by
          apply Finset.sum_congr rfl
          intro k _
          rw [Finset.sum_mul]
          apply Finset.sum_congr rfl
          intro i _
          ring
    _ = (1 / σ) *
        (rectRightGramEigenvalue A a * rectRightGramEigenbasis A j a) := by
      rw [heig]
    _ = σ * rectRightGramEigenbasis A j a := by
      have hσsq : σ ^ 2 = rectRightGramEigenvalue A a := by
        simpa [σ] using hsq
      rw [← hσsq]
      field_simp [hσ]

/-- A nonzero right-Gram singular branch gives a left singular vector that is
an eigenvector of `A Aᵀ` with eigenvalue `σ²`. -/
theorem rectRightGramLeftSingularZeroSafe_leftGram_eigenvector_of_ne
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (a : Fin n)
    (hσ : rectRightGramBasisSingularValue A a ≠ 0) (i : Fin m) :
    (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) *
      rectRightGramLeftSingularZeroSafe A l a) =
        (rectRightGramBasisSingularValue A a) ^ 2 *
          rectRightGramLeftSingularZeroSafe A i a := by
  let σ := rectRightGramBasisSingularValue A a
  calc
    ∑ l : Fin m, (∑ j : Fin n, A i j * A l j) *
        rectRightGramLeftSingularZeroSafe A l a =
        ∑ l : Fin m, ∑ j : Fin n,
          (A i j * A l j) * rectRightGramLeftSingularZeroSafe A l a := by
      apply Finset.sum_congr rfl
      intro l _
      rw [Finset.sum_mul]
    _ = ∑ j : Fin n, ∑ l : Fin m,
          (A i j * A l j) * rectRightGramLeftSingularZeroSafe A l a := by
      rw [Finset.sum_comm]
    _ = ∑ j : Fin n, A i j *
          (∑ l : Fin m, A l j *
            rectRightGramLeftSingularZeroSafe A l a) := by
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro l _
      ring
    _ = ∑ j : Fin n, A i j *
          (σ * rectRightGramEigenbasis A j a) := by
      apply Finset.sum_congr rfl
      intro j _
      rw [rectRightGramLeftSingularZeroSafe_transpose_action_of_ne A a hσ j]
    _ = σ * rectRightGramProjectedColumn A i a := by
      unfold rectRightGramProjectedColumn
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = σ * (σ * rectRightGramLeftSingularZeroSafe A i a) := by
      rw [rectRightGramLeftSingularZeroSafe_factor_column A i a]
    _ = σ ^ 2 * rectRightGramLeftSingularZeroSafe A i a := by
      ring

/-- Every finite real rectangular matrix admits a rank-length SVD with ordered,
nonnegative, zero-extended singular values, orthonormal singular families, and
the left/right Gram eigenvector equations. -/
theorem exists_isRealMatrixSVDWithGramEigenrelations {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ (r : ℕ) (s : Fin n → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin n)),
      IsRealMatrixSVDWithGramEigenrelations A r s u v := by
  let r := A.rank
  let hrn : r ≤ n := Matrix.rank_le_width A
  let e : Fin r ↪ Fin n := rectRightGramOrderedTopEmbedding hrn
  let s : Fin n → ℝ := rectSingularValue A
  let u : Fin r → EuclideanSpace ℝ (Fin m) := fun a =>
    WithLp.toLp 2 (fun i : Fin m => rectRightGramLeftSingularZeroSafe A i (e a))
  let v : Fin r → EuclideanSpace ℝ (Fin n) := fun a =>
    WithLp.toLp 2 (fun j : Fin n => rectRightGramEigenbasis A j (e a))
  refine ⟨r, s, u, v, ?_⟩
  refine
    { rank_eq := rfl
      rank_le_width := hrn
      singularValues_nonnegative := ?_
      singularValues_antitone := ?_
      singularValues_zero_of_rank_le := ?_
      leftSingularVectors_orthonormal := ?_
      rightSingularVectors_orthonormal := ?_
      reconstruction := ?_
      leftGram_eigenvector := ?_
      rightGram_eigenvector := ?_ }
  · intro i
    exact rectSingularValue_nonneg A i
  · exact rectSingularValue_antitone A
  · intro i hi
    exact rectSingularValue_eq_zero_of_rank_le A i hi
  · rw [orthonormal_iff_ite]
    intro a b
    unfold u
    rw [PiLp.inner_apply]
    have h := rectRightGramLeftSingularZeroSafe_col_orthonormal_of_pos A
      (by simpa [r, e] using
        rectRightGramOrderedTop_rank_basisSingularValue_pos A a)
      (by simpa [r, e] using
        rectRightGramOrderedTop_rank_basisSingularValue_pos A b)
    simpa [real_inner_eq_re_inner, RCLike.inner_apply, idMatrix, mul_comm] using h
  · rw [orthonormal_iff_ite]
    intro a b
    unfold v
    rw [PiLp.inner_apply]
    have h := rectRightGramOrderedHeadRight_col_orthonormal A hrn a b
    simpa [r, e, rectRightGramOrderedHeadRight,
      real_inner_eq_re_inner, RCLike.inner_apply, idMatrix, mul_comm] using h
  · intro i j
    let selected : Finset (Fin n) := rectRightGramSelectedIndexSet e
    let term : Fin n → ℝ := fun b =>
      rectRightGramLeftSingularZeroSafe A i b *
        rectRightGramBasisSingularValue A b *
        rectRightGramEigenbasis A j b
    have hsum_selected :
        selected.sum term = ∑ a : Fin r, term (e a) := by
      exact rectRightGramSelectedIndexSet_sum e term
    have hsum_full :
        (∑ b : Fin n, term b) = selected.sum term := by
      symm
      apply Finset.sum_subset (Finset.subset_univ selected)
      intro b _ hb
      have hz : rectRightGramBasisSingularValue A b = 0 := by
        apply rectRightGramOrderedTop_rank_complement_basisSingularValue_zero A
        simpa [selected, e] using hb
      simp [hz]
    calc
      A i j = ∑ b : Fin n, term b := by
        simpa [term] using rectRightGram_basisSVD_representation A i j
      _ = selected.sum term := hsum_full
      _ = ∑ a : Fin r, term (e a) := hsum_selected
      _ = ∑ a : Fin r,
          s (Fin.castLE hrn a) * u a i * v a j := by
        apply Finset.sum_congr rfl
        intro a _
        have hsv :=
          (rectRightGramOrderedTopEmbedding_certificate A hrn).singularValue_eq a
        simp only [term, u, v]
        rw [hsv]
        have hidx : Fin.castLE hrn a = rectTopIndex hrn a := by
          apply Fin.ext
          rfl
        rw [hidx]
        change
          rectRightGramLeftSingularZeroSafe A i (e a) *
              rectSingularValue A (rectTopIndex hrn a) *
              rectRightGramEigenbasis A j (e a) =
            rectSingularValue A (rectTopIndex hrn a) *
              rectRightGramLeftSingularZeroSafe A i (e a) *
              rectRightGramEigenbasis A j (e a)
        ring
  · intro a i
    have hpos := rectRightGramOrderedTop_rank_basisSingularValue_pos A a
    have hrel :=
      rectRightGramLeftSingularZeroSafe_leftGram_eigenvector_of_ne
        A (e a) (ne_of_gt hpos) i
    have hsv :=
      (rectRightGramOrderedTopEmbedding_certificate A hrn).singularValue_eq a
    have hidx : Fin.castLE hrn a = rectTopIndex hrn a := by
      apply Fin.ext
      rfl
    change
      (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) *
        rectRightGramLeftSingularZeroSafe A l (e a)) =
          (rectSingularValue A (Fin.castLE hrn a)) ^ 2 *
            rectRightGramLeftSingularZeroSafe A i (e a)
    rw [hidx, ← hsv]
    exact hrel
  · intro a j
    have heig := rectRightGramEigenbasis_eigenvector A (e a) j
    have hsq := rectRightGramBasisSingularValue_sq_eq A (e a)
    have hsv :=
      (rectRightGramOrderedTopEmbedding_certificate A hrn).singularValue_eq a
    have hidx : Fin.castLE hrn a = rectTopIndex hrn a := by
      apply Fin.ext
      rfl
    change
      (∑ l : Fin n, (∑ i : Fin m, A i j * A i l) *
        rectRightGramEigenbasis A l (e a)) =
          (rectSingularValue A (Fin.castLE hrn a)) ^ 2 *
            rectRightGramEigenbasis A j (e a)
    rw [hidx, ← hsv, hsq]
    simpa [rectRightGram] using heig

/-- Every finite real rectangular matrix admits a rank-length SVD with ordered,
nonnegative, zero-extended singular values and orthonormal singular families. -/
theorem exists_isRealMatrixSVD {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ (r : ℕ) (s : Fin n → ℝ)
      (u : Fin r → EuclideanSpace ℝ (Fin m))
      (v : Fin r → EuclideanSpace ℝ (Fin n)),
      IsRealMatrixSVD A r s u v := by
  obtain ⟨r, s, u, v, h⟩ :=
    exists_isRealMatrixSVDWithGramEigenrelations A
  exact ⟨r, s, u, v, h.toIsRealMatrixSVD⟩

end NumStability
