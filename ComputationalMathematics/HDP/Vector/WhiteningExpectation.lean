import ComputationalMathematics.HDP.Matrix.GramExpectation
import ComputationalMathematics.HDP.Vector.EffectiveRangeWhitening
import ComputationalMathematics.HDP.Vector.GeneralCovarianceEstimation

/-!
# Ordinary expectations under effective-range whitening

Finite second moments and identical sample laws derive the actual error expectation transfer.
-/

noncomputable section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix
open scoped ENNReal NNReal BigOperators

namespace NumStability.HDP.Vector.Whitening

/-- Finite coordinate second moments give a finite ordinary expectation of
the actual normalized empirical Gram error, including zero rank. -/
theorem integrable_normalizedGram_error_of_coordinate_memLp
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsFiniteMeasure μ]
    {m r : ℕ} (Zsample : Fin m → Ω → Fin r → ℝ)
    (hLp : ∀ i j, MemLp (fun ω ↦ Zsample i ω j) 2 μ) :
    let A : Ω → Matrix (Fin m) (Fin r) ℝ := fun ω i ↦ Zsample i ω
    Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm
      ((m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1)) μ := by
  dsimp only
  apply NumStability.HDP.Matrix.integrable_realMatrixOperatorNorm_of_entries (m := r) (n := r)
  intro ij
  have hsum : Integrable (fun ω ↦ ∑ i, Zsample i ω ij.1 * Zsample i ω ij.2) μ :=
    integrable_finset_sum _ (fun i _ ↦ (hLp i ij.1).integrable_mul (hLp i ij.2))
  simpa only [Matrix.sub_apply, Matrix.smul_apply, Matrix.mul_apply,
    Matrix.transpose_apply, smul_eq_mul] using
    (hsum.const_mul (m : ℝ)⁻¹).sub
      (integrable_const ((1 : Matrix (Fin r) (Fin r) ℝ) ij.1 ij.2))

/-- The rectangular factor transfers an ordinary empirical Gram expectation
to the actual sample error. Both integrability facts are derived from the
population's finite moments and the identical sample laws. -/
theorem actual_rectangular_expectation_transfer
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsFiniteMeasure μ]
    {m n r : ℕ} (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ)
    (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ)
    (hLp : ∀ j, MemLp (fun ω ↦ X ω j) 2 μ)
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (hSigma : NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j) = B * B.transpose)
    (hLeft : P * B = 1) :
    let Sigma := NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j)
    let A : Ω → Matrix (Fin m) (Fin r) ℝ := fun ω i ↦ P.mulVec (Xsample i ω)
    let Rm := fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
    Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)) μ ∧
      Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm (Rm ω)) μ ∧
      (∫ ω, NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω - Sigma) ∂μ) ≤
        (∫ ω, NumStability.realMatrixOperatorNorm (Rm ω) ∂μ) *
          NumStability.realMatrixOperatorNorm Sigma := by
  dsimp only
  let Sigma := NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
    (fun j ω ↦ X ω j)
  let Zsample : Fin m → Ω → Fin r → ℝ := fun i ω ↦ P.mulVec (Xsample i ω)
  let A : Ω → Matrix (Fin m) (Fin r) ℝ := fun ω i ↦ Zsample i ω
  let Rm := fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
  have hSampleLp : ∀ i j, MemLp (fun ω ↦ Xsample i ω j) 2 μ := by
    intro i j
    exact ((hLaw i).comp (measurable_pi_apply j)).symm.memLp_snd (hLp j)
  have hZLp : ∀ i j, MemLp (fun ω ↦ Zsample i ω j) 2 μ := by
    intro i j
    exact NumStability.HDP.Vector.Whitening.memLp_mulVec
      P (fun j ω ↦ Xsample i ω j) (hSampleLp i) j
  have hError := NumStability.HDP.Vector.Covariance.integrable_sampleCovariance_error_of_iid
    X Xsample hLp hLaw
  have hGram : Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm (Rm ω)) μ :=
    integrable_normalizedGram_error_of_coordinate_memLp Zsample hZLp
  have hEach : ∀ i, Xsample i =ᵐ[μ] fun ω ↦ B.mulVec (Zsample i ω) := fun i ↦
    NumStability.HDP.Vector.Whitening.reconstruction_of_identDistrib
      B P X (Xsample i) hLp hSigma hLeft (hLaw i)
  have hAll : ∀ᵐ ω ∂μ, ∀ i, Xsample i ω = B.mulVec (Zsample i ω) :=
    ae_all_iff.mpr hEach
  have hPoint : ∀ᵐ ω ∂μ,
      NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω - Sigma) ≤
      NumStability.realMatrixOperatorNorm Sigma * NumStability.realMatrixOperatorNorm (Rm ω) := by
    filter_upwards [hAll] with ω hω
    have h := (NumStability.HDP.Vector.Whitening.actual_rectangular_sample_error_of_rows
      B Sigma (fun i ↦ Xsample i ω) (A ω) hSigma hω).2
    simpa only [mul_comm] using h
  have hIntegral := integral_mono_ae hError
    (hGram.const_mul (NumStability.realMatrixOperatorNorm Sigma)) hPoint
  rw [integral_const_mul] at hIntegral
  exact ⟨hError, hGram, by simpa only [mul_comm] using hIntegral⟩


/-- The existing uniform Gram expectation estimate applies to actual
whitened samples. Isotropy, norm bounds and independence are transported,
and integrability is derived. This statement requires positive effective
rank and is a reusable foundation, not a numbered-source wrapper. -/
theorem exists_actual_whitened_gram_expectation_bound :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n r : ℕ},
        0 < m → 0 < r →
        ∀ (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ)
          (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ)
          (K : ℝ≥0),
        0 < K →
        NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j) →
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
          (fun j ω ↦ X ω j) K →
        NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
          (fun j ω ↦ X ω j) = B * B.transpose →
        P * B = 1 →
        (∀ i j, Measurable (fun ω ↦ Xsample i ω j)) →
        (∀ i, IdentDistrib (Xsample i) X μ μ) →
        iIndepFun Xsample μ →
        let A : Ω → Matrix (Fin m) (Fin r) ℝ :=
          fun ω i ↦ P.mulVec (Xsample i ω)
        let Rm := fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
        Integrable (fun ω ↦ NumStability.realMatrixOperatorNorm (Rm ω)) μ ∧
          (∫ ω, NumStability.realMatrixOperatorNorm (Rm ω) ∂μ) ≤
            C * (K : ℝ) ^ 2 *
              (Real.sqrt ((r : ℝ) / (m : ℝ)) + (r : ℝ) / (m : ℝ)) := by
  obtain ⟨C, hC, hGram⟩ :=
    NumStability.HDP.Matrix.exists_expected_normalizedGramDeviation_bound_of_independent_isotropic_subGaussian_rows
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ m n r hm hr X Xsample B P K hK hSG hRelative hSigma hLeft
    hSampleMeas hLaw hIndep
  let Z : Ω → Fin r → ℝ := fun ω ↦ P.mulVec (X ω)
  let Zsample : Fin m → Ω → Fin r → ℝ := fun i ω ↦ P.mulVec (Xsample i ω)
  let A : Ω → Matrix (Fin m) (Fin r) ℝ := fun ω i ↦ Zsample i ω
  have hLp := NumStability.HDP.Vector.Whitening.coordinate_memLp_of_subGaussian hSG
  have hMeas : ∀ j, Measurable (fun ω ↦ X ω j) := fun j ↦
    (NumStability.HDP.Vector.Whitening.coordinate_isSubGaussian hSG j).1
  obtain ⟨hIso, _, _, _, hZLaw, hZIndep, hZNorm, _, _⟩ :=
    NumStability.HDP.Vector.Whitening.actual_rectangular_whitening
      B P X Xsample K hLp hSigma hLeft hSG hRelative hMeas hSampleMeas hLaw hIndep
  have hZLp : ∀ j, MemLp (fun ω ↦ Z ω j) 2 μ :=
    NumStability.HDP.Vector.Whitening.memLp_mulVec P (fun j ω ↦ X ω j) hLp
  have hSampleLp : ∀ i j, MemLp (fun ω ↦ Zsample i ω j) 2 μ := by
    intro i j
    exact ((hZLaw i).comp (measurable_pi_apply j)).symm.memLp_snd (hZLp j)
  have hSampleIso : ∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
      (fun j ω ↦ Zsample i ω j) := by
    intro i
    change NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ Zsample i ω j) = 1
    have hMoments : NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
        (fun j ω ↦ Zsample i ω j) =
        NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
          (fun j ω ↦ Z ω j) := by
      ext j k
      have hprod := (hZLaw i).comp
        ((measurable_pi_apply j).mul (measurable_pi_apply k))
      simpa only [NumStability.HDP.Vector.Covariance.secondMomentMatrix,
        Function.comp_def] using hprod.integral_eq
    exact hMoments.trans hIso
  have hAMeas : ∀ i j, Measurable (fun ω ↦ A ω i j) := by
    intro i j
    exact (measurable_pi_apply j).comp
      ((NumStability.HDP.Vector.Whitening.measurable_mulVec P).comp
        (measurable_pi_iff.mpr (hSampleMeas i)))
  have hPsi : ∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
      (fun j ω ↦ A ω i j) ≤ ENNReal.ofReal (K : ℝ) := by
    intro i
    simpa only [ENNReal.ofReal_coe_nnreal] using hZNorm i
  have hInt := NumStability.HDP.Vector.Whitening.integrable_normalizedGram_error_of_coordinate_memLp
    Zsample hSampleLp
  have hKReal : 0 < (K : ℝ) := by exact_mod_cast hK
  exact ⟨hInt, hGram hm hr A hKReal hAMeas hSampleLp hSampleIso hPsi hZIndep hInt⟩


/-- A zero raw second moment gives zero actual sample-error expectation in
any ambient dimension. The existing rectangular expectation transfer applies
at effective rank zero; no centering or independence assumption is needed. -/
theorem actual_error_ae_and_expectation_zero_of_secondMoment_zero
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsFiniteMeasure μ]
    {m n : ℕ} (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ)
    (hLp : ∀ j, MemLp (fun ω ↦ X ω j) 2 μ)
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (hZero : NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j) = 0) :
    let Sigma := NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j)
    let Error := fun ω ↦ NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)
    Integrable Error μ ∧ Error =ᵐ[μ] 0 ∧ (∫ ω, Error ω ∂μ) = 0 := by
  dsimp only
  let B : Matrix (Fin n) (Fin 0) ℝ := 0
  let P : Matrix (Fin 0) (Fin n) ℝ := 0
  have hFactor : NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j) = B * B.transpose := by
    simpa only [B, Matrix.zero_mul] using hZero
  have hLeft : P * B = (1 : Matrix (Fin 0) (Fin 0) ℝ) :=
    Subsingleton.elim _ _
  obtain ⟨hInt, _hGramInt, hTransfer⟩ :=
    NumStability.HDP.Vector.Whitening.actual_rectangular_expectation_transfer
      X Xsample B P hLp hLaw hFactor hLeft
  have hNormZero (A : Matrix (Fin 0) (Fin 0) ℝ) :
      NumStability.realMatrixOperatorNorm A = 0 :=
    ContinuousLinearMap.opNorm_subsingleton _
  have hUpper : (∫ ω, NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω -
        NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
          (fun j ω ↦ X ω j)) ∂μ) ≤ 0 := by
    simpa only [hNormZero, integral_zero, zero_mul] using hTransfer
  have hIntegral : (∫ ω, NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω -
        NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
          (fun j ω ↦ X ω j)) ∂μ) = 0 :=
    le_antisymm hUpper (integral_nonneg (fun ω ↦ norm_nonneg _))
  exact ⟨hInt,
    (integral_eq_zero_iff_of_nonneg (fun ω ↦ norm_nonneg _) hInt).1 hIntegral,
    hIntegral⟩


end NumStability.HDP.Vector.Whitening
