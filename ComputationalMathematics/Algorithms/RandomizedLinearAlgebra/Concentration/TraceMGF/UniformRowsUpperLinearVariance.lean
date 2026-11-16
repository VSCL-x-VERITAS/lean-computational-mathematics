import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.TraceMGF.UniformRowsLinearVariance

/-!
# Upper and two-sided uniform Gram concentration with linear variance

The centered variance proxy is `L I`. The positive centered spectral radius is
at most `L`, giving a half-identity upper event under the same linear sample
budget as the lower event. Their intersection has total failure at most `δ`.
-/
namespace NumStability
open scoped BigOperators ComplexOrder

private theorem uniformRowOuterGramSample_le_cap {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (hm : 0 < m) {L : ℝ}
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L) (i : Fin m) :
    finiteLoewnerLe (uniformRowOuterGramSample U i)
      (fun j k : Fin d => L * finiteIdMatrix j k) := by
  have hmR : 0 < (m : ℝ) := by exact_mod_cast hm
  have hcap : rowNormSq U i ≤ L / (m : ℝ) :=
    (le_div_iff₀ hmR).mpr (by simpa [mul_comm] using hrow i)
  have h := uniformRowOuterGramSample_finiteLoewnerLe_of_rowNormSq_le U i hcap
  have heq : (m : ℝ) * (L / (m : ℝ)) = L := by field_simp
  simpa only [heq] using h

/-- Positive-centered log-CGF with the linear variance proxy. -/
theorem uniformRowOuterGramSample_centered_log_cgf_le_scalar_linear_variance
    {m d : ℕ} {L theta : ℝ} (U : Fin m → Fin d → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m)
    (hL : 0 < L) (htheta : 0 ≤ theta)
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L) :
    CFC.log
      ((uniformRowSampleProbability hm).expectationCStarMatrix
        (fun i => NormedSpace.exp
          (theta • finiteComplexCStarMatrix
            (fun j k : Fin d => uniformRowOuterGramSample U i j k - finiteIdMatrix j k) :
            CStarMatrix (Fin d) (Fin d) ℂ))) ≤
      ((((Real.exp (theta * L) - theta * L - 1) / L ^ 2 * L : ℝ) : ℂ) •
        (1 : CStarMatrix (Fin d) (Fin d) ℂ)) := by
  exact uniformRowOuterGramSample_centered_log_cgf_le_scalar_of_variance_proxy
    U hU hm hL htheta (uniformRowOuterGramSample_le_cap U hm hrow)
    (uniformRowOuterGramSample_centered_square_expectationCStarMatrix_le_linear_variance U hU hm hrow)

/-- Upper-tail adapter with the linear variance proxy. -/
theorem uniformRowTraceProbabilityFiniteRealTraceMGFLogBound_centered_le_linear_variance
    {m n s : ℕ} {theta L : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m)
    (hLpos : 0 < L) (htheta : 0 ≤ theta)
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L) :
    let beta : ℝ :=
      (Real.exp (theta * L) - theta * L - 1) / L ^ 2
    uniformRowTraceProbabilityFiniteRealTraceMGFLogBound
      (steps := s) hm
      (fun _a _b : Fin n => 0)
      (fun i j k =>
        theta * (uniformRowOuterGramSample U i j k - finiteIdMatrix j k)) ≤
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
                (theta • finiteComplexCStarMatrix (X i) :
                  CStarMatrix (Fin n) (Fin n) ℂ))) ≤
        (((beta * L : ℝ) : ℂ) •
          (1 : CStarMatrix (Fin n) (Fin n) ℂ)) := by
    simpa [beta, X] using
      uniformRowOuterGramSample_centered_log_cgf_le_scalar_linear_variance
        U hU hm hLpos htheta hrow
  have hK :
      CFC.log
          ((uniformRowSampleProbability hm).expectationCStarMatrix
            (fun i : RowSample m =>
              NormedSpace.exp
                (finiteComplexCStarMatrix
                  (fun j k : Fin n => theta * X i j k)))) ≤
        (((beta * L : ℝ) : ℂ) •
          (1 : CStarMatrix (Fin n) (Fin n) ℂ)) := by
    have hexp :
        (fun i : RowSample m =>
          NormedSpace.exp
            (finiteComplexCStarMatrix
              (fun j k : Fin n => theta * X i j k))) =
        (fun i : RowSample m =>
          NormedSpace.exp
            (theta • finiteComplexCStarMatrix (X i) :
              CStarMatrix (Fin n) (Fin n) ℂ)) := by
      funext i
      rw [finiteComplexCStarMatrix_smul]
      rfl
    rw [hexp]
    exact hlog
  have hbound :=
    uniformRowTraceProbabilityFiniteRealTraceMGFLogBound_zero_le_card_mul_exp_of_log_le_real_smul_one
      (steps := s) hm
      (fun (i : RowSample m) (j k : Fin n) => theta * X i j k)
      hK
  simpa [X, beta, Fintype.card_fin] using hbound


/-- Upper-tail adapter with the linear variance proxy. -/
theorem uniformRowTraceProbability_eventProb_uniformRowSampleGram_finiteLoewnerLe_upper_lt_ge_one_sub_exp_linear_variance
    {m n s : ℕ} {theta ε L : ℝ} (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m)
    (hs : 0 < (s : ℝ)) (htheta : 0 < theta) (hLpos : 0 < L)
    (hrow : ∀ i : RowSample m, (m : ℝ) * rowNormSq U i ≤ L) :
    let beta : ℝ :=
      (Real.exp (theta * L) - theta * L - 1) / L ^ 2
    1 -
      Real.exp (-(theta * (s : ℝ) * ε)) *
        ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L))) ≤
      (uniformRowTraceProbability (steps := s) hm).eventProb
        {samples |
          finiteLoewnerLe
            (fun j k : Fin n =>
              uniformRowSampleGram U samples j k - finiteIdMatrix j k)
            (fun j k : Fin n => ε * finiteIdMatrix j k)} := by
  classical
  intro beta
  let P := uniformRowTraceProbability (steps := s) hm
  let T : ℝ := theta * (s : ℝ) * ε
  let X : RowSample m → Fin n → Fin n → ℝ :=
    fun i j k => theta * (uniformRowOuterGramSample U i j k - finiteIdMatrix j k)
  let M : RowTrace m s → Fin n → Fin n → ℝ :=
    fun samples j k => ∑ t : Fin s, X (samples t) j k
  let GoodEig : Set (RowTrace m s) :=
    {samples |
      ∀ a : Fin n,
        finiteHermitianEigenvalues (M samples)
          (by
            intro j k
            dsimp [M, X]
            apply Finset.sum_congr rfl
            intro t _
            have hsym :=
              uniformRowOuterGramSample_centered_symmetric U (samples t) j k
            change
              theta *
                  (uniformRowOuterGramSample U (samples t) j k -
                    finiteIdMatrix j k) =
                theta *
                  (uniformRowOuterGramSample U (samples t) k j -
                    finiteIdMatrix k j)
            simpa using congrArg (fun x => theta * x) hsym)
          a < T}
  let GoodLoewner : Set (RowTrace m s) :=
    {samples |
      finiteLoewnerLe
        (fun j k : Fin n =>
          uniformRowSampleGram U samples j k - finiteIdMatrix j k)
        (fun j k : Fin n => ε * finiteIdMatrix j k)}
  have hM : ∀ samples, IsSymmetricFiniteMatrix (M samples) := by
    intro samples j k
    dsimp [M, X]
    apply Finset.sum_congr rfl
    intro t _
    have hsym := uniformRowOuterGramSample_centered_symmetric U (samples t) j k
    change
      theta *
          (uniformRowOuterGramSample U (samples t) j k -
            finiteIdMatrix j k) =
        theta *
          (uniformRowOuterGramSample U (samples t) k j -
            finiteIdMatrix k j)
    simpa using congrArg (fun x => theta * x) hsym
  have hzeroSym :
      IsSymmetricFiniteMatrix (fun _a _b : Fin n => 0) := by
    intro j k
    rfl
  have hXsym : ∀ i : RowSample m, IsSymmetricFiniteMatrix (X i) := by
    intro i j k
    dsimp [X]
    have hsym := uniformRowOuterGramSample_centered_symmetric U i j k
    change
      theta * (uniformRowOuterGramSample U i j k - finiteIdMatrix j k) =
        theta * (uniformRowOuterGramSample U i k j - finiteIdMatrix k j)
    simpa using congrArg (fun x => theta * x) hsym
  have hTraceLog :
      P.expectationReal
          (fun samples => finiteTrace (finiteMatrixExp (M samples))) ≤
        uniformRowTraceProbabilityFiniteRealTraceMGFLogBound
          (steps := s) hm
          (fun _a _b : Fin n => 0)
          X := by
    have h :=
      uniformRowTraceProbability_expectationReal_finiteTrace_finiteMatrixExp_add_sum_le
        (steps := s) hm hzeroSym hXsym
    simpa [P, M, X, uniformRowTraceProbabilityFiniteRealTraceMGFLogBound]
      using h
  have hTraceScalar :
      P.expectationReal
          (fun samples => finiteTrace (finiteMatrixExp (M samples))) ≤
        (n : ℝ) * Real.exp ((s : ℝ) * (beta * L)) := by
    exact hTraceLog.trans
      (by
        simpa [X, beta] using
          uniformRowTraceProbabilityFiniteRealTraceMGFLogBound_centered_le_linear_variance
            (s := s) U hU hm hLpos (le_of_lt htheta) hrow)
  have hEigProb :
      1 -
        Real.exp (-T) *
          ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L))) ≤
        P.eventProb GoodEig := by
    simpa [P, GoodEig, M, T, beta] using
      FiniteProbability.eventProb_forall_finiteHermitianEigenvalue_lt_ge_one_sub_exp_neg_mul_trace_bound
        (P := P) (M := M) hM T
        ((n : ℝ) * Real.exp ((s : ℝ) * (beta * L)))
        hTraceScalar
  have hsubset : GoodEig ⊆ GoodLoewner := by
    intro samples hsamples
    have hEig : ∀ a : Fin n, finiteHermitianEigenvalues (M samples) (hM samples) a ≤ T := by
      intro a
      exact le_of_lt (by simpa [GoodEig, M, T] using hsamples a)
    have hLoM :
        finiteLoewnerLe (M samples)
          (fun j k : Fin n => T * finiteIdMatrix j k) :=
      finiteLoewnerLe_smul_id_of_finiteHermitianEigenvalues_le
        (M samples) (hM samples) hEig
    let E : Fin n → Fin n → ℝ :=
      fun j k => uniformRowSampleGram U samples j k - finiteIdMatrix j k
    have hM_eq :
        M samples = fun j k : Fin n => (theta * (s : ℝ)) * E j k := by
      ext j k
      have hcenter :=
        uniformRowSampleGram_sub_finiteIdMatrix_eq_centered_average
          U hs samples j k
      have hs_ne : (s : ℝ) ≠ 0 := ne_of_gt hs
      dsimp [M, X, E]
      calc
        ∑ t : Fin s,
            theta *
              (uniformRowOuterGramSample U (samples t) j k - finiteIdMatrix j k)
            =
          theta * ∑ t : Fin s,
            (uniformRowOuterGramSample U (samples t) j k - finiteIdMatrix j k) := by
            rw [Finset.mul_sum]
        _ =
          theta * (s : ℝ) *
            ((∑ t : Fin s,
              (uniformRowOuterGramSample U (samples t) j k - finiteIdMatrix j k)) /
                (s : ℝ)) := by
            field_simp [hs_ne]
        _ = theta * (s : ℝ) *
            (uniformRowSampleGram U samples j k - finiteIdMatrix j k) := by
            rw [← hcenter]
    have hscaled :
        finiteLoewnerLe
          (fun j k : Fin n => (theta * (s : ℝ)) * E j k)
          (fun j k : Fin n => T * finiteIdMatrix j k) := by
      simpa [hM_eq] using hLoM
    have htheta_s : 0 < theta * (s : ℝ) := mul_pos htheta hs
    have hunscaled :=
      finiteLoewnerLe_of_smul_left_le_smul_id E htheta_s hscaled
    have hTdiv : T / (theta * (s : ℝ)) = ε := by
      dsimp [T]
      field_simp [(ne_of_gt htheta_s)]
    have hGood : GoodLoewner samples := by
      simpa [GoodLoewner, E, hTdiv] using hunscaled
    exact hGood
  exact hEigProb.trans (FiniteProbability.eventProb_mono P hsubset)


/-- A Bernstein budget with linear variance and positive spectral radius `L`
controls the upper Gram error. -/
theorem uniformRowTraceProbability_eventProb_uniformRowSampleGram_upper_ge_one_sub_of_linear_budget
    {m d s : ℕ} {L ε δ : ℝ} (U : Fin m → Fin d → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m) (hd : 0 < d)
    (hs : 0 < (s : ℝ)) (hL : 0 < L) (hε : 0 < ε) (hδ : 0 < δ)
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L)
    (hbudget : Real.log ((2 * (d : ℝ)) / δ) ≤
      (s : ℝ) * (ε ^ 2 / (2 * L + (2 / 3) * L * ε))) :
    1 - δ / 2 ≤ (uniformRowTraceProbability (steps := s) hm).eventProb
      {samples | finiteLoewnerLe
        (fun j k : Fin d => uniformRowSampleGram U samples j k - finiteIdMatrix j k)
        (fun j k : Fin d => ε * finiteIdMatrix j k)} := by
  let theta : ℝ := Real.log (1 + L * ε / L) / L
  have htheta : 0 < theta := by
    apply div_pos _ hL
    apply Real.log_pos
    have : 0 < L * ε / L := by positivity
    linarith
  have hprob :=
    uniformRowTraceProbability_eventProb_uniformRowSampleGram_finiteLoewnerLe_upper_lt_ge_one_sub_exp_linear_variance
      (s := s) (ε := ε) U hU hm hs htheta hL hrow
  have hB : 0 < (d : ℝ) := by exact_mod_cast hd
  have htail := real_bernstein_tail_le_half_delta_of_quadratic_budget
    (B := (d : ℝ)) (W := L) (L := L) (r := ε) (s := (s : ℝ)) (δ := δ)
    hB hL hL hε hs hδ hbudget
  have htail' : Real.exp (-(theta * (s : ℝ) * ε)) *
      ((d : ℝ) * Real.exp ((s : ℝ) *
        (((Real.exp (theta * L) - theta * L - 1) / L ^ 2) * L))) ≤ δ / 2 := by
    simpa [theta] using htail
  exact (sub_le_sub_left htail' 1).trans hprob

/-- The upper half-identity event holds under a sample count linear in `L`. -/
theorem uniformRowTraceProbability_eventProb_uniformRowSampleGram_upper_half_ge_one_sub_of_linear_budget
    {m d s : ℕ} {L δ : ℝ} (U : Fin m → Fin d → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m) (hd : 0 < d)
    (hs : 0 < (s : ℝ)) (hL : 1 ≤ L) (hδ : 0 < δ) (hδone : δ < 1)
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L)
    (hbudget : 10 * L * Real.log ((2 * (d : ℝ)) / δ) ≤ (s : ℝ)) :
    1 - δ / 2 ≤ (uniformRowTraceProbability (steps := s) hm).eventProb
      {samples | finiteLoewnerLe
        (fun j k : Fin d => uniformRowSampleGram U samples j k - finiteIdMatrix j k)
        (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)} := by
  have hLpos : 0 < L := lt_of_lt_of_le (by norm_num) hL
  apply uniformRowTraceProbability_eventProb_uniformRowSampleGram_upper_ge_one_sub_of_linear_budget
    U hU hm hd hs hLpos (by norm_num) hδ hrow
  have hdreal : 1 ≤ (d : ℝ) := by exact_mod_cast hd
  have harg : 1 ≤ (2 * (d : ℝ)) / δ := by
    rw [le_div_iff₀ hδ]
    nlinarith
  have hlog : 0 ≤ Real.log ((2 * (d : ℝ)) / δ) := Real.log_nonneg harg
  have hden : 0 < 2 * L + (2 / 3 : ℝ) * L * (1 / 2) := by positivity
  have hmain : Real.log ((2 * (d : ℝ)) / δ) *
      (2 * L + (2 / 3 : ℝ) * L * (1 / 2)) ≤ (s : ℝ) * (1 / 2 : ℝ) ^ 2 := by
    have hcoef : 2 * L + (2 / 3 : ℝ) * L * (1 / 2) ≤ (10 * L) / 4 := by linarith
    have hmul := mul_le_mul_of_nonneg_left hcoef hlog
    nlinarith
  simpa only [mul_div_assoc] using (le_div_iff₀ hden).mpr hmain

/-- A two-sided half-identity Gram event under the same linear sample budget.
Each one-sided failure receives half of `δ`. -/
theorem uniformRowTraceProbability_eventProb_uniformRowSampleGram_two_sided_half_ge_one_sub_of_linear_budget
    {m d s : ℕ} {L δ : ℝ} (U : Fin m → Fin d → ℝ)
    (hU : HasOrthonormalColumns U) (hm : 0 < m) (hd : 0 < d)
    (hs : 0 < (s : ℝ)) (hL : 1 ≤ L) (hδ : 0 < δ) (hδone : δ < 1)
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L)
    (hbudget : 10 * L * Real.log ((2 * (d : ℝ)) / δ) ≤ (s : ℝ)) :
    1 - δ ≤ (uniformRowTraceProbability (steps := s) hm).eventProb
      {samples | finiteLoewnerLe
        (fun j k : Fin d => uniformRowSampleGram U samples j k - finiteIdMatrix j k)
        (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k) ∧
        finiteLoewnerLe
          (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
          (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)} := by
  have hupper :=
    uniformRowTraceProbability_eventProb_uniformRowSampleGram_upper_half_ge_one_sub_of_linear_budget
      U hU hm hd hs hL hδ hδone hrow hbudget
  have hlower :=
    uniformRowTraceProbability_eventProb_uniformRowSampleGram_lower_half_ge_one_sub_of_linear_budget
      U hU hm hd hs hL hδ hδone hrow hbudget
  have hboth := FiniteProbability.eventProb_inter_ge_one_sub_add
    (uniformRowTraceProbability (steps := s) hm) _ _ (δ / 2) (δ / 2) hupper hlower
  simpa using hboth

end NumStability
