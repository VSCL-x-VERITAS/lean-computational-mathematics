import ComputationalMathematics.HDP.Matrix.GramExpectation
import ComputationalMathematics.HDP.Matrix.OperatorNormLowerExpectation
import ComputationalMathematics.HDP.Vector.SingularWhitening

/-!
# Quantitative covariance estimation

The normalized Gram estimate for isotropic rows transfers through a (possibly
singular) covariance square root to the corresponding sample second-moment
matrix.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.Covariance

/-- The Euclidean operator norm of `B Bᵀ` is the square of the norm of `B`.
This is the finite-real-matrix form of the C*-identity. -/
theorem realMatrixOperatorNorm_mul_transpose_self {m n : ℕ}
    (B : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.realMatrixOperatorNorm (B * B.transpose) =
      NumStability.realMatrixOperatorNorm B ^ 2 := by
  let T := NumStability.realMatrixContinuousLinearMap B
  have hadj : NumStability.realMatrixContinuousLinearMap B.transpose = T.adjoint := by
    dsimp [T]
    apply ContinuousLinearMap.ext
    intro x
    change Matrix.toEuclideanLin B.transpose x =
      (Matrix.toEuclideanLin B).adjoint x
    rw [show Matrix.toEuclideanLin B.transpose =
        (Matrix.toEuclideanLin B).adjoint by
      simpa using Matrix.toEuclideanLin_conjTranspose_eq_adjoint B]
  have hmul :
      NumStability.realMatrixContinuousLinearMap (B * B.transpose) =
        T.comp (NumStability.realMatrixContinuousLinearMap B.transpose) := by
    dsimp [T]
    apply ContinuousLinearMap.ext
    intro x
    change Matrix.toEuclideanLin (B * B.transpose) x =
      Matrix.toEuclideanLin B (Matrix.toEuclideanLin B.transpose x)
    rw [Matrix.toLpLin_apply, Matrix.toLpLin_apply,
      Matrix.toLpLin_apply, Matrix.mulVec_mulVec]
  have hCstar := ContinuousLinearMap.norm_adjoint_comp_self T.adjoint
  unfold NumStability.realMatrixOperatorNorm
  rw [hmul, hadj]
  simpa [T, pow_two] using hCstar

/-- Mapping a normalized Gram error through a covariance square root costs
exactly one factor of the population covariance norm. -/
theorem sampleCovariance_error_norm_le_covariance_mul_gram
    {n : ℕ} (B R Sigma SigmaM : Matrix (Fin n) (Fin n) ℝ)
    (hSigma : Sigma = B * B.transpose)
    (hSigmaM : SigmaM = B * (1 + R) * B.transpose) :
    NumStability.realMatrixOperatorNorm (SigmaM - Sigma) ≤
      NumStability.realMatrixOperatorNorm Sigma *
        NumStability.realMatrixOperatorNorm R := by
  have hraw := singularWhitening_error_norm_le
    B R Sigma SigmaM hSigma hSigmaM
  change NumStability.realMatrixOperatorNorm (SigmaM - Sigma) ≤
    NumStability.realMatrixOperatorNorm B *
      NumStability.realMatrixOperatorNorm R *
      NumStability.realMatrixOperatorNorm B.transpose at hraw
  rw [NumStability.HDP.Matrix.realMatrixOperatorNorm_transpose] at hraw
  rw [hSigma] at hraw
  rw [hSigma, realMatrixOperatorNorm_mul_transpose_self]
  dsimp [NumStability.realMatrixOperatorNorm] at hraw ⊢
  nlinarith [norm_nonneg (NumStability.realMatrixContinuousLinearMap B),
    norm_nonneg (NumStability.realMatrixContinuousLinearMap R)]

/-- Expected covariance-estimation error obtained by applying the isotropic
normalized-Gram theorem after whitening.  The factor `B` may be singular. -/
theorem exists_expected_sampleCovariance_error_bound_of_whitened_rows :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ)
          (B Sigma : Matrix (Fin n) (Fin n) ℝ)
          (SigmaM : Ω → Matrix (Fin n) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω ↦ A ω i j)) →
        (∀ i j, MemLp (fun ω ↦ A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω ↦ A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω ↦ fun j ↦ A ω i j) μ →
        Sigma = B * B.transpose →
        (∀ ω, SigmaM ω = B *
          ((m : ℝ)⁻¹ • ((A ω).transpose * A ω)) * B.transpose) →
        Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm
          (((m : ℝ)⁻¹ • ((A ω).transpose * A ω)) - 1)) μ →
        Integrable (fun ω ↦
          NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma)) μ →
        (∫ ω, NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma) ∂μ) ≤
          C * K ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            NumStability.realMatrixOperatorNorm Sigma := by
  rcases
      NumStability.HDP.Matrix.exists_expected_normalizedGramDeviation_bound_of_independent_isotropic_subGaussian_rows with
    ⟨C, hC, hGram⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ m n hm hn A B Sigma SigmaM K hK hMeas hLp hIso hPsi hIndep
    hSigma hSigmaM hGramInt hErrorInt
  let R : Ω → Matrix (Fin n) (Fin n) ℝ := fun ω ↦
    ((m : ℝ)⁻¹ • ((A ω).transpose * A ω)) - 1
  have hpoint : ∀ ω,
      NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma) ≤
        NumStability.realMatrixOperatorNorm Sigma *
          NumStability.realMatrixOperatorNorm (R ω) := by
    intro ω
    apply sampleCovariance_error_norm_le_covariance_mul_gram B (R ω) Sigma (SigmaM ω)
    · exact hSigma
    · rw [hSigmaM ω]
      dsimp [R]
      rw [add_sub_cancel]
  have hRInt : Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm (R ω)) μ := by
    simpa [R] using hGramInt
  have hdomInt : Integrable (fun ω ↦
      NumStability.realMatrixOperatorNorm Sigma *
        NumStability.realMatrixOperatorNorm (R ω)) μ :=
    hRInt.const_mul _
  have hint :
      (∫ ω, NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma) ∂μ) ≤
        ∫ ω, NumStability.realMatrixOperatorNorm Sigma *
          NumStability.realMatrixOperatorNorm (R ω) ∂μ :=
    integral_mono hErrorInt hdomInt hpoint
  have hgram := hGram hm hn A hK hMeas hLp hIso hPsi hIndep hGramInt
  rw [integral_const_mul] at hint
  calc
    (∫ ω, NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma) ∂μ) ≤
        NumStability.realMatrixOperatorNorm Sigma *
          ∫ ω, NumStability.realMatrixOperatorNorm (R ω) ∂μ := hint
    _ ≤ NumStability.realMatrixOperatorNorm Sigma *
        (C * K ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ))) := by
      apply mul_le_mul_of_nonneg_left _ (by
        exact norm_nonneg (NumStability.realMatrixContinuousLinearMap Sigma))
      simpa only [R] using hgram
    _ = C * K ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma := by ring

/-- High-probability covariance-estimation bound in the source's `n+u`
form, transferred from the normalized-Gram tail through the covariance square
root. -/
theorem exists_sampleCovariance_error_tail_of_whitened_rows :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ)
          (B Sigma : Matrix (Fin n) (Fin n) ℝ)
          (SigmaM : Ω → Matrix (Fin n) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω ↦ A ω i j)) →
        (∀ i j, MemLp (fun ω ↦ A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω ↦ A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω ↦ fun j ↦ A ω i j) μ →
        Sigma = B * B.transpose →
        (∀ ω, SigmaM ω = B *
          ((m : ℝ)⁻¹ • ((A ω).transpose * A ω)) * B.transpose) →
        ∀ {u : ℝ}, 0 ≤ u →
        μ.real {ω |
          D * K ^ 2 *
              (Real.sqrt (((n : ℝ) + u) / (m : ℝ)) +
                ((n : ℝ) + u) / (m : ℝ)) *
              NumStability.realMatrixOperatorNorm Sigma <
            NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma)} ≤
          2 * Real.exp (-u) := by
  rcases
      NumStability.HDP.Matrix.exists_normalizedGramDeviation_tail_of_independent_isotropic_subGaussian_rows with
    ⟨C, hC, htail⟩
  let D : ℝ := 2 * (C + C ^ 2)
  have hD : 0 < D := by dsimp [D]; nlinarith [sq_nonneg C]
  refine ⟨D, hD, ?_⟩
  intro Ω _ μ _ m n hm hn A B Sigma SigmaM K hK hMeas hLp hIso hPsi hIndep
    hSigma hSigmaM u hu
  let t : ℝ := Real.sqrt u
  let a : ℝ := Real.sqrt ((n : ℝ) / (m : ℝ))
  let b : ℝ := t / Real.sqrt (m : ℝ)
  let q : ℝ := ((n : ℝ) + u) / (m : ℝ)
  let s : ℝ := Real.sqrt q
  let δ : ℝ := C * (a + b)
  have hmR : (0 : ℝ) < m := by exact_mod_cast hm
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have ht0 : 0 ≤ t := by dsimp [t]; positivity
  have ht_sq : t ^ 2 = u := by dsimp [t]; exact Real.sq_sqrt hu
  have ha0 : 0 ≤ a := by dsimp [a]; positivity
  have hb0 : 0 ≤ b := by dsimp [b]; positivity
  have hq0 : 0 ≤ q := by dsimp [q]; positivity
  have hs0 : 0 ≤ s := by dsimp [s]; positivity
  have hs_sq : s ^ 2 = q := by dsimp [s]; exact Real.sq_sqrt hq0
  have ha_sq : a ^ 2 = (n : ℝ) / (m : ℝ) := by
    dsimp [a]
    exact Real.sq_sqrt (div_nonneg hnR.le hmR.le)
  have hb_sq : b ^ 2 = u / (m : ℝ) := by
    dsimp [b]
    rw [div_pow, ht_sq, Real.sq_sqrt hmR.le]
  have hq : q = a ^ 2 + b ^ 2 := by
    dsimp [q]
    rw [ha_sq, hb_sq]
    ring
  have hab_sq : (a + b) ^ 2 ≤ 2 * q := by
    rw [hq]
    nlinarith [sq_nonneg (a - b)]
  have hab_le : a + b ≤ 2 * s := by
    nlinarith [hs_sq, hab_sq]
  have hδ0 : 0 ≤ δ := by dsimp [δ]; positivity
  have hδlin : δ ≤ 2 * C * s := by
    dsimp [δ]
    nlinarith
  have hδsq : δ ^ 2 ≤ 2 * C ^ 2 * q := by
    have hmul := mul_le_mul_of_nonneg_left hab_sq (sq_nonneg C)
    dsimp [δ]
    nlinarith
  have hscale : max δ (δ ^ 2) ≤ D * (s + q) := by
    have hmax : max δ (δ ^ 2) ≤ δ + δ ^ 2 := by
      rw [max_le_iff]
      exact ⟨le_add_of_nonneg_right (sq_nonneg δ),
        le_add_of_nonneg_left hδ0⟩
    dsimp [D]
    nlinarith [hmax, hδlin, hδsq, mul_nonneg hC.le hs0,
      mul_nonneg (sq_nonneg C) hq0]
  have hsource := htail hm hn A hK hMeas hLp hIso hPsi hIndep ht0
  have hsubset :
      {ω |
        D * K ^ 2 * (s + q) *
              NumStability.realMatrixOperatorNorm Sigma <
            NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma)} ⊆
      {ω |
        K ^ 2 * max δ (δ ^ 2) <
          NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹ • ((A ω).transpose * A ω)) - 1)} := by
    intro ω hbad
    let R : Matrix (Fin n) (Fin n) ℝ :=
      ((m : ℝ)⁻¹ • ((A ω).transpose * A ω)) - 1
    have hpoint : NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma) ≤
        NumStability.realMatrixOperatorNorm Sigma *
          NumStability.realMatrixOperatorNorm R := by
      apply sampleCovariance_error_norm_le_covariance_mul_gram B R Sigma (SigmaM ω)
      · exact hSigma
      · rw [hSigmaM ω]
        dsimp [R]
        rw [add_sub_cancel]
    have hthreshold :
        NumStability.realMatrixOperatorNorm Sigma *
            (K ^ 2 * max δ (δ ^ 2)) ≤
          D * K ^ 2 * (s + q) *
            NumStability.realMatrixOperatorNorm Sigma := by
      have hKsq : 0 ≤ K ^ 2 := sq_nonneg K
      have hSig : 0 ≤ NumStability.realMatrixOperatorNorm Sigma := by
        exact norm_nonneg _
      nlinarith [mul_le_mul_of_nonneg_left hscale hKsq]
    have hmul :
        NumStability.realMatrixOperatorNorm Sigma *
            (K ^ 2 * max δ (δ ^ 2)) <
          NumStability.realMatrixOperatorNorm Sigma *
            NumStability.realMatrixOperatorNorm R :=
      hthreshold.trans_lt (hbad.trans_le hpoint)
    have hSigPos : 0 < NumStability.realMatrixOperatorNorm Sigma := by
      by_contra hz
      have : NumStability.realMatrixOperatorNorm Sigma = 0 :=
        le_antisymm (le_of_not_gt hz) (norm_nonneg _)
      simp [this] at hmul
    exact lt_of_mul_lt_mul_left hmul hSigPos.le
  have hmono := measureReal_mono hsubset (by
    exact ne_top_of_le_ne_top
      (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
      (measure_mono (Set.subset_univ _)))
  refine hmono.trans ?_
  simpa [δ, a, b, t, ht_sq, s, q] using hsource

end NumStability.HDP.Vector.Covariance
