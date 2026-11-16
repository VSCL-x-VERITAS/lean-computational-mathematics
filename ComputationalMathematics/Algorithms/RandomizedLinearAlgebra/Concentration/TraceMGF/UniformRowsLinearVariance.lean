import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.TraceMGF.UniformRows

/-!
# Linear variance for the lower tail of uniform row sampling

For an orthonormal basis, the mean row outer product is the identity.
A bound `m * ‖Uᵢ‖² ≤ L` therefore gives centered variance at most `L I`,
rather than a quadratic function of `L`. The negative centered increment has
spectral upper bound one, giving a lower Gram tail with linear sample budget.
-/

namespace NumStability

open scoped BigOperators ComplexOrder

/-- A row cap yields a linear centered variance proxy after averaging. -/
theorem uniformRowOuterGramSample_centered_square_expectationCStarMatrix_le_linear_variance
    {m n : ℕ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m) {L : ℝ}
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L) :
    (uniformRowSampleProbability hm).expectationCStarMatrix
      (fun i : RowSample m =>
        (finiteComplexCStarMatrix
            (fun j k : Fin n => uniformRowOuterGramSample U i j k - finiteIdMatrix j k) *
          finiteComplexCStarMatrix
            (fun j k : Fin n => uniformRowOuterGramSample U i j k - finiteIdMatrix j k) :
          CStarMatrix (Fin n) (Fin n) ℂ)) ≤
      (L : ℂ) • (1 : CStarMatrix (Fin n) (Fin n) ℂ) := by
  classical
  let P := uniformRowSampleProbability hm
  let Y : RowSample m → Fin n → Fin n → ℝ := uniformRowOuterGramSample U
  let C : RowSample m → Fin n → Fin n → ℝ :=
    fun i j k => Y i j k - finiteIdMatrix j k
  have hmean : P.expectationCStarMatrix (fun i => finiteComplexCStarMatrix (Y i)) =
      (1 : CStarMatrix (Fin n) (Fin n) ℂ) := by
    rw [FiniteProbability.expectationCStarMatrix_finiteComplexCStarMatrix]
    ext j k
    have h := uniform_rowOuterGramSample_mean_eq_id U hU hm j k
    by_cases hjk : j = k
    · subst k
      simpa [P, Y, FiniteProbability.expectationReal, uniformRowSampleProbability,
        uniformRowProb, idMatrix] using congrArg (fun x : ℝ => (x : ℂ)) h
    · simpa [P, Y, FiniteProbability.expectationReal, uniformRowSampleProbability,
        uniformRowProb, idMatrix, hjk] using congrArg (fun x : ℝ => (x : ℂ)) h
  have hpoint : ∀ i : RowSample m,
      (finiteComplexCStarMatrix (C i) * finiteComplexCStarMatrix (C i) :
        CStarMatrix (Fin n) (Fin n) ℂ) ≤
      (L - 1 : ℂ) • finiteComplexCStarMatrix (Y i) + 1 := by
    intro i
    let N : Fin n → Fin n → ℝ :=
      fun j k => (L - 1) * Y i j k + finiteIdMatrix j k
    have hLo : finiteLoewnerLe (finiteMatMul (C i) (C i)) N := by
      intro x
      have hsq := uniform_finiteMatMul_centered_rowOuterGramSample_self_eq U i
      have hYsq := uniform_finiteMatMul_rowOuterGramSample_self_eq U i
      change finiteQuadraticForm
        (finiteMatMul
          (fun j k => uniformRowOuterGramSample U i j k - finiteIdMatrix j k)
          (fun j k => uniformRowOuterGramSample U i j k - finiteIdMatrix j k)) x ≤ _
      rw [hsq, hYsq]
      change finiteQuadraticForm
        (fun j k => ((m : ℝ) * rowNormSq U i) * Y i j k - Y i j k - Y i j k +
          finiteIdMatrix j k) x ≤ finiteQuadraticForm N x
      dsimp [N]
      rw [finiteQuadraticForm_add, finiteQuadraticForm_sub, finiteQuadraticForm_sub,
        finiteQuadraticForm_smul, finiteQuadraticForm_finiteIdMatrix,
        finiteQuadraticForm_add, finiteQuadraticForm_smul,
        finiteQuadraticForm_finiteIdMatrix]
      have hpsd : 0 ≤ finiteQuadraticForm (Y i) x := finitePSD_uniformRowOuterGramSample U i x
      have hc := mul_le_mul_of_nonneg_right (hrow i) hpsd
      nlinarith
    have hsym : IsSymmetricFiniteMatrix N := by
      intro j k
      have h := uniformRowOuterGramSample_symmetric U i j k
      change uniformRowOuterGramSample U i j k = uniformRowOuterGramSample U i k j at h
      dsimp [N, Y]
      rw [h]
      by_cases hjk : j = k
      · subst k; rfl
      · simp [finiteIdMatrix, hjk, Ne.symm hjk]
    have h := finiteComplexCStarMatrix_le_of_finiteLoewnerLe
      (finiteMatMul (C i) (C i)) N
      (finiteMatMul_self_symmetric_of_symmetric _
        (uniformRowOuterGramSample_centered_symmetric U i)) hsym hLo
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

/-- Lower-tail adapter using the linear variance proxy. -/
theorem uniformRowOuterGramSample_neg_centered_log_cgf_le_scalar_of_forall_rowNorm_bound_linear_variance
    {m n : ℕ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m)
    {L theta : ℝ} (htheta : 0 ≤ theta)
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L) :
    let beta : ℝ := Real.exp theta - theta - 1
    CFC.log
        ((uniformRowSampleProbability hm).expectationCStarMatrix
          (fun i : RowSample m =>
            NormedSpace.exp
              (theta •
                (-finiteComplexCStarMatrix
                  (fun j k : Fin n =>
                    uniformRowOuterGramSample U i j k - finiteIdMatrix j k)) :
                CStarMatrix (Fin n) (Fin n) ℂ))) ≤
      ((beta * L : ℝ) : ℂ) •
        (1 : CStarMatrix (Fin n) (Fin n) ℂ) := by
  classical
  intro beta
  have hbase :=
    uniformRowOuterGramSample_neg_centered_log_cgf_le_of_forall_sample_le
      U hU hm htheta
  have hvar :=
    uniformRowOuterGramSample_centered_square_expectationCStarMatrix_le_linear_variance
      U hU hm hrow
  have hbeta_nonneg : 0 ≤ beta := by
    dsimp [beta]
    exact real_exp_sub_self_sub_one_nonneg theta
  have hscaled :
      beta •
        (uniformRowSampleProbability hm).expectationCStarMatrix
          (fun i : RowSample m =>
            (finiteComplexCStarMatrix
                (fun j k : Fin n =>
                  uniformRowOuterGramSample U i j k - finiteIdMatrix j k) *
              finiteComplexCStarMatrix
                (fun j k : Fin n =>
                  uniformRowOuterGramSample U i j k - finiteIdMatrix j k) :
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
theorem uniformRowTraceProbabilityFiniteRealTraceMGFLogBound_neg_centered_le_linear_variance
    {m n s : ℕ} {theta L : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m)
    (htheta : 0 ≤ theta)
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L) :
    let beta : ℝ := Real.exp theta - theta - 1
    uniformRowTraceProbabilityFiniteRealTraceMGFLogBound
      (steps := s) hm
      (fun _a _b : Fin n => 0)
      (fun i j k =>
        (-theta) * (uniformRowOuterGramSample U i j k - finiteIdMatrix j k)) ≤
      (n : ℝ) * Real.exp ((s : ℝ) * (beta * L)) := by
  classical
  intro beta
  let X : RowSample m → Fin n → Fin n → ℝ :=
    fun i j k => uniformRowOuterGramSample U i j k - finiteIdMatrix j k
  have hlog :
      CFC.log
          ((uniformRowSampleProbability hm).expectationCStarMatrix
            (fun i : RowSample m =>
              NormedSpace.exp
                (theta •
                  (-finiteComplexCStarMatrix (X i)) :
                  CStarMatrix (Fin n) (Fin n) ℂ))) ≤
        (((beta * L : ℝ) : ℂ) •
          (1 : CStarMatrix (Fin n) (Fin n) ℂ)) := by
    simpa [beta, X] using
      uniformRowOuterGramSample_neg_centered_log_cgf_le_scalar_of_forall_rowNorm_bound_linear_variance
        U hU hm htheta hrow
  have hK :
      CFC.log
          ((uniformRowSampleProbability hm).expectationCStarMatrix
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
    uniformRowTraceProbabilityFiniteRealTraceMGFLogBound_zero_le_card_mul_exp_of_log_le_real_smul_one
      (steps := s) hm
      (fun (i : RowSample m) (j k : Fin n) => (-theta) * X i j k)
      hK
  simpa [X, beta, Fintype.card_fin] using hbound


/-- Lower-tail adapter using the linear variance proxy. -/
theorem uniformRowTraceProbability_eventProb_uniformRowSampleGram_finiteLoewnerLe_lower_lt_ge_one_sub_exp_linear_variance
    {m n s : ℕ} {theta ε L : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m)
    (hs : 0 < (s : ℝ)) (htheta : 0 < theta)
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L) :
    let beta : ℝ := Real.exp theta - theta - 1
    1 -
      Real.exp (-(theta * (s : ℝ) * ε)) *
        ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L))) ≤
      (uniformRowTraceProbability (steps := s) hm).eventProb
        {samples |
          finiteLoewnerLe
            (fun j k : Fin n =>
              -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
            (fun j k : Fin n => ε * finiteIdMatrix j k)} := by
  classical
  intro beta
  let P := uniformRowTraceProbability (steps := s) hm
  let T : ℝ := theta * (s : ℝ) * ε
  let Xneg : RowSample m → Fin n → Fin n → ℝ :=
    fun i j k => (-theta) * (uniformRowOuterGramSample U i j k - finiteIdMatrix j k)
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
              uniformRowOuterGramSample_centered_symmetric U (samples t) j k
            change
              (-theta) *
                  (uniformRowOuterGramSample U (samples t) j k -
                    finiteIdMatrix j k) =
                (-theta) *
                  (uniformRowOuterGramSample U (samples t) k j -
                    finiteIdMatrix k j)
            simpa using congrArg (fun x => (-theta) * x) hsym)
          a < T}
  let GoodLoewner : Set (RowTrace m s) :=
    {samples |
      finiteLoewnerLe
        (fun j k : Fin n =>
          -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
        (fun j k : Fin n => ε * finiteIdMatrix j k)}
  have hMneg : ∀ samples, IsSymmetricFiniteMatrix (Mneg samples) := by
    intro samples j k
    dsimp [Mneg, Xneg]
    apply Finset.sum_congr rfl
    intro t _
    have hsym := uniformRowOuterGramSample_centered_symmetric U (samples t) j k
    change
      (-theta) *
          (uniformRowOuterGramSample U (samples t) j k -
            finiteIdMatrix j k) =
        (-theta) *
          (uniformRowOuterGramSample U (samples t) k j -
            finiteIdMatrix k j)
    simpa using congrArg (fun x => (-theta) * x) hsym
  have hzeroSym :
      IsSymmetricFiniteMatrix (fun _a _b : Fin n => 0) := by
    intro j k
    rfl
  have hXnegSym : ∀ i : RowSample m, IsSymmetricFiniteMatrix (Xneg i) := by
    intro i j k
    dsimp [Xneg]
    have hsym := uniformRowOuterGramSample_centered_symmetric U i j k
    change
      (-theta) * (uniformRowOuterGramSample U i j k - finiteIdMatrix j k) =
        (-theta) * (uniformRowOuterGramSample U i k j - finiteIdMatrix k j)
    simpa using congrArg (fun x => (-theta) * x) hsym
  have hTraceLog :
      P.expectationReal
          (fun samples => finiteTrace (finiteMatrixExp (Mneg samples))) ≤
        uniformRowTraceProbabilityFiniteRealTraceMGFLogBound
          (steps := s) hm
          (fun _a _b : Fin n => 0)
          Xneg := by
    have h :=
      uniformRowTraceProbability_expectationReal_finiteTrace_finiteMatrixExp_add_sum_le
        (steps := s) hm hzeroSym hXnegSym
    simpa [P, Mneg, Xneg, uniformRowTraceProbabilityFiniteRealTraceMGFLogBound]
      using h
  have hTraceScalar :
      P.expectationReal
          (fun samples => finiteTrace (finiteMatrixExp (Mneg samples))) ≤
        (n : ℝ) * Real.exp ((s : ℝ) * (beta * L)) := by
    exact hTraceLog.trans
      (by
        simpa [Xneg, beta] using
          uniformRowTraceProbabilityFiniteRealTraceMGFLogBound_neg_centered_le_linear_variance
            (s := s) U hU hm (le_of_lt htheta) hrow)
  have hEigProb :
      1 -
        Real.exp (-T) *
          ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L))) ≤
        P.eventProb GoodEig := by
    simpa [P, GoodEig, Mneg, T, beta] using
      FiniteProbability.eventProb_forall_finiteHermitianEigenvalue_lt_ge_one_sub_exp_neg_mul_trace_bound
        (P := P) (M := Mneg) hMneg T
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
      fun j k => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k)
    have hM_eq :
        Mneg samples = fun j k : Fin n => (theta * (s : ℝ)) * Eneg j k := by
      ext j k
      have hcenter :=
        uniformRowSampleGram_sub_finiteIdMatrix_eq_centered_average
          U hs samples j k
      have hs_ne : (s : ℝ) ≠ 0 := ne_of_gt hs
      dsimp [Mneg, Xneg, Eneg]
      calc
        ∑ t : Fin s,
            (-theta) *
              (uniformRowOuterGramSample U (samples t) j k - finiteIdMatrix j k)
            =
          (-theta) * ∑ t : Fin s,
            (uniformRowOuterGramSample U (samples t) j k - finiteIdMatrix j k) := by
            rw [Finset.mul_sum]
        _ =
          theta * (s : ℝ) *
            (-((∑ t : Fin s,
              (uniformRowOuterGramSample U (samples t) j k - finiteIdMatrix j k)) /
                (s : ℝ))) := by
            field_simp [hs_ne]
        _ = theta * (s : ℝ) *
            (-(uniformRowSampleGram U samples j k - finiteIdMatrix j k)) := by
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
  exact hEigProb.trans (FiniteProbability.eventProb_mono P hsubset)


/-- A quadratic Bernstein budget for the lower Gram tail. The variance is
`L` and the one-sided spectral radius is one. -/
theorem uniformRowTraceProbability_eventProb_uniformRowSampleGram_lower_ge_one_sub_of_linear_budget
    {m n s : ℕ} {L ε δ : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m) (hn : 0 < n)
    (hs : 0 < (s : ℝ)) (hL : 0 < L) (hε : 0 < ε) (hδ : 0 < δ)
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L)
    (hbudget : Real.log ((2 * (n : ℝ)) / δ) ≤
      (s : ℝ) * (ε ^ 2 / (2 * L + (2 / 3) * ε))) :
    1 - δ / 2 ≤
      (uniformRowTraceProbability (steps := s) hm).eventProb
        {samples | finiteLoewnerLe
          (fun j k : Fin n => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
          (fun j k : Fin n => ε * finiteIdMatrix j k)} := by
  let theta : ℝ := Real.log (1 + ε / L)
  have htheta : 0 < theta := by
    apply Real.log_pos
    have : 0 < ε / L := div_pos hε hL
    linarith
  have hprob :=
    uniformRowTraceProbability_eventProb_uniformRowSampleGram_finiteLoewnerLe_lower_lt_ge_one_sub_exp_linear_variance
      (s := s) (ε := ε) U hU hm hs htheta hrow
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
theorem uniformRowTraceProbability_eventProb_uniformRowSampleGram_lower_half_ge_one_sub_of_linear_budget
    {m n s : ℕ} {L δ : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m) (hn : 0 < n)
    (hs : 0 < (s : ℝ)) (hL : 1 ≤ L) (hδ : 0 < δ) (hδone : δ < 1)
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L)
    (hbudget : 10 * L * Real.log ((2 * (n : ℝ)) / δ) ≤ (s : ℝ)) :
    1 - δ / 2 ≤
      (uniformRowTraceProbability (steps := s) hm).eventProb
        {samples | finiteLoewnerLe
          (fun j k : Fin n => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
          (fun j k : Fin n => (1 / 2 : ℝ) * finiteIdMatrix j k)} := by
  have hLpos : 0 < L := lt_of_lt_of_le (by norm_num) hL
  apply uniformRowTraceProbability_eventProb_uniformRowSampleGram_lower_ge_one_sub_of_linear_budget
    U hU hm hn hs hLpos (by norm_num) hδ hrow
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

end NumStability
