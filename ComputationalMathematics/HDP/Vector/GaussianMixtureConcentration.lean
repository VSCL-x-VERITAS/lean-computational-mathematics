import ComputationalMathematics.HDP.Vector.GaussianMixtureCanonical
import ComputationalMathematics.HDP.Vector.GaussianMixtureClustering
import ComputationalMathematics.HDP.Vector.StandardGaussianSubGaussian
import ComputationalMathematics.HDP.Vector.BernoulliSubGaussian
import ComputationalMathematics.HDP.Vector.GeneralCovarianceEstimation

/-!
# Concentration foundations for the symmetric Gaussian mixture

This file derives the moment and sub-Gaussian inputs needed to apply the
general covariance-estimation theorem to the canonical latent sample.  The
sample law retains the latent Rademacher signs, but its observed rows have the
same law as the source's symmetric Gaussian mixture.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- The first coordinate of one latent observation has the Rademacher law. -/
theorem latentSign_hasLaw (n : ℕ) :
    HasLaw (fun z : ℝ × (Fin n → ℝ) ↦ z.1)
      rademacherPMF.toMeasure (latentNoiseObservationMeasure n) := by
  exact MeasureTheory.measurePreserving_fst.hasLaw

/-- The second coordinate of one latent observation is a standard Gaussian
vector. -/
theorem latentNoise_isStandardNormal (n : ℕ) :
    NumStability.HDP.Vector.Gaussian.IsStandardNormal
      (latentNoiseObservationMeasure n)
      (fun j (z : ℝ × (Fin n → ℝ)) ↦ z.2 j) := by
  unfold NumStability.HDP.Vector.Gaussian.IsStandardNormal
  simpa using
    (MeasureTheory.measurePreserving_snd
      (μ := rademacherPMF.toMeasure)
      (ν := NumStability.standardGaussianVectorMeasure n)).hasLaw

/-- Every coordinate of one generated mixture observation is square
integrable. -/
theorem mixtureMap_coordinate_memLp_two {n : ℕ} (mean : Fin n → ℝ)
    (j : Fin n) :
    MemLp (fun z : ℝ × (Fin n → ℝ) ↦ mixtureMap mean z j) 2
      (latentNoiseObservationMeasure n) := by
  have hSign : MemLp (fun z : ℝ × (Fin n → ℝ) ↦ z.1) 2
      (latentNoiseObservationMeasure n) :=
    NumStability.HDP.Vector.Bernoulli.memLp_of_hasLaw_rademacher
      (latentSign_hasLaw n)
  have hNoiseLaw :=
    (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
      (latentNoise_isStandardNormal n)).2 j
  have hNoise : MemLp (fun z : ℝ × (Fin n → ℝ) ↦ z.2 j) 2
      (latentNoiseObservationMeasure n) :=
    hNoiseLaw.hasGaussianLaw.memLp_two
  simpa [mixtureMap] using (hSign.mul_const (mean j)).add hNoise

/-- Every coordinate of every row in the canonical product sample is square
integrable. -/
theorem canonicalPoint_coordinate_memLp_two {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m) (j : Fin n) :
    MemLp (fun ω ↦ canonicalPoint mean ω i j) 2
      (latentNoiseSampleMeasure m n) := by
  have hIdent := (canonicalPoint_hasLaw m n mean i).identDistrib
    (ProbabilityTheory.HasLaw.id (μ := gaussianMixtureMeasure mean))
  have hLaw := hIdent.comp (measurable_pi_apply j)
  have hCanonical : MemLp (fun x : Fin n → ℝ ↦ x j) 2
      (gaussianMixtureMeasure mean) := by
    have hMap : HasLaw (mixtureMap mean) (gaussianMixtureMeasure mean)
        (latentNoiseObservationMeasure n) :=
      ⟨(measurable_mixtureMap mean).aemeasurable, rfl⟩
    have hMapIdent := hMap.identDistrib
      (ProbabilityTheory.HasLaw.id (μ := gaussianMixtureMeasure mean))
    have hCoord := hMapIdent.comp (measurable_pi_apply j)
    simpa [Function.comp_def] using
      hCoord.memLp_snd (mixtureMap_coordinate_memLp_two mean j)
  simpa [Function.comp_def] using hLaw.symm.memLp_snd hCanonical

/-- A single latent Gaussian-mixture observation has a dimension-free vector
`ψ₂` bound at the natural scale `‖μ‖₂ + 1`. -/
theorem latentMixture_psiTwoNorm_le {n : ℕ} (mean : Fin n → ℝ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (latentNoiseObservationMeasure n)
        (fun j z ↦ mixtureMap mean z j) ≤
      ENNReal.ofReal (2 * (NumStability.vecNorm2 mean + 1)) := by
  let q : ℝ := 1 / Real.sqrt (Real.log 2)
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hsqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hlog
  have hlogQuarter : (1 / 4 : ℝ) < Real.log 2 :=
    lt_trans (by norm_num) Real.log_two_gt_d9
  have hsqrtHalf : (1 / 2 : ℝ) < Real.sqrt (Real.log 2) := by
    have hsqrtSq := Real.sq_sqrt hlog.le
    nlinarith [Real.sqrt_nonneg (Real.log 2)]
  have hq0 : 0 ≤ q := (div_pos one_pos hsqrt).le
  have hq2 : q ≤ 2 := by
    dsimp [q]
    apply (div_le_iff₀ hsqrt).2
    nlinarith
  have hSignGauge :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (latentNoiseObservationMeasure n)
          (fun z : ℝ × (Fin n → ℝ) ↦ z.1) = ENNReal.ofReal q := by
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_of_hasLaw
      measurable_fst (latentSign_hasLaw n),
      NumStability.HDP.Vector.Bernoulli.rademacherPMF_toMeasure_eq_rademacherPsiTwoLaw,
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact]
  have hNoiseVector :
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (latentNoiseObservationMeasure n)
          (fun j (z : ℝ × (Fin n → ℝ)) ↦ z.2 j) ≤ ENNReal.ofReal 2 := by
    rw [NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
      (fun _j ↦ measurable_snd.eval)
      (latentNoise_isStandardNormal n)]
    exact NumStability.HDP.Vector.Gaussian.standardGaussianVector_psiTwoNorm_le_two n
  unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
  refine iSup_le fun u ↦ ?_
  let c : ℝ := dotProduct mean u.1
  let G : (ℝ × (Fin n → ℝ)) → ℝ := fun z ↦
    NumStability.HDP.Vector.linearMarginal
      (fun j (z : ℝ × (Fin n → ℝ)) ↦ z.2 j) u.1 z
  have hMarginal :
      NumStability.HDP.Vector.linearMarginal
          (fun j z ↦ mixtureMap mean z j) u.1 =
        fun z ↦ c * z.1 + G z := by
    funext z
    dsimp [c, G, mixtureMap, NumStability.HDP.Vector.linearMarginal,
      dotProduct]
    simp_rw [add_mul]
    rw [Finset.sum_add_distrib]
    apply congrArg₂ (· + ·)
    · calc
        (∑ j, z.1 * mean j * u.1 j) =
            ∑ j, z.1 * (mean j * u.1 j) := by
              apply Finset.sum_congr rfl
              intro j _hj
              ring
        _ = z.1 * ∑ j, mean j * u.1 j := (Finset.mul_sum _ _ _).symm
        _ = (∑ j, mean j * u.1 j) * z.1 := by ring
    · rfl
  rw [hMarginal]
  have hSignal :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (latentNoiseObservationMeasure n) (fun z ↦ c * z.1) ≤
        ENNReal.ofReal (2 * |c|) := by
    by_cases hc : c = 0
    · simp [hc, NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero]
    · rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero hc,
        hSignGauge]
      rw [← ENNReal.ofReal_mul (abs_nonneg c)]
      exact ENNReal.ofReal_le_ofReal (by nlinarith [abs_nonneg c])
  have hNoise :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (latentNoiseObservationMeasure n) G ≤ ENNReal.ofReal 2 := by
    change NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
        (latentNoiseObservationMeasure n) G ≤ ENNReal.ofReal 2
    exact (le_iSup
      (fun v : NumStability.HDP.Vector.SubGaussian.UnitDirection n ↦
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (latentNoiseObservationMeasure n)
          (NumStability.HDP.Vector.linearMarginal
            (fun j (z : ℝ × (Fin n → ℝ)) ↦ z.2 j) v.1)) u).trans hNoiseVector
  have hcBound : |c| ≤ NumStability.vecNorm2 mean := by
    calc
      |c| ≤ NumStability.vecNorm2 mean * NumStability.vecNorm2 u.1 :=
        abs_dotProduct_le_vecNorm2_mul_vecNorm2 mean u.1
      _ = NumStability.vecNorm2 mean := by rw [u.2, mul_one]
  calc
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (latentNoiseObservationMeasure n) (fun z ↦ c * z.1 + G z) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
            (latentNoiseObservationMeasure n) (fun z ↦ c * z.1) +
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
            (latentNoiseObservationMeasure n) G :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_add_le
    _ ≤ ENNReal.ofReal (2 * |c|) + ENNReal.ofReal 2 := add_le_add hSignal hNoise
    _ = ENNReal.ofReal (2 * (|c| + 1)) := by
      rw [← ENNReal.ofReal_add (by positivity : 0 ≤ 2 * |c|) (by norm_num : 0 ≤ (2 : ℝ))]
      congr 1
      ring
    _ ≤ ENNReal.ofReal (2 * (NumStability.vecNorm2 mean + 1)) :=
      ENNReal.ofReal_le_ofReal (by nlinarith)

/-- The point-only Gaussian-mixture law inherits the same vector `ψ₂` bound. -/
theorem gaussianMixtureMeasure_psiTwoNorm_le {n : ℕ} (mean : Fin n → ℝ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (gaussianMixtureMeasure mean) (fun j x ↦ x j) ≤
      ENNReal.ofReal (2 * (NumStability.vecNorm2 mean + 1)) := by
  have hMap : HasLaw (mixtureMap mean) (gaussianMixtureMeasure mean)
      (latentNoiseObservationMeasure n) :=
    ⟨(measurable_mixtureMap mean).aemeasurable, rfl⟩
  rw [← NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
    (fun j ↦ (measurable_pi_apply j).comp (measurable_mixtureMap mean)) hMap]
  exact latentMixture_psiTwoNorm_le mean

/-- Every observed row of the canonical product sample has the same uniform
vector `ψ₂` bound. -/
theorem canonicalPoint_psiTwoNorm_le {m n : ℕ} (mean : Fin n → ℝ)
    (i : Fin m) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (latentNoiseSampleMeasure m n)
        (fun j ω ↦ canonicalPoint mean ω i j) ≤
      ENNReal.ofReal (2 * (NumStability.vecNorm2 mean + 1)) := by
  have hEq :
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (latentNoiseSampleMeasure m n)
          (fun j ω ↦ canonicalPoint mean ω i j) =
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (gaussianMixtureMeasure mean) (fun j x ↦ x j) := by
    simpa [Function.comp_def] using
      (NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
        (fun j ↦ (measurable_pi_apply j).comp
          (measurable_canonicalPoint mean i))
        (canonicalPoint_hasLaw m n mean i))
  rw [hEq]
  exact gaussianMixtureMeasure_psiTwoNorm_le mean

/-- The uncentered second moment of one latent mixture observation is
`I + μ μᵀ`. -/
theorem latentMixture_secondMoment {n : ℕ} (mean : Fin n → ℝ) :
    NumStability.HDP.Vector.Covariance.secondMomentMatrix
        (latentNoiseObservationMeasure n)
        (fun j z ↦ mixtureMap mean z j) =
      populationSecondMoment mean := by
  funext a b
  have hSignLp : MemLp (fun z : ℝ × (Fin n → ℝ) ↦ z.1) 2
      (latentNoiseObservationMeasure n) :=
    NumStability.HDP.Vector.Bernoulli.memLp_of_hasLaw_rademacher
      (latentSign_hasLaw n)
  have hNoiseLaw (j : Fin n) :=
    (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
      (latentNoise_isStandardNormal n)).2 j
  have hNoiseLp (j : Fin n) :
      MemLp (fun z : ℝ × (Fin n → ℝ) ↦ z.2 j) 2
        (latentNoiseObservationMeasure n) :=
    (hNoiseLaw j).hasGaussianLaw.memLp_two
  have hSignInt : Integrable (fun z : ℝ × (Fin n → ℝ) ↦ z.1)
      (latentNoiseObservationMeasure n) := hSignLp.integrable (by norm_num)
  have hNoiseInt (j : Fin n) :
      Integrable (fun z : ℝ × (Fin n → ℝ) ↦ z.2 j)
        (latentNoiseObservationMeasure n) := (hNoiseLp j).integrable (by norm_num)
  have hSignSqInt : Integrable
      (fun z : ℝ × (Fin n → ℝ) ↦ z.1 * z.1)
      (latentNoiseObservationMeasure n) := hSignLp.integrable_mul hSignLp
  have hCrossInt (j : Fin n) : Integrable
      (fun z : ℝ × (Fin n → ℝ) ↦ z.1 * z.2 j)
      (latentNoiseObservationMeasure n) := hSignLp.integrable_mul (hNoiseLp j)
  have hNoiseProdInt : Integrable
      (fun z : ℝ × (Fin n → ℝ) ↦ z.2 a * z.2 b)
      (latentNoiseObservationMeasure n) :=
    (hNoiseLp a).integrable_mul (hNoiseLp b)
  have hSignSq :
      (∫ z : ℝ × (Fin n → ℝ), z.1 * z.1
          ∂latentNoiseObservationMeasure n) = 1 := by
    have h := (latentSign_hasLaw n).integral_comp
      (f := fun x : ℝ ↦ x ^ 2) (by fun_prop)
    calc
      (∫ z : ℝ × (Fin n → ℝ), z.1 * z.1
          ∂latentNoiseObservationMeasure n) =
          ∫ x : ℝ, x ^ 2 ∂rademacherPMF.toMeasure := by
            simpa [Function.comp_def, pow_two] using h
      _ = 1 := by
        simpa [pow_two] using rademacherPMF_variance
  have hCross (j : Fin n) :
      (∫ z : ℝ × (Fin n → ℝ), z.1 * z.2 j
          ∂latentNoiseObservationMeasure n) = 0 := by
    calc
      (∫ z : ℝ × (Fin n → ℝ), z.1 * z.2 j
          ∂latentNoiseObservationMeasure n) =
          (∫ x : ℝ, x ∂rademacherPMF.toMeasure) *
            ∫ g : Fin n → ℝ, g j
              ∂NumStability.standardGaussianVectorMeasure n := by
            exact MeasureTheory.integral_prod_mul
              (μ := rademacherPMF.toMeasure)
              (ν := NumStability.standardGaussianVectorMeasure n)
              (fun x : ℝ ↦ x) (fun g : Fin n → ℝ ↦ g j)
      _ = 0 := by rw [rademacherPMF_mean, zero_mul]
  have hNoiseProd :
      (∫ z : ℝ × (Fin n → ℝ), z.2 a * z.2 b
          ∂latentNoiseObservationMeasure n) = if a = b then 1 else 0 := by
    exact (NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul
      (latentNoiseObservationMeasure n)
      (fun j (z : ℝ × (Fin n → ℝ)) ↦ z.2 j)).1
        (NumStability.HDP.Vector.Gaussian.isIsotropic_of_isStandardNormal
          (latentNoise_isStandardNormal n)) a b
  have h1 : Integrable
      (fun z : ℝ × (Fin n → ℝ) ↦
        mean a * mean b * (z.1 * z.1))
      (latentNoiseObservationMeasure n) := hSignSqInt.const_mul _
  have h2 : Integrable
      (fun z : ℝ × (Fin n → ℝ) ↦ mean a * (z.1 * z.2 b))
      (latentNoiseObservationMeasure n) := (hCrossInt b).const_mul _
  have h3 : Integrable
      (fun z : ℝ × (Fin n → ℝ) ↦ mean b * (z.1 * z.2 a))
      (latentNoiseObservationMeasure n) := (hCrossInt a).const_mul _
  rw [NumStability.HDP.Vector.Covariance.secondMomentMatrix,
    populationSecondMoment_apply]
  calc
    (∫ z, mixtureMap mean z a * mixtureMap mean z b
        ∂latentNoiseObservationMeasure n) =
        ∫ z,
          (mean a * mean b * (z.1 * z.1) +
            mean a * (z.1 * z.2 b)) +
          (mean b * (z.1 * z.2 a) + z.2 a * z.2 b)
          ∂latentNoiseObservationMeasure n := by
            apply integral_congr_ae
            filter_upwards with z
            simp only [mixtureMap]
            ring
    _ = (∫ z,
          mean a * mean b * (z.1 * z.1) +
            mean a * (z.1 * z.2 b)
          ∂latentNoiseObservationMeasure n) +
        ∫ z,
          mean b * (z.1 * z.2 a) + z.2 a * z.2 b
          ∂latentNoiseObservationMeasure n := by
            exact integral_add (h1.add h2) (h3.add hNoiseProdInt)
    _ = mean a * mean b *
          (∫ z, z.1 * z.1 ∂latentNoiseObservationMeasure n) +
        mean a * (∫ z, z.1 * z.2 b ∂latentNoiseObservationMeasure n) +
        (mean b * (∫ z, z.1 * z.2 a ∂latentNoiseObservationMeasure n) +
          ∫ z, z.2 a * z.2 b ∂latentNoiseObservationMeasure n) := by
            rw [integral_add h1 h2, integral_add h3 hNoiseProdInt,
              integral_const_mul, integral_const_mul,
              integral_const_mul]
    _ = (if a = b then 1 else 0) + mean a * mean b := by
      rw [hSignSq, hCross b, hCross a, hNoiseProd]
      ring

/-- The point-only mixture law has population second moment `I + μ μᵀ`. -/
theorem gaussianMixtureMeasure_secondMoment {n : ℕ} (mean : Fin n → ℝ) :
    NumStability.HDP.Vector.Covariance.secondMomentMatrix
        (gaussianMixtureMeasure mean) (fun j x ↦ x j) =
      populationSecondMoment mean := by
  funext a b
  have hMap : HasLaw (mixtureMap mean) (gaussianMixtureMeasure mean)
      (latentNoiseObservationMeasure n) :=
    ⟨(measurable_mixtureMap mean).aemeasurable, rfl⟩
  have hIntegral := hMap.integral_comp
    (f := fun x : Fin n → ℝ ↦ x a * x b) (by fun_prop)
  have hEntry := congrArg
    (fun M : Matrix (Fin n) (Fin n) ℝ ↦ M a b)
    (latentMixture_secondMoment mean)
  change (∫ x, x a * x b ∂gaussianMixtureMeasure mean) =
    populationSecondMoment mean a b
  change (∫ z, mixtureMap mean z a * mixtureMap mean z b
      ∂latentNoiseObservationMeasure n) =
    populationSecondMoment mean a b at hEntry
  exact hIntegral.symm.trans (by simpa [Function.comp_def] using hEntry)

/-- Every row of the canonical product sample has the same population second
moment matrix. -/
theorem canonicalPoint_secondMoment {m n : ℕ} (mean : Fin n → ℝ)
    (i : Fin m) :
    NumStability.HDP.Vector.Covariance.secondMomentMatrix
        (latentNoiseSampleMeasure m n)
        (fun j ω ↦ canonicalPoint mean ω i j) =
      populationSecondMoment mean := by
  funext a b
  have hIntegral := (canonicalPoint_hasLaw m n mean i).integral_comp
    (f := fun x : Fin n → ℝ ↦ x a * x b) (by fun_prop)
  have hEntry := congrArg
    (fun M : Matrix (Fin n) (Fin n) ℝ ↦ M a b)
    (gaussianMixtureMeasure_secondMoment mean)
  change (∫ ω, canonicalPoint mean ω i a * canonicalPoint mean ω i b
      ∂latentNoiseSampleMeasure m n) =
    populationSecondMoment mean a b
  change (∫ x, x a * x b ∂gaussianMixtureMeasure mean) =
    populationSecondMoment mean a b at hEntry
  exact hIntegral.trans (by simpa [Function.comp_def] using hEntry)

/-- Operator-norm concentration of the empirical second moment for the
canonical symmetric Gaussian-mixture sample.  This is the probabilistic
input used by the spectral-clustering argument. -/
theorem exists_canonicalSampleCovarianceDeviation_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        ∀ (mean : Fin n → ℝ) {t : ℝ}, 0 ≤ t →
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          (latentNoiseSampleMeasure m n).real
              {ω |
                L ^ 2 * max delta (delta ^ 2) <
                  NumStability.realMatrixOperatorNorm
                    (NumStability.HDP.Vector.Covariance.randomSampleCovariance
                        (fun i ω ↦ canonicalPoint mean ω i) ω -
                      populationSecondMoment mean)} ≤
            2 * Real.exp (-(t ^ 2)) := by
  obtain ⟨C, hC, hTail⟩ :=
    NumStability.HDP.Vector.Covariance.exists_sampleCovarianceDeviation_tail
  refine ⟨C, hC, ?_⟩
  intro m n hm hn mean t ht
  dsimp only
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  have hNorm : 0 ≤ NumStability.vecNorm2 mean :=
    NumStability.vecNorm2_nonneg mean
  have hL : 0 < 2 * (NumStability.vecNorm2 mean + 1) := by
    nlinarith
  exact hTail hm hn
    (fun i ω ↦ canonicalPoint mean ω i)
    (populationSecondMoment mean) hL
    (fun i j ↦ (measurable_pi_apply j).comp
      (measurable_canonicalPoint mean i))
    (fun i j ↦ canonicalPoint_coordinate_memLp_two mean i j)
    (fun i ↦ canonicalPoint_secondMoment mean i)
    (fun i ↦ canonicalPoint_psiTwoNorm_le mean i)
    (canonicalPoints_iIndep m n mean) ht

end NumStability.HDP.Vector.GaussianMixture
