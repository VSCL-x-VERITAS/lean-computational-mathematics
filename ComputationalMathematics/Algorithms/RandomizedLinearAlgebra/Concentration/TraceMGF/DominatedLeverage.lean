import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.TraceMGF.IndependentTrace

/-! # Lower Gram concentration for dominated leverage probabilities

The supplied finite probability law is sampled independently with replacement.
Its atoms may vanish: domination then forces the corresponding basis row to be zero.
-/
namespace NumStability
open scoped BigOperators ComplexOrder

/-- One importance-weighted outer product under the supplied law. -/
noncomputable def dominatedLeverageOuterGram {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (i : Fin m) (j k : Fin d) : ℝ := U i j * U i k / P.prob i

/-- Gram estimator for the actual iid draws from the supplied law. -/
noncomputable def dominatedLeverageSampleGram {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (samples : Fin s → Fin m) (j k : Fin d) : ℝ :=
  (∑ t : Fin s, dominatedLeverageOuterGram U P (samples t) j k) / (s : ℝ)

private theorem dominatedLeverageOuterGram_symmetric {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (i : Fin m) :
    IsSymmetricFiniteMatrix (dominatedLeverageOuterGram U P i) := by
  intro j k
  unfold dominatedLeverageOuterGram
  ring

private theorem dominatedLeverage_centered_symmetric {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (i : Fin m) :
    IsSymmetricFiniteMatrix
      (fun j k => dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) := by
  intro j k
  have h := dominatedLeverageOuterGram_symmetric U P i j k
  change dominatedLeverageOuterGram U P i j k = dominatedLeverageOuterGram U P i k j at h
  change dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k =
    dominatedLeverageOuterGram U P i k j - finiteIdMatrix k j
  rw [h]
  by_cases hjk : j = k
  · subst k; rfl
  · simp [finiteIdMatrix, hjk, Ne.symm hjk]

private theorem dominatedLeverageOuterGram_psd {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (i : Fin m) :
    finitePSD (dominatedLeverageOuterGram U P i) := by
  let V : Fin 1 → Fin d → ℝ := fun _ j => U i j
  have heq : dominatedLeverageOuterGram U P i =
      fun j k => (P.prob i)⁻¹ * uniformRowOuterGramSample V 0 j k := by
    ext j k
    simp [dominatedLeverageOuterGram, uniformRowOuterGramSample, V]
    ring
  intro x
  rw [heq, finiteQuadraticForm_smul]
  exact mul_nonneg (inv_nonneg.mpr (P.prob_nonneg i)) (finitePSD_uniformRowOuterGramSample V 0 x)

private theorem dominatedLeverageOuterGram_square {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (i : Fin m) :
    finiteMatMul (dominatedLeverageOuterGram U P i) (dominatedLeverageOuterGram U P i) =
      fun j k => (rowNormSq U i / P.prob i) * dominatedLeverageOuterGram U P i j k := by
  ext j k
  unfold finiteMatMul dominatedLeverageOuterGram rowNormSq
  rw [Finset.sum_div, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro l _
  ring

private theorem dominatedLeverage_row_zero {m d : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i)
    (i : Fin m) (hi : P.prob i = 0) (j : Fin d) : U i j = 0 := by
  have hz : rowNormSq U i = 0 := le_antisymm (by simpa [hi] using hcap i) (rowNormSq_nonneg U i)
  exact (rowNormSq_eq_zero_iff U i).mp hz j

private theorem dominatedLeverageOuterGram_mean {m d : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (P : FiniteProbability (Fin m)) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) :
    P.expectationCStarMatrix (fun i => finiteComplexCStarMatrix (dominatedLeverageOuterGram U P i)) =
      (1 : CStarMatrix (Fin d) (Fin d) ℂ) := by
  classical
  rw [FiniteProbability.expectationCStarMatrix_finiteComplexCStarMatrix]
  have hmean : ∀ j k, P.expectationReal (fun i => dominatedLeverageOuterGram U P i j k) =
      finiteIdMatrix j k := by
    intro j k
    unfold FiniteProbability.expectationReal
    have heq : (∑ i, P.prob i * dominatedLeverageOuterGram U P i j k) = ∑ i, U i j * U i k := by
      apply Finset.sum_congr rfl
      intro i _
      by_cases hi : P.prob i = 0
      · simp [hi, dominatedLeverage_row_zero U P hcap i hi j]
      · unfold dominatedLeverageOuterGram
        field_simp
    rw [heq]
    exact hU j k
  ext j k
  by_cases hjk : j = k
  · subst k; simp [hmean, finiteIdMatrix]
  · simp [hmean, finiteIdMatrix, hjk]

private theorem dominatedLeverage_centered_square
    {m n : ℕ} (U : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m)) (i : Fin m) :
    finiteMatMul
        (fun j k : Fin n =>
          dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)
        (fun j k : Fin n =>
          dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) =
      fun j k : Fin n =>
        finiteMatMul
            (fun a b : Fin n => dominatedLeverageOuterGram U P i a b)
            (fun a b : Fin n => dominatedLeverageOuterGram U P i a b) j k -
          dominatedLeverageOuterGram U P i j k -
          dominatedLeverageOuterGram U P i j k +
          finiteIdMatrix j k := by
  classical
  ext j k
  unfold finiteMatMul
  calc
    ∑ l : Fin n,
        (dominatedLeverageOuterGram U P i j l - finiteIdMatrix j l) *
          (dominatedLeverageOuterGram U P i l k - finiteIdMatrix l k)
        =
      (∑ l : Fin n,
        dominatedLeverageOuterGram U P i j l *
          dominatedLeverageOuterGram U P i l k) -
        dominatedLeverageOuterGram U P i j k -
        dominatedLeverageOuterGram U P i j k +
        finiteIdMatrix j k := by
          calc
            ∑ l : Fin n,
                (dominatedLeverageOuterGram U P i j l - finiteIdMatrix j l) *
                  (dominatedLeverageOuterGram U P i l k - finiteIdMatrix l k)
                =
              ∑ l : Fin n,
                (dominatedLeverageOuterGram U P i j l *
                    dominatedLeverageOuterGram U P i l k -
                  dominatedLeverageOuterGram U P i j l * finiteIdMatrix l k -
                  finiteIdMatrix j l * dominatedLeverageOuterGram U P i l k +
                  finiteIdMatrix j l * finiteIdMatrix l k) := by
                  apply Finset.sum_congr rfl
                  intro l _
                  ring
            _ =
              (∑ l : Fin n,
                  dominatedLeverageOuterGram U P i j l *
                    dominatedLeverageOuterGram U P i l k) -
                (∑ l : Fin n,
                  dominatedLeverageOuterGram U P i j l * finiteIdMatrix l k) -
                (∑ l : Fin n,
                  finiteIdMatrix j l * dominatedLeverageOuterGram U P i l k) +
                (∑ l : Fin n,
                  finiteIdMatrix j l * finiteIdMatrix l k) := by
                  rw [Finset.sum_add_distrib]
                  rw [Finset.sum_sub_distrib]
                  rw [Finset.sum_sub_distrib]
            _ =
              (∑ l : Fin n,
                dominatedLeverageOuterGram U P i j l *
                  dominatedLeverageOuterGram U P i l k) -
                dominatedLeverageOuterGram U P i j k -
                dominatedLeverageOuterGram U P i j k +
                finiteIdMatrix j k := by
                  simp [finiteIdMatrix]

/-- Linear centered variance under an importance-weight cap. -/
theorem dominatedLeverage_centered_square_expectation_le
    {m n : ℕ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (P : FiniteProbability (Fin m)) {L : ℝ}
    (hL : 0 ≤ L) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) :
    P.expectationCStarMatrix
      (fun i : RowSample m =>
        (finiteComplexCStarMatrix
            (fun j k : Fin n => dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) *
          finiteComplexCStarMatrix
            (fun j k : Fin n => dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) :
          CStarMatrix (Fin n) (Fin n) ℂ)) ≤
      (L : ℂ) • (1 : CStarMatrix (Fin n) (Fin n) ℂ) := by
  classical
  let Y : RowSample m → Fin n → Fin n → ℝ := dominatedLeverageOuterGram U P
  let C : RowSample m → Fin n → Fin n → ℝ :=
    fun i j k => Y i j k - finiteIdMatrix j k
  have hrow : ∀ i, rowNormSq U i / P.prob i ≤ L := by
    intro i
    by_cases hi : P.prob i = 0
    · simpa [hi] using hL
    · exact (div_le_iff₀ (lt_of_le_of_ne (P.prob_nonneg i) (Ne.symm hi))).mpr (hcap i)
  have hmean : P.expectationCStarMatrix (fun i => finiteComplexCStarMatrix (Y i)) =
      (1 : CStarMatrix (Fin n) (Fin n) ℂ) := dominatedLeverageOuterGram_mean U hU P hcap
  have hpoint : ∀ i : RowSample m,
      (finiteComplexCStarMatrix (C i) * finiteComplexCStarMatrix (C i) :
        CStarMatrix (Fin n) (Fin n) ℂ) ≤
      (L - 1 : ℂ) • finiteComplexCStarMatrix (Y i) + 1 := by
    intro i
    let N : Fin n → Fin n → ℝ :=
      fun j k => (L - 1) * Y i j k + finiteIdMatrix j k
    have hLo : finiteLoewnerLe (finiteMatMul (C i) (C i)) N := by
      intro x
      have hsq := dominatedLeverage_centered_square U P i
      have hYsq := dominatedLeverageOuterGram_square U P i
      change finiteQuadraticForm
        (finiteMatMul
          (fun j k => dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)
          (fun j k => dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)) x ≤ _
      rw [hsq, hYsq]
      change finiteQuadraticForm
        (fun j k => (rowNormSq U i / P.prob i) * Y i j k - Y i j k - Y i j k +
          finiteIdMatrix j k) x ≤ finiteQuadraticForm N x
      dsimp [N]
      rw [finiteQuadraticForm_add, finiteQuadraticForm_sub, finiteQuadraticForm_sub,
        finiteQuadraticForm_smul, finiteQuadraticForm_finiteIdMatrix,
        finiteQuadraticForm_add, finiteQuadraticForm_smul,
        finiteQuadraticForm_finiteIdMatrix]
      have hpsd : 0 ≤ finiteQuadraticForm (Y i) x := dominatedLeverageOuterGram_psd U P i x
      have hc := mul_le_mul_of_nonneg_right (hrow i) hpsd
      nlinarith
    have hsym : IsSymmetricFiniteMatrix N := by
      intro j k
      have h := dominatedLeverageOuterGram_symmetric U P i j k
      change dominatedLeverageOuterGram U P i j k = dominatedLeverageOuterGram U P i k j at h
      dsimp [N, Y]
      rw [h]
      by_cases hjk : j = k
      · subst k; rfl
      · simp [finiteIdMatrix, hjk, Ne.symm hjk]
    have h := finiteComplexCStarMatrix_le_of_finiteLoewnerLe
      (finiteMatMul (C i) (C i)) N
      (finiteMatMul_self_symmetric_of_symmetric _
        (dominatedLeverage_centered_symmetric U P i)) hsym hLo
    rw [finiteComplexCStarMatrix_mul] at h
    simpa [N, finiteComplexCStarMatrix_add, finiteComplexCStarMatrix_smul,
      finiteComplexCStarMatrix_finiteIdMatrix] using h
  have h := P.expectationCStarMatrix_mono _ _ hpoint
  have heq : P.expectationCStarMatrix
      (fun i => (L - 1 : ℂ) • finiteComplexCStarMatrix (Y i) + 1) =
      (L : ℂ) • (1 : CStarMatrix (Fin n) (Fin n) ℂ) := by
    rw [FiniteProbability.expectationCStarMatrix_add,
      FiniteProbability.expectationCStarMatrix_smul,
      FiniteProbability.expectationCStarMatrix_const, hmean]
    ext j k
    by_cases hjk : j = k
    · subst k; simp
    · simp [hjk]
  exact h.trans (le_of_eq heq)

theorem dominatedLeverage_neg_centered_le_one
    {m n : ℕ} (U : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m)) (i : Fin m) :
    finiteLoewnerLe
      (fun j k : Fin n => -(dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k))
      (fun j k : Fin n => finiteIdMatrix j k) := by
  intro x
  have hpsd := dominatedLeverageOuterGram_psd U P i x
  rw [show
      (fun j k : Fin n =>
        -(dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)) =
        fun j k : Fin n => finiteIdMatrix j k - dominatedLeverageOuterGram U P i j k by
        ext j k
        ring]
  rw [finiteQuadraticForm_sub, finiteQuadraticForm_finiteIdMatrix]
  linarith

/-- Real spectrum upper bound for the negative centered importance-weighted estimator. -/
theorem dominatedLeverage_neg_centered_spectrum_le_one {m n : ℕ}
    (U : Fin m → Fin n → ℝ) (P : FiniteProbability (Fin m)) (i : Fin m) {x : ℝ}
    (hx :
      x ∈ spectrum ℝ
        (-finiteComplexCStarMatrix
          (fun j k : Fin n =>
            dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) :
          CStarMatrix (Fin n) (Fin n) ℂ)) :
    x ≤ 1 := by
  classical
  let M : Fin n → Fin n → ℝ :=
    fun j k => -(dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)
  let N : Fin n → Fin n → ℝ := fun j k => finiteIdMatrix j k
  have hMsym : IsSymmetricFiniteMatrix M := by
    intro j k
    dsimp [M]
    have hsym := dominatedLeverage_centered_symmetric U P i j k
    simpa using congrArg Neg.neg hsym
  have hNsym : IsSymmetricFiniteMatrix N := by
    intro j k
    by_cases h : j = k
    · subst h
      simp [N, finiteIdMatrix]
    · have hk : k ≠ j := Ne.symm h
      simp [N, finiteIdMatrix, h, hk]
  have hLe : finiteLoewnerLe M N := by
    simpa [M, N] using
      dominatedLeverage_neg_centered_le_one U P i
  have hCLe :
      finiteComplexCStarMatrix M ≤
        (1 : ℂ) • (1 : CStarMatrix (Fin n) (Fin n) ℂ) := by
    have hC := finiteComplexCStarMatrix_le_of_finiteLoewnerLe M N hMsym hNsym hLe
    simpa [N, finiteComplexCStarMatrix_finiteIdMatrix] using hC
  have hMembed :
      finiteComplexCStarMatrix M =
        -finiteComplexCStarMatrix
          (fun j k : Fin n =>
            dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) := by
    ext j k
    simp [M]
  have hxM :
      x ∈ spectrum ℝ (finiteComplexCStarMatrix M) := by
    simpa [hMembed] using hx
  exact cstarMatrix_spectrum_le_of_le_real_smul_one hCLe hxM

/-- The importance-weighted centered estimator has mean zero. -/
theorem dominatedLeverage_centered_mean_zero {m d : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (P : FiniteProbability (Fin m)) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) :
    P.expectationCStarMatrix (fun i => finiteComplexCStarMatrix
      (fun j k => dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)) = 0 := by
  simp_rw [finiteComplexCStarMatrix_sub, finiteComplexCStarMatrix_finiteIdMatrix]
  rw [FiniteProbability.expectationCStarMatrix_sub,
    FiniteProbability.expectationCStarMatrix_const,
    dominatedLeverageOuterGram_mean U hU P hcap, sub_self]

theorem dominatedLeverage_neg_centered_log_cgf_le
    {m n : ℕ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (P : FiniteProbability (Fin m))
    {L : ℝ} (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i)
    {theta : ℝ} (htheta : 0 ≤ theta) :
    let beta : ℝ := Real.exp theta - theta - 1
    CFC.log
        (P.expectationCStarMatrix
          (fun i : RowSample m =>
            NormedSpace.exp
              (theta •
                (-finiteComplexCStarMatrix
                  (fun j k : Fin n =>
                    dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)) :
                CStarMatrix (Fin n) (Fin n) ℂ))) ≤
      beta •
        P.expectationCStarMatrix
          (fun i : RowSample m =>
            (finiteComplexCStarMatrix
                (fun j k : Fin n =>
                  dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) *
              finiteComplexCStarMatrix
                (fun j k : Fin n =>
                  dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) :
              CStarMatrix (Fin n) (Fin n) ℂ)) := by
  classical
  intro beta
  let X : RowSample m → CStarMatrix (Fin n) (Fin n) ℂ :=
    fun i =>
      finiteComplexCStarMatrix
        (fun j k : Fin n =>
          dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)
  let Xneg : RowSample m → CStarMatrix (Fin n) (Fin n) ℂ :=
    fun i => -X i
  have hX : ∀ i, IsSelfAdjoint (Xneg i) := by
    intro i
    have hXi : IsSelfAdjoint (X i) := by
      exact finiteComplexCStarMatrix_isSelfAdjoint_of_symmetric _
        (dominatedLeverage_centered_symmetric U P i)
    simpa [Xneg] using hXi.neg
  have hmeanX : P.expectationCStarMatrix X = 0 := by
    simpa [X] using
      dominatedLeverage_centered_mean_zero
        U hU P hcap
  have hmean : P.expectationCStarMatrix Xneg = 0 := by
    calc
      P.expectationCStarMatrix Xneg = -P.expectationCStarMatrix X := by
        simpa [Xneg] using
          (FiniteProbability.expectationCStarMatrix_neg P X)
      _ = 0 := by simp [hmeanX]
  have hR : 0 < (1 : ℝ) := by norm_num
  have hspec :
      ∀ i : RowSample m, 0 < P.prob i →
        ∀ x : ℝ, x ∈ spectrum ℝ (Xneg i) → x ≤ (1 : ℝ) := by
    intro i _ x hx
    simpa [X, Xneg] using
      dominatedLeverage_neg_centered_spectrum_le_one U P i hx
  have hlog :=
    P.cstarMatrix_log_expectationCStarMatrix_normed_exp_real_smul_le_bernstein_variance_proxy_of_prob_pos
      hX hmean htheta hR hspec
  have hsq :
      (fun i : RowSample m => Xneg i * Xneg i) =
        (fun i : RowSample m => X i * X i) := by
    funext i
    ext j k
    simp [Xneg, X, CStarMatrix.mul_apply]
    apply Finset.sum_congr rfl
    intro l _
    ring
  simpa [X, Xneg, beta, hsq] using hlog

private theorem dominatedLeverageSampleGram_centered_average {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (hs : 0 < (s : ℝ)) (samples : Fin s → Fin m) (j k : Fin d) :
    dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k =
      (∑ t : Fin s, (dominatedLeverageOuterGram U P (samples t) j k - finiteIdMatrix j k)) /
        (s : ℝ) := by
  rw [Finset.sum_sub_distrib, Finset.sum_const]
  simp only [Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  unfold dominatedLeverageSampleGram
  field_simp [hs.ne']

theorem dominatedLeverage_neg_centered_log_cgf_le_scalar
    {m n : ℕ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (P : FiniteProbability (Fin m))
    {L theta : ℝ} (htheta : 0 ≤ theta)
    (hL : 0 ≤ L) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) :
    let beta : ℝ := Real.exp theta - theta - 1
    CFC.log
        (P.expectationCStarMatrix
          (fun i : RowSample m =>
            NormedSpace.exp
              (theta •
                (-finiteComplexCStarMatrix
                  (fun j k : Fin n =>
                    dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)) :
                CStarMatrix (Fin n) (Fin n) ℂ))) ≤
      ((beta * L : ℝ) : ℂ) •
        (1 : CStarMatrix (Fin n) (Fin n) ℂ) := by
  classical
  intro beta
  have hbase :=
    dominatedLeverage_neg_centered_log_cgf_le
      U hU P hcap htheta
  have hvar :=
    dominatedLeverage_centered_square_expectation_le
      U hU P hL hcap
  have hbeta_nonneg : 0 ≤ beta := by
    dsimp [beta]
    exact real_exp_sub_self_sub_one_nonneg theta
  have hscaled :
      beta •
        P.expectationCStarMatrix
          (fun i : RowSample m =>
            (finiteComplexCStarMatrix
                (fun j k : Fin n =>
                  dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) *
              finiteComplexCStarMatrix
                (fun j k : Fin n =>
                  dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) :
              CStarMatrix (Fin n) (Fin n) ℂ)) ≤
        (((beta * L : ℝ) : ℂ) •
          (1 : CStarMatrix (Fin n) (Fin n) ℂ)) := by
    have h1 := smul_le_smul_of_nonneg_left hvar hbeta_nonneg
    have hEq :
        beta • ((((L : ℝ) : ℂ)) •
            (1 : CStarMatrix (Fin n) (Fin n) ℂ)) =
          (((beta * L : ℝ) : ℂ) •
            (1 : CStarMatrix (Fin n) (Fin n) ℂ)) := by
      ext i j
      by_cases hij : i = j
      · subst j
        simp
      · simp [hij]
    exact h1.trans (le_of_eq hEq)
  exact hbase.trans (by simpa [beta] using hscaled)

/-- Lower-tail adapter using the linear variance proxy. -/
theorem dominatedLeverage_iid_neg_centered_log_mgf_le
    {m n s : ℕ} {theta L : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (P : FiniteProbability (Fin m))
    (htheta : 0 ≤ theta)
    (hL : 0 ≤ L) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) :
    let beta : ℝ := Real.exp theta - theta - 1
    FiniteProbability.iidFiniteRealTraceMGFLogBound
      (steps := s) P
      (fun _a _b : Fin n => 0)
      (fun i j k =>
        (-theta) * (dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)) ≤
      (n : ℝ) * Real.exp ((s : ℝ) * (beta * L)) := by
  classical
  intro beta
  let X : RowSample m → Fin n → Fin n → ℝ :=
    fun i j k => dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k
  have hlog :
      CFC.log
          (P.expectationCStarMatrix
            (fun i : RowSample m =>
              NormedSpace.exp
                (theta •
                  (-finiteComplexCStarMatrix (X i)) :
                  CStarMatrix (Fin n) (Fin n) ℂ))) ≤
        (((beta * L : ℝ) : ℂ) •
          (1 : CStarMatrix (Fin n) (Fin n) ℂ)) := by
    simpa [beta, X] using
      dominatedLeverage_neg_centered_log_cgf_le_scalar
        U hU P htheta hL hcap
  have hK :
      CFC.log
          (P.expectationCStarMatrix
            (fun i : RowSample m =>
              NormedSpace.exp
                (finiteComplexCStarMatrix
                  (fun j k : Fin n => (-theta) * X i j k)))) ≤
        (((beta * L : ℝ) : ℂ) •
          (1 : CStarMatrix (Fin n) (Fin n) ℂ)) := by
    have hexp :
        (fun i : RowSample m =>
          NormedSpace.exp
            (finiteComplexCStarMatrix
              (fun j k : Fin n => (-theta) * X i j k))) =
        (fun i : RowSample m =>
          NormedSpace.exp
            (theta •
              (-finiteComplexCStarMatrix (X i)) :
              CStarMatrix (Fin n) (Fin n) ℂ)) := by
      funext i
      congr 1
      ext j k
      simp [X]
      ring
    rw [hexp]
    exact hlog
  have hbound :=
    FiniteProbability.iidFiniteRealTraceMGFLogBound_zero_le_card_mul_exp_of_log_le_real_smul_one
      (steps := s) P
      (fun (i : RowSample m) (j k : Fin n) => (-theta) * X i j k)
      hK
  simpa [X, beta, Fintype.card_fin] using hbound

/-- Lower-tail adapter using the linear variance proxy. -/
theorem dominatedLeverageSampleGram_lower_eventProb_exp_ge
    {m n s : ℕ} {theta ε L : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (P : FiniteProbability (Fin m))
    (hs : 0 < (s : ℝ)) (htheta : 0 < theta)
    (hL : 0 ≤ L) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) :
    let beta : ℝ := Real.exp theta - theta - 1
    1 -
      Real.exp (-(theta * (s : ℝ) * ε)) *
        ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L))) ≤
      (P.iid s).eventProb
        {samples |
          finiteLoewnerLe
            (fun j k : Fin n =>
              -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k))
            (fun j k : Fin n => ε * finiteIdMatrix j k)} := by
  classical
  intro beta
  let Q := P.iid s
  let T : ℝ := theta * (s : ℝ) * ε
  let Xneg : RowSample m → Fin n → Fin n → ℝ :=
    fun i j k => (-theta) * (dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k)
  let Mneg : RowTrace m s → Fin n → Fin n → ℝ :=
    fun samples j k => ∑ t : Fin s, Xneg (samples t) j k
  let GoodEig : Set (RowTrace m s) :=
    {samples |
      ∀ a : Fin n,
        finiteHermitianEigenvalues (Mneg samples)
          (by
            intro j k
            dsimp [Mneg, Xneg]
            apply Finset.sum_congr rfl
            intro t _
            have hsym :=
              dominatedLeverage_centered_symmetric U P (samples t) j k
            change
              (-theta) *
                  (dominatedLeverageOuterGram U P (samples t) j k -
                    finiteIdMatrix j k) =
                (-theta) *
                  (dominatedLeverageOuterGram U P (samples t) k j -
                    finiteIdMatrix k j)
            simpa using congrArg (fun x => (-theta) * x) hsym)
          a < T}
  let GoodLoewner : Set (RowTrace m s) :=
    {samples |
      finiteLoewnerLe
        (fun j k : Fin n =>
          -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k))
        (fun j k : Fin n => ε * finiteIdMatrix j k)}
  have hMneg : ∀ samples, IsSymmetricFiniteMatrix (Mneg samples) := by
    intro samples j k
    dsimp [Mneg, Xneg]
    apply Finset.sum_congr rfl
    intro t _
    have hsym := dominatedLeverage_centered_symmetric U P (samples t) j k
    change
      (-theta) *
          (dominatedLeverageOuterGram U P (samples t) j k -
            finiteIdMatrix j k) =
        (-theta) *
          (dominatedLeverageOuterGram U P (samples t) k j -
            finiteIdMatrix k j)
    simpa using congrArg (fun x => (-theta) * x) hsym
  have hzeroSym :
      IsSymmetricFiniteMatrix (fun _a _b : Fin n => 0) := by
    intro j k
    rfl
  have hXnegSym : ∀ i : RowSample m, IsSymmetricFiniteMatrix (Xneg i) := by
    intro i j k
    dsimp [Xneg]
    have hsym := dominatedLeverage_centered_symmetric U P i j k
    change
      (-theta) * (dominatedLeverageOuterGram U P i j k - finiteIdMatrix j k) =
        (-theta) * (dominatedLeverageOuterGram U P i k j - finiteIdMatrix k j)
    simpa using congrArg (fun x => (-theta) * x) hsym
  have hTraceLog :
      Q.expectationReal
          (fun samples => finiteTrace (finiteMatrixExp (Mneg samples))) ≤
        FiniteProbability.iidFiniteRealTraceMGFLogBound
          (steps := s) P
          (fun _a _b : Fin n => 0)
          Xneg := by
    have h :=
      FiniteProbability.iid_expectationReal_finiteTrace_finiteMatrixExp_add_sum_le
        (steps := s) P hzeroSym hXnegSym
    simpa [Q, Mneg, Xneg, FiniteProbability.iidFiniteRealTraceMGFLogBound]
      using h
  have hTraceScalar :
      Q.expectationReal
          (fun samples => finiteTrace (finiteMatrixExp (Mneg samples))) ≤
        (n : ℝ) * Real.exp ((s : ℝ) * (beta * L)) := by
    exact hTraceLog.trans
      (by
        simpa [Xneg, beta] using
          dominatedLeverage_iid_neg_centered_log_mgf_le
            (s := s) U hU P (le_of_lt htheta) hL hcap)
  have hEigProb :
      1 -
        Real.exp (-T) *
          ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L))) ≤
        Q.eventProb GoodEig := by
    simpa [Q, GoodEig, Mneg, T, beta] using
      FiniteProbability.eventProb_forall_finiteHermitianEigenvalue_lt_ge_one_sub_exp_neg_mul_trace_bound
        (P := Q) (M := Mneg) hMneg T
        ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L)))
        hTraceScalar
  have hsubset : GoodEig ⊆ GoodLoewner := by
    intro samples hsamples
    have hEig : ∀ a : Fin n, finiteHermitianEigenvalues (Mneg samples) (hMneg samples) a ≤ T := by
      intro a
      exact le_of_lt (by simpa [GoodEig, Mneg, T] using hsamples a)
    have hLoM :
        finiteLoewnerLe (Mneg samples)
          (fun j k : Fin n => T * finiteIdMatrix j k) :=
      finiteLoewnerLe_smul_id_of_finiteHermitianEigenvalues_le
        (Mneg samples) (hMneg samples) hEig
    let Eneg : Fin n → Fin n → ℝ :=
      fun j k => -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k)
    have hM_eq :
        Mneg samples = fun j k : Fin n => (theta * (s : ℝ)) * Eneg j k := by
      ext j k
      have hcenter :=
        dominatedLeverageSampleGram_centered_average
          U P hs samples j k
      have hs_ne : (s : ℝ) ≠ 0 := ne_of_gt hs
      dsimp [Mneg, Xneg, Eneg]
      calc
        ∑ t : Fin s,
            (-theta) *
              (dominatedLeverageOuterGram U P (samples t) j k - finiteIdMatrix j k)
            =
          (-theta) * ∑ t : Fin s,
            (dominatedLeverageOuterGram U P (samples t) j k - finiteIdMatrix j k) := by
            rw [Finset.mul_sum]
        _ =
          theta * (s : ℝ) *
            (-((∑ t : Fin s,
              (dominatedLeverageOuterGram U P (samples t) j k - finiteIdMatrix j k)) /
                (s : ℝ))) := by
            field_simp [hs_ne]
        _ = theta * (s : ℝ) *
            (-(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k)) := by
            rw [← hcenter]
    have hscaled :
        finiteLoewnerLe
          (fun j k : Fin n => (theta * (s : ℝ)) * Eneg j k)
          (fun j k : Fin n => T * finiteIdMatrix j k) := by
      simpa [hM_eq] using hLoM
    have htheta_s : 0 < theta * (s : ℝ) := mul_pos htheta hs
    have hunscaled :=
      finiteLoewnerLe_of_smul_left_le_smul_id Eneg htheta_s hscaled
    have hTdiv : T / (theta * (s : ℝ)) = ε := by
      dsimp [T]
      field_simp [(ne_of_gt htheta_s)]
    have hGood : GoodLoewner samples := by
      simpa [GoodLoewner, Eneg, hTdiv] using hunscaled
    exact hGood
  exact hEigProb.trans (FiniteProbability.eventProb_mono Q hsubset)

/-- Lower Gram tail under an explicit importance-weight cap. -/
theorem dominatedLeverageSampleGram_lower_eventProb_ge_of_cap_budget
    {m n s : ℕ} {L ε δ : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (P : FiniteProbability (Fin m)) (hn : 0 < n)
    (hs : 0 < (s : ℝ)) (hL : 0 < L) (hε : 0 < ε) (hδ : 0 < δ)
    (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i)
    (hbudget : Real.log ((2 * (n : ℝ)) / δ) ≤
      (s : ℝ) * (ε ^ 2 / (2 * L + (2 / 3) * ε))) :
    1 - δ / 2 ≤
      (P.iid s).eventProb
        {samples | finiteLoewnerLe
          (fun j k : Fin n => -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k))
          (fun j k : Fin n => ε * finiteIdMatrix j k)} := by
  let theta : ℝ := Real.log (1 + ε / L)
  have htheta : 0 < theta := by
    apply Real.log_pos
    have : 0 < ε / L := div_pos hε hL
    linarith
  have hprob :=
    dominatedLeverageSampleGram_lower_eventProb_exp_ge
      (s := s) (ε := ε) U hU P hs htheta hL.le hcap
  have hB : 0 < (n : ℝ) := by exact_mod_cast hn
  have htail := real_bernstein_tail_le_half_delta_of_quadratic_budget
    (B := (n : ℝ)) (W := L) (L := 1) (r := ε) (s := (s : ℝ)) (δ := δ)
    hB hL (by norm_num) hε hs hδ (by simpa using hbudget)
  have htail' : Real.exp (-(theta * (s : ℝ) * ε)) *
      ((n : ℝ) * Real.exp ((s : ℝ) * ((Real.exp theta - theta - 1) * L))) ≤ δ / 2 := by
    simpa [theta] using htail
  exact (sub_le_sub_left htail' 1).trans hprob

/-- A linear-in-cap sample budget suffices for the half-identity lower Gram
event. The dimension occurs only inside the logarithm. -/
theorem dominatedLeverageSampleGram_lower_half_eventProb_ge_of_cap_budget
    {m n s : ℕ} {L δ : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (P : FiniteProbability (Fin m)) (hn : 0 < n)
    (hs : 0 < (s : ℝ)) (hL : 1 ≤ L) (hδ : 0 < δ) (hδone : δ < 1)
    (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i)
    (hbudget : 10 * L * Real.log ((2 * (n : ℝ)) / δ) ≤ (s : ℝ)) :
    1 - δ / 2 ≤
      (P.iid s).eventProb
        {samples | finiteLoewnerLe
          (fun j k : Fin n => -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k))
          (fun j k : Fin n => (1 / 2 : ℝ) * finiteIdMatrix j k)} := by
  have hLpos : 0 < L := lt_of_lt_of_le (by norm_num) hL
  apply dominatedLeverageSampleGram_lower_eventProb_ge_of_cap_budget
    U hU P hn hs hLpos (by norm_num) hδ hcap
  have hnreal : 1 ≤ (n : ℝ) := by exact_mod_cast hn
  have harg : 1 ≤ (2 * (n : ℝ)) / δ := by
    rw [le_div_iff₀ hδ]
    nlinarith
  have hlog : 0 ≤ Real.log ((2 * (n : ℝ)) / δ) := Real.log_nonneg harg
  have hden : 0 < 2 * L + (2 / 3 : ℝ) * (1 / 2) := by positivity
  have hmain : Real.log ((2 * (n : ℝ)) / δ) *
      (2 * L + (2 / 3 : ℝ) * (1 / 2)) ≤ (s : ℝ) * (1 / 2 : ℝ) ^ 2 := by
    have hcoef : 2 * L + (2 / 3 : ℝ) * (1 / 2) ≤ (10 * L) / 4 := by linarith
    have hmul := mul_le_mul_of_nonneg_left hcoef hlog
    nlinarith
  simpa only [mul_div_assoc] using (le_div_iff₀ hden).mpr hmain

/-- Leverage domination gives the requisite importance-weight cap. -/
theorem dominatedLeverage_cap {m d : ℕ} {β : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (hd : 0 < d) (hβ : 0 < β)
    (hdom : ∀ i, β * rowNormSq U i / (d : ℝ) ≤ P.prob i) :
    ∀ i, rowNormSq U i ≤ ((d : ℝ) / β) * P.prob i := by
  intro i
  have hdreal : 0 < (d : ℝ) := by exact_mod_cast hd
  have h := (div_le_iff₀ hdreal).mp (hdom i)
  rw [div_mul_eq_mul_div]
  apply (le_div_iff₀ hβ).mpr
  nlinarith

/-- The actual iid law from probabilities dominating a fraction `β` of exact
leverage has a half-identity lower Gram bound with a `β⁻¹` sample budget. -/
theorem dominatedLeverageSampleGram_lower_half_eventProb_ge
    {m d s : ℕ} {β δ : ℝ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (P : FiniteProbability (Fin m)) (hd : 0 < d)
    (hβ : 0 < β) (hβone : β ≤ 1) (hs : 0 < (s : ℝ))
    (hdom : ∀ i, β * rowNormSq U i / (d : ℝ) ≤ P.prob i)
    (hδ : 0 < δ) (hδone : δ < 1)
    (hbudget : 10 * ((d : ℝ) / β) * Real.log ((2 * (d : ℝ)) / δ) ≤ (s : ℝ)) :
    1 - δ / 2 ≤ (P.iid s).eventProb
      {samples | finiteLoewnerLe
        (fun j k : Fin d => -(dominatedLeverageSampleGram U P samples j k - finiteIdMatrix j k))
        (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)} := by
  have hdreal : 1 ≤ (d : ℝ) := by exact_mod_cast hd
  have hL : 1 ≤ (d : ℝ) / β := (one_le_div hβ).mpr (hβone.trans hdreal)
  exact dominatedLeverageSampleGram_lower_half_eventProb_ge_of_cap_budget
    U hU P hd hs hL hδ hδone (dominatedLeverage_cap U P hd hβ hdom) hbudget

end NumStability
