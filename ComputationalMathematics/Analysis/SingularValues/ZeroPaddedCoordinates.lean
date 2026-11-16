import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD
import ComputationalMathematics.Analysis.SingularValues.EckartYoung

/-!
# Zero-padded real singular coordinates

The full right singular basis is retained, while a left column corresponding
to a zero singular value is zero. Thus rectangular and rank-deficient matrices
have square right coordinates and contractive, rather than necessarily
orthonormal, left coordinates.
-/

namespace NumStability
open scoped BigOperators

/-- Orthogonal columns of squared length at most one define a contraction. -/
theorem rectOpNorm2Le_one_of_orthogonal_columns {m n : ℕ}
    (Q : Matrix (Fin m) (Fin n) ℝ)
    (hcross : ∀ a b, a ≠ b → (∑ i, Q i a * Q i b) = 0)
    (hdiag : ∀ a, (∑ i, Q i a * Q i a) ≤ 1) :
    rectOpNorm2Le Q 1 := by
  classical
  have hsq (x : Fin n → ℝ) :
      vecNorm2Sq (rectMatMulVec Q x) ≤ vecNorm2Sq x := by
    have hexpand : vecNorm2Sq (rectMatMulVec Q x) =
        ∑ a, ∑ b, (∑ i, Q i a * Q i b) * (x a * x b) := by
      unfold vecNorm2Sq rectMatMulVec
      simp_rw [pow_two, Finset.sum_mul, Finset.mul_sum]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro a _
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro b _
      apply Finset.sum_congr rfl
      intro i _
      ring
    rw [hexpand]
    unfold vecNorm2Sq
    apply Finset.sum_le_sum
    intro a _
    calc
      (∑ b, (∑ i, Q i a * Q i b) * (x a * x b)) =
          (∑ i, Q i a * Q i a) * (x a * x a) := by
        apply Finset.sum_eq_single a
        · intro b _ hba
          rw [hcross a b (Ne.symm hba), zero_mul]
        · simp
      _ ≤ x a ^ 2 := by
        simpa [pow_two] using mul_le_mul_of_nonneg_right (hdiag a) (mul_self_nonneg (x a))
  intro x
  simpa [vecNorm2] using Real.sqrt_le_sqrt (hsq x)

/-- The basis index associated to a zero-based ordered singular coordinate. -/
noncomputable def realSVDOrderedIndex (n : ℕ) : Fin n ≃ Fin n :=
  (rectRightGramBasisOrderedEquiv n).symm

/-- Full ordered right singular coordinates. -/
noncomputable def realSVDRightCoordinates {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) : Matrix (Fin n) (Fin n) ℝ :=
  fun i a => rectRightGramEigenbasis A i (realSVDOrderedIndex n a)

/-- Ordered left coordinates, with a zero column on zero singular branches. -/
noncomputable def realSVDLeftCoordinates {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) : Matrix (Fin m) (Fin n) ℝ :=
  fun i a => rectRightGramLeftSingularZeroSafe A i (realSVDOrderedIndex n a)

@[simp] theorem realSVDOrderedIndex_singularValue {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (a : Fin n) :
    rectRightGramBasisSingularValue A (realSVDOrderedIndex n a) =
      rectSingularValue A a := by
  rw [rectRightGramBasisSingularValue_eq_orderedIndex]
  change rectSingularValue A ((rectRightGramBasisOrderedEquiv n)
    ((rectRightGramBasisOrderedEquiv n).symm a)) = _
  rw [Equiv.apply_symm_apply]

/-- Right singular coordinates have orthonormal columns. -/
theorem realSVDRightCoordinates_orthonormal {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (a b : Fin n) :
    (∑ i, realSVDRightCoordinates A i a * realSVDRightCoordinates A i b) =
      if a = b then 1 else 0 := by
  classical
  simpa [realSVDRightCoordinates, idMatrix,
    (realSVDOrderedIndex n).injective.eq_iff] using
    rectRightGramEigenbasis_col_orthonormal A
      (realSVDOrderedIndex n a) (realSVDOrderedIndex n b)

/-- Distinct padded left coordinates are orthogonal. -/
theorem realSVDLeftCoordinates_cross {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (a b : Fin n) (hab : a ≠ b) :
    (∑ i, realSVDLeftCoordinates A i a * realSVDLeftCoordinates A i b) = 0 := by
  by_cases hz : rectRightGramBasisSingularValue A (realSVDOrderedIndex n a) = 0
  · simp [realSVDLeftCoordinates,
      rectRightGramLeftSingularZeroSafe_eq_zero_of_singularValue_eq_zero A _ hz]
  · exact rectRightGramLeftSingularZeroSafe_cross_zero_of_pos_ne A
      (lt_of_le_of_ne (rectRightGramBasisSingularValue_nonneg A _) (Ne.symm hz))
      ((realSVDOrderedIndex n).injective.ne hab)

/-- A padded left column has squared length one on a nonzero singular branch
and zero on a zero singular branch. -/
theorem realSVDLeftCoordinates_diag {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (a : Fin n) :
    (∑ i, realSVDLeftCoordinates A i a * realSVDLeftCoordinates A i a) =
      if rectSingularValue A a = 0 then 0 else 1 := by
  classical
  by_cases hz : rectSingularValue A a = 0
  · have hz' : rectRightGramBasisSingularValue A (realSVDOrderedIndex n a) = 0 := by simpa using hz
    simp [realSVDLeftCoordinates, hz,
      rectRightGramLeftSingularZeroSafe_eq_zero_of_singularValue_eq_zero A _ hz']
  · have hp : 0 < rectRightGramBasisSingularValue A (realSVDOrderedIndex n a) := by
      rw [realSVDOrderedIndex_singularValue]
      exact lt_of_le_of_ne (rectSingularValue_nonneg A a) (Ne.symm hz)
    simpa [realSVDLeftCoordinates, idMatrix, hz] using
      rectRightGramLeftSingularZeroSafe_col_orthonormal_of_pos A hp hp

/-- Any subfamily of the zero-padded left singular coordinates is contractive. -/
theorem realSVDLeftCoordinates_subfamily_contraction {m n p : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (e : Fin p ↪ Fin n) :
    rectOpNorm2Le (fun i a => realSVDLeftCoordinates A i (e a)) 1 := by
  apply rectOpNorm2Le_one_of_orthogonal_columns
  · intro a b hab
    let ia := realSVDOrderedIndex n (e a)
    let ib := realSVDOrderedIndex n (e b)
    have hne : ia ≠ ib := fun h => hab (e.injective ((realSVDOrderedIndex n).injective h))
    by_cases hz : rectRightGramBasisSingularValue A ia = 0
    · simp [realSVDLeftCoordinates, ia,
        rectRightGramLeftSingularZeroSafe_eq_zero_of_singularValue_eq_zero A ia hz]
    · exact rectRightGramLeftSingularZeroSafe_cross_zero_of_pos_ne A
        (lt_of_le_of_ne (rectRightGramBasisSingularValue_nonneg A ia) (Ne.symm hz)) hne
  · intro a
    let ia := realSVDOrderedIndex n (e a)
    by_cases hz : rectRightGramBasisSingularValue A ia = 0
    · simp [realSVDLeftCoordinates, ia,
        rectRightGramLeftSingularZeroSafe_eq_zero_of_singularValue_eq_zero A ia hz]
    · have hp := lt_of_le_of_ne (rectRightGramBasisSingularValue_nonneg A ia) (Ne.symm hz)
      have hh := rectRightGramLeftSingularZeroSafe_col_orthonormal_of_pos A hp hp
      simpa [realSVDLeftCoordinates, ia, idMatrix] using hh.le

/-- Any subfamily of the right singular coordinates is contractive. -/
theorem realSVDRightCoordinates_subfamily_contraction {m n p : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (e : Fin p ↪ Fin n) :
    rectOpNorm2Le (fun i a => realSVDRightCoordinates A i (e a)) 1 := by
  apply rectOpNorm2Le_one_of_orthogonal_columns
  · intro a b hab
    simpa [e.injective.ne hab] using realSVDRightCoordinates_orthonormal A (e a) (e b)
  · intro a
    simp [realSVDRightCoordinates_orthonormal]

/-- Reconstruction in ordered zero-padded singular coordinates. -/
theorem realSVDCoordinates_reconstruction {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin m) (j : Fin n) :
    A i j = ∑ a : Fin n,
      realSVDLeftCoordinates A i a * rectSingularValue A a *
        realSVDRightCoordinates A j a := by
  rw [rectRightGram_basisSVD_representation A i j]
  symm
  calc
    (∑ a : Fin n, realSVDLeftCoordinates A i a * rectSingularValue A a *
        realSVDRightCoordinates A j a) =
      ∑ a : Fin n, rectRightGramLeftSingularZeroSafe A i (realSVDOrderedIndex n a) *
        rectRightGramBasisSingularValue A (realSVDOrderedIndex n a) *
        rectRightGramEigenbasis A j (realSVDOrderedIndex n a) := by simp [realSVDLeftCoordinates, realSVDRightCoordinates]
    _ = _ := Equiv.sum_comp (realSVDOrderedIndex n)
      (fun a => rectRightGramLeftSingularZeroSafe A i a *
        rectRightGramBasisSingularValue A a * rectRightGramEigenbasis A j a)

/-- A split of all right coordinates gives the exact SVD head/tail expansion,
including zero singular branches. -/
theorem realSVDCoordinates_head_tail {m k q : ℕ}
    (A : Matrix (Fin m) (Fin (k + q)) ℝ) (i : Fin m) (j : Fin (k + q)) :
    A i j =
      (∑ a : Fin k, realSVDLeftCoordinates A i (Fin.castAdd q a) *
        rectSingularValue A (Fin.castAdd q a) * realSVDRightCoordinates A j (Fin.castAdd q a)) +
      ∑ b : Fin q, realSVDLeftCoordinates A i (Fin.natAdd k b) *
        rectSingularValue A (Fin.natAdd k b) * realSVDRightCoordinates A j (Fin.natAdd k b) := by
  rw [realSVDCoordinates_reconstruction A i j, Fin.sum_univ_add]

/-- Left coordinates after the rank cutoff are zero, including rank zero. -/
theorem realSVDLeftCoordinates_eq_zero_of_rank_le {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (a : Fin n) (ha : A.rank ≤ a.val)
    (i : Fin m) : realSVDLeftCoordinates A i a = 0 := by
  apply rectRightGramLeftSingularZeroSafe_eq_zero_of_singularValue_eq_zero
  rw [realSVDOrderedIndex_singularValue]
  exact rectSingularValue_eq_zero_of_rank_le A a ha

/-- The head and tail right-coordinate families are mutually orthogonal. -/
theorem realSVDRightCoordinates_head_tail_cross {m k q : ℕ}
    (A : Matrix (Fin m) (Fin (k + q)) ℝ) (a : Fin k) (b : Fin q) :
    (∑ i, realSVDRightCoordinates A i (Fin.castAdd q a) *
      realSVDRightCoordinates A i (Fin.natAdd k b)) = 0 := by
  rw [realSVDRightCoordinates_orthonormal]
  have hne : Fin.castAdd q a ≠ Fin.natAdd k b := by
    intro heq
    have hv := congrArg Fin.val heq
    simp only [Fin.val_castAdd, Fin.val_natAdd] at hv
    omega
  simp [hne]

/-- When the cutoff reaches the rank, the entire remaining padded tail is zero. -/
theorem realSVDCoordinates_tail_eq_zero_of_rank_le {m k q : ℕ}
    (A : Matrix (Fin m) (Fin (k + q)) ℝ) (hk : A.rank ≤ k)
    (i : Fin m) (j : Fin (k + q)) :
    (∑ b : Fin q, realSVDLeftCoordinates A i (Fin.natAdd k b) *
      rectSingularValue A (Fin.natAdd k b) *
      realSVDRightCoordinates A j (Fin.natAdd k b)) = 0 := by
  apply Finset.sum_eq_zero
  intro b _
  rw [rectSingularValue_eq_zero_of_rank_le A (Fin.natAdd k b) (by simpa using hk.trans (Nat.le_add_right k b.val))]
  ring

/-- Restricting the padded coordinates to the positive rank block gives an
ordinary rank-length SVD certificate, with no nonzero-rank hypothesis. -/
theorem realSVDCoordinates_isRealMatrixSVD {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    IsRealMatrixSVD A A.rank (rectSingularValue A)
      (fun a => WithLp.toLp 2 (fun i =>
        realSVDLeftCoordinates A i (Fin.castLE (Matrix.rank_le_width A) a)))
      (fun a => WithLp.toLp 2 (fun j =>
        realSVDRightCoordinates A j (Fin.castLE (Matrix.rank_le_width A) a))) := by
  classical
  let e : Fin A.rank ↪ Fin n := Fin.castLEEmb (Matrix.rank_le_width A)
  have horth {d r : ℕ} (w : Fin r → EuclideanSpace ℝ (Fin d)) :
      Orthonormal ℝ w ↔
        ∀ a b, (∑ i, w a i * w b i) = if a = b then 1 else 0 := by
    simp [orthonormal_iff_ite, PiLp.inner_apply, real_inner_eq_re_inner,
      RCLike.inner_apply, mul_comm]
  refine ⟨rfl, Matrix.rank_le_width A, rectSingularValue_nonneg A,
    rectSingularValue_antitone A, rectSingularValue_eq_zero_of_rank_le A, ?_, ?_, ?_⟩
  · rw [horth]
    intro a b
    have ha : 0 < rectRightGramBasisSingularValue A (realSVDOrderedIndex n (e a)) := by
      rw [realSVDOrderedIndex_singularValue]
      exact (rectSingularValue_pos_iff_lt_rank A (e a)).2 a.isLt
    have hb : 0 < rectRightGramBasisSingularValue A (realSVDOrderedIndex n (e b)) := by
      rw [realSVDOrderedIndex_singularValue]
      exact (rectSingularValue_pos_iff_lt_rank A (e b)).2 b.isLt
    have hh := rectRightGramLeftSingularZeroSafe_col_orthonormal_of_pos A ha hb
    simpa [realSVDLeftCoordinates, e, idMatrix,
      (realSVDOrderedIndex n).injective.eq_iff] using hh
  · rw [horth]
    intro a b
    simpa [e, Fin.ext_iff] using realSVDRightCoordinates_orthonormal A (e a) (e b)
  · intro i j
    let f : Fin n → ℝ := fun a =>
      realSVDLeftCoordinates A i a * rectSingularValue A a * realSVDRightCoordinates A j a
    have hs : (Finset.univ.map e).sum f = ∑ a : Fin n, f a := by
      apply Finset.sum_subset (Finset.subset_univ _)
      intro a _ ha
      have hge : A.rank ≤ a.val := by
        by_contra hnot
        have hlt : a.val < A.rank := Nat.lt_of_not_ge hnot
        apply ha
        apply Finset.mem_map.mpr
        exact ⟨⟨a.val, hlt⟩, Finset.mem_univ _, Fin.ext rfl⟩
      rw [rectSingularValue_eq_zero_of_rank_le A a hge]
      ring
    rw [realSVDCoordinates_reconstruction A i j, ← hs, Finset.sum_map]
    apply Finset.sum_congr rfl
    intro a _
    simp only [e, Fin.castLEEmb_apply]
    ring

/-- The full right coordinate table is orthogonal. -/
theorem realSVDRightCoordinates_isOrthogonal {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) : IsOrthogonal n (realSVDRightCoordinates A) := by
  apply IsOrthogonal.of_col_orthonormal
  intro a b
  simpa [idMatrix] using realSVDRightCoordinates_orthonormal A a b

/-- Matrix-product spelling of the padded SVD head/tail decomposition. -/
theorem realSVDCoordinates_head_tail_matrix {m k q : ℕ}
    (A : Matrix (Fin m) (Fin (k + q)) ℝ) :
    let U₁ : Matrix (Fin m) (Fin k) ℝ :=
      fun i a => realSVDLeftCoordinates A i (Fin.castAdd q a)
    let U₂ : Matrix (Fin m) (Fin q) ℝ :=
      fun i b => realSVDLeftCoordinates A i (Fin.natAdd k b)
    let V₁ : Matrix (Fin k) (Fin (k + q)) ℝ :=
      fun a j => realSVDRightCoordinates A j (Fin.castAdd q a)
    let V₂ : Matrix (Fin q) (Fin (k + q)) ℝ :=
      fun b j => realSVDRightCoordinates A j (Fin.natAdd k b)
    A = (U₁ * Matrix.diagonal (fun a => rectSingularValue A (Fin.castAdd q a))) * V₁ +
      (U₂ * Matrix.diagonal (fun b => rectSingularValue A (Fin.natAdd k b))) * V₂ := by
  dsimp only
  ext i j
  simpa [Matrix.mul_apply, Matrix.diagonal] using
    realSVDCoordinates_head_tail A i j

end NumStability
