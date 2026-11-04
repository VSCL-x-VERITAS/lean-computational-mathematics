import ComputationalMathematics.HDP.Vector.GaussianMixtureConcentration
import ComputationalMathematics.HDP.Vector.GaussianMixtureSpectral
import ComputationalMathematics.HDP.Vector.SubGaussianRelativeL2
import ComputationalMathematics.HDP.Vector.MarginalVariance

/-!
# Relative sub-Gaussian bounds for the Gaussian mixture

Every scalar projection has its exact population second moment and a gauge
bound in terms of the separate signal and noise scales. One absolute constant
at least one controls its gauge by its own L2 norm, uniformly in the dimension
and mean, including zero cases. The observed law and canonical sample rows
inherit the bound by their existing distribution identities.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal BigOperators RealInnerProductSpace

namespace NumStability.HDP.Vector.GaussianMixture

/-- Exact marginal second moment, reusing the existing population matrix. -/
theorem latentMixture_linearMarginal_secondMoment {n : ℕ}
    (mean x : Fin n → ℝ) :
    (∫ z, NumStability.HDP.Vector.linearMarginal
        (fun j z ↦ mixtureMap mean z j) x z ^ 2
        ∂latentNoiseObservationMeasure n) =
      (dotProduct mean x) ^ 2 + NumStability.vecNorm2 x ^ 2 := by
  have hQ := NumStability.HDP.Vector.Isotropy.marginalSecondMoment_eq_quadraticForm
    (latentNoiseObservationMeasure n) (fun j z ↦ mixtureMap mean z j)
    (fun i j ↦ (mixtureMap_coordinate_memLp_two mean i).integrable_mul
      (mixtureMap_coordinate_memLp_two mean j)) x
  rw [latentMixture_secondMoment mean] at hQ
  calc
    (∫ z, NumStability.HDP.Vector.linearMarginal
        (fun j z ↦ mixtureMap mean z j) x z ^ 2
        ∂latentNoiseObservationMeasure n) =
        NumStability.matrixRayleighForm (populationSecondMoment mean)
          (WithLp.toLp 2 x) := by
      rw [show (∫ z, NumStability.HDP.Vector.linearMarginal
          (fun j z ↦ mixtureMap mean z j) x z ^ 2
          ∂latentNoiseObservationMeasure n) =
          ∑ i, ∑ j, x i * populationSecondMoment mean i j * x j from hQ]
      simp only [NumStability.matrixRayleighForm, PiLp.inner_apply,
        real_inner_eq_re_inner, RCLike.inner_apply]
      change (∑ i, ∑ j, x i * populationSecondMoment mean i j * x j) =
        ∑ i, (∑ j, populationSecondMoment mean i j * x j) * x i
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = (dotProduct mean x) ^ 2 + NumStability.vecNorm2 x ^ 2 := by
      rw [populationSecondMoment_rayleigh,
        NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      exact add_comm _ _

/-- A directional gauge bound using the separate sign and noise scales. -/
theorem latentMixture_linearMarginal_psiTwoNorm_le {n : ℕ}
    (mean x : Fin n → ℝ) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
        (latentNoiseObservationMeasure n)
        (NumStability.HDP.Vector.linearMarginal
          (fun j z ↦ mixtureMap mean z j) x) ≤
      ENNReal.ofReal ((1 / Real.sqrt (Real.log 2)) * |dotProduct mean x| +
        2 * NumStability.vecNorm2 x) := by
  let c : ℝ := dotProduct mean x
  let r : ℝ := NumStability.vecNorm2 x
  let q : ℝ := 1 / Real.sqrt (Real.log 2)
  let G : (ℝ × (Fin n → ℝ)) → ℝ :=
    NumStability.HDP.Vector.linearMarginal
      (fun j (z : ℝ × (Fin n → ℝ)) ↦ z.2 j) x
  have hMarginal : NumStability.HDP.Vector.linearMarginal
      (fun j z ↦ mixtureMap mean z j) x = fun z ↦ c * z.1 + G z := by
    funext z
    dsimp [c, G, mixtureMap, NumStability.HDP.Vector.linearMarginal, dotProduct]
    simp_rw [add_mul]
    rw [Finset.sum_add_distrib, Finset.sum_mul]
    apply congrArg₂ (· + ·)
    · apply Finset.sum_congr rfl
      intro j _
      ring
    · rfl
  have hSign : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
      (latentNoiseObservationMeasure n) (fun z : ℝ × (Fin n → ℝ) ↦ z.1) =
      ENNReal.ofReal q := by
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_of_hasLaw
      measurable_fst (latentSign_hasLaw n),
      NumStability.HDP.Vector.Bernoulli.rademacherPMF_toMeasure_eq_rademacherPsiTwoLaw,
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact]
  have hSignal : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
      (latentNoiseObservationMeasure n) (fun z : ℝ × (Fin n → ℝ) ↦ c * z.1) ≤
      ENNReal.ofReal (q * |c|) := by
    by_cases hc : c = 0
    · simp [hc, NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero]
    · rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero hc,
        hSign, ← ENNReal.ofReal_mul (abs_nonneg c), mul_comm |c| q]
  have hGaussian := NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
    (latentNoise_isStandardNormal n)
  have hNoiseRaw := NumStability.HDP.Scalar.SubGaussian.independentGaussianWeightedSumLaw
    x hGaussian.2 hGaussian.1
  have hVariance : (∑ j, Real.toNNReal (x j ^ 2) * (1 : ℝ≥0)) =
      (⟨r ^ 2, sq_nonneg r⟩ : ℝ≥0) := by
    apply NNReal.eq
    simp only [NNReal.coe_sum, mul_one,
      Real.toNNReal_of_nonneg (sq_nonneg _), NNReal.coe_mk]
    exact (NumStability.vecNorm2_sq x).symm
  rw [hVariance] at hNoiseRaw
  have hNoiseLaw : HasLaw G (gaussianReal 0 (⟨r ^ 2, sq_nonneg r⟩ : ℝ≥0))
      (latentNoiseObservationMeasure n) := by
    convert hNoiseRaw using 1
    funext z
    dsimp [G, NumStability.HDP.Vector.linearMarginal]
    apply Finset.sum_congr rfl
    intro j _
    ring
  have hNoise : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
      (latentNoiseObservationMeasure n) G ≤ ENNReal.ofReal (2 * r) := by
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_of_hasLaw
      (by dsimp [G]; unfold NumStability.HDP.Vector.linearMarginal; fun_prop) hNoiseLaw]
    exact NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul.2 r
      (NumStability.vecNorm2_nonneg x)
  have hq : 0 ≤ q := by dsimp [q]; positivity
  rw [hMarginal]
  change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
      (latentNoiseObservationMeasure n) (fun z ↦ c * z.1 + G z) ≤ _
  calc
    _ ≤ NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (latentNoiseObservationMeasure n) (fun z ↦ c * z.1) +
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (latentNoiseObservationMeasure n) G :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_add_le
    _ ≤ ENNReal.ofReal (q * |c|) + ENNReal.ofReal (2 * r) :=
      add_le_add hSignal hNoise
    _ = ENNReal.ofReal (q * |c| + 2 * r) := by
      rw [ENNReal.ofReal_add (mul_nonneg hq (abs_nonneg c))
        (mul_nonneg (by norm_num) (NumStability.vecNorm2_nonneg x))]

/-- One absolute constant works for every latent mixture projection. -/
theorem latentMixture_satisfiesPsiTwoL2Bound {n : ℕ} (mean : Fin n → ℝ) :
    NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
      (latentNoiseObservationMeasure n) (fun j z ↦ mixtureMap mean z j)
      (Real.toNNReal (2 + 1 / Real.sqrt (Real.log 2))) := by
  intro x
  let c : ℝ := dotProduct mean x
  let r : ℝ := NumStability.vecNorm2 x
  let q : ℝ := 1 / Real.sqrt (Real.log 2)
  have hq : 0 ≤ q := by dsimp [q]; positivity
  have hR : 0 ≤ r := NumStability.vecNorm2_nonneg x
  have hC : |c| ≤ Real.sqrt (c ^ 2 + r ^ 2) := by
    rw [← Real.sqrt_sq_eq_abs c]
    exact Real.sqrt_le_sqrt (by nlinarith [sq_nonneg r])
  have hNoise : r ≤ Real.sqrt (c ^ 2 + r ^ 2) := by
    calc
      r = Real.sqrt (r ^ 2) := by rw [Real.sqrt_sq_eq_abs, abs_of_nonneg hR]
      _ ≤ Real.sqrt (c ^ 2 + r ^ 2) :=
        Real.sqrt_le_sqrt (by nlinarith [sq_nonneg c])
  have hScalar : q * |c| + 2 * r ≤ (2 + q) * Real.sqrt (c ^ 2 + r ^ 2) := by
    nlinarith [mul_le_mul_of_nonneg_left hC hq]
  have hLp : MemLp (NumStability.HDP.Vector.linearMarginal
      (fun j z ↦ mixtureMap mean z j) x) 2 (latentNoiseObservationMeasure n) :=
    NumStability.HDP.Vector.Isotropy.marginal_memLp
      (fun j ↦ mixtureMap_coordinate_memLp_two mean j) x
  rw [NumStability.HDP.Scalar.Preliminaries.eLpNorm_two_eq_ofReal_sqrt_integral_sq hLp,
    latentMixture_linearMarginal_secondMoment]
  have hK : 0 ≤ 2 + q := by linarith
  change NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
    (latentNoiseObservationMeasure n)
    (NumStability.HDP.Vector.linearMarginal (fun j z ↦ mixtureMap mean z j) x) ≤
    ENNReal.ofReal (2 + q) * ENNReal.ofReal (Real.sqrt (c ^ 2 + r ^ 2))
  rw [← ENNReal.ofReal_mul hK]
  exact (latentMixture_linearMarginal_psiTwoNorm_le mean x).trans
    (ENNReal.ofReal_le_ofReal hScalar)

/-- Relative directional control depends only on the observed mixture law. -/
theorem gaussianMixtureMeasure_satisfiesPsiTwoL2Bound {n : ℕ}
    (mean : Fin n → ℝ) :
    NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
      (gaussianMixtureMeasure mean) (fun j y ↦ y j)
      (Real.toNNReal (2 + 1 / Real.sqrt (Real.log 2))) := by
  intro x
  have hMap : HasLaw (mixtureMap mean) (gaussianMixtureMeasure mean)
      (latentNoiseObservationMeasure n) :=
    ⟨(measurable_mixtureMap mean).aemeasurable, rfl⟩
  let L : (Fin n → ℝ) → ℝ :=
    NumStability.HDP.Vector.linearMarginal (fun j y ↦ y j) x
  have hL : Measurable L := by dsimp [L]; unfold NumStability.HDP.Vector.linearMarginal; fun_prop
  have hLatent := (hMap.identDistrib (HasLaw.id (μ := gaussianMixtureMeasure mean))).comp hL
  have hBound : NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
      (latentNoiseObservationMeasure n) (fun z ↦ L (mixtureMap mean z)) ≤
      (Real.toNNReal (2 + 1 / Real.sqrt (Real.log 2)) : ℝ≥0∞) *
        eLpNorm (fun z ↦ L (mixtureMap mean z)) 2
          (latentNoiseObservationMeasure n) :=
    latentMixture_satisfiesPsiTwoL2Bound mean x
  have hNorm : eLpNorm (fun z ↦ L (mixtureMap mean z)) 2
      (latentNoiseObservationMeasure n) =
      eLpNorm L 2 (gaussianMixtureMeasure mean) := by
    simpa [Function.comp_def] using hLatent.eLpNorm_eq 2
  have hPsi : NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
      (latentNoiseObservationMeasure n) (fun z ↦ L (mixtureMap mean z)) =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
        (gaussianMixtureMeasure mean) L := by
    have hCanonicalLaw : HasLaw L (Measure.map L (gaussianMixtureMeasure mean))
        (gaussianMixtureMeasure mean) := ⟨hL.aemeasurable, rfl⟩
    have hLatentLaw : HasLaw (fun z ↦ L (mixtureMap mean z))
        (Measure.map L (gaussianMixtureMeasure mean))
        (latentNoiseObservationMeasure n) := by
      simpa only [Function.comp_def] using hCanonicalLaw.comp hMap
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_sameLaw
      (hL.comp (measurable_mixtureMap mean)) hL hLatentLaw hCanonicalLaw
  rw [hPsi, hNorm] at hBound
  exact hBound

/-- Every observed canonical row inherits the same relative marginal bound. -/
theorem canonicalPoint_satisfiesPsiTwoL2Bound {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m) :
    NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
      (latentNoiseSampleMeasure m n) (fun j ω ↦ canonicalPoint mean ω i j)
      (Real.toNNReal (2 + 1 / Real.sqrt (Real.log 2))) := by
  intro x
  let L : (Fin n → ℝ) → ℝ :=
    NumStability.HDP.Vector.linearMarginal (fun j y ↦ y j) x
  have hL : Measurable L := by dsimp [L]; unfold NumStability.HDP.Vector.linearMarginal; fun_prop
  have hPoint := canonicalPoint_hasLaw m n mean i
  have hCanonicalLaw : HasLaw L (Measure.map L (gaussianMixtureMeasure mean))
      (gaussianMixtureMeasure mean) := ⟨hL.aemeasurable, rfl⟩
  have hSourceLaw : HasLaw (fun ω ↦ L (canonicalPoint mean ω i))
      (Measure.map L (gaussianMixtureMeasure mean)) (latentNoiseSampleMeasure m n) := by
    simpa only [Function.comp_def] using hCanonicalLaw.comp hPoint
  have hPsi : NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
      (latentNoiseSampleMeasure m n) (fun ω ↦ L (canonicalPoint mean ω i)) =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
        (gaussianMixtureMeasure mean) L :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_sameLaw
      (hL.comp (measurable_canonicalPoint mean i)) hL hSourceLaw hCanonicalLaw
  have hNorm : eLpNorm (fun ω ↦ L (canonicalPoint mean ω i)) 2
      (latentNoiseSampleMeasure m n) = eLpNorm L 2 (gaussianMixtureMeasure mean) := by
    simpa only [Function.comp_def] using
      ((hPoint.identDistrib (HasLaw.id (μ := gaussianMixtureMeasure mean))).comp hL).eLpNorm_eq 2
  change NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
      (latentNoiseSampleMeasure m n) (fun ω ↦ L (canonicalPoint mean ω i)) ≤
      (Real.toNNReal (2 + 1 / Real.sqrt (Real.log 2)) : ℝ≥0∞) *
        eLpNorm (fun ω ↦ L (canonicalPoint mean ω i)) 2 (latentNoiseSampleMeasure m n)
  rw [hPsi, hNorm]
  exact gaussianMixtureMeasure_satisfiesPsiTwoL2Bound mean x

/-- An absolute constant at least one works uniformly for the latent law,
the observed law and every row of every canonical sample. -/
theorem exists_mixture_absolute_relativePsiTwoL2Bound :
    ∃ K : ℝ≥0, 1 ≤ K ∧
      ∀ (n : ℕ) (mean : Fin n → ℝ),
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
          (latentNoiseObservationMeasure n) (fun j z ↦ mixtureMap mean z j) K ∧
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
          (gaussianMixtureMeasure mean) (fun j y ↦ y j) K ∧
        ∀ (m : ℕ) (i : Fin m),
          NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
            (latentNoiseSampleMeasure m n) (fun j ω ↦ canonicalPoint mean ω i j) K := by
  refine ⟨Real.toNNReal (2 + 1 / Real.sqrt (Real.log 2)), ?_, ?_⟩
  · have hq : 0 ≤ 1 / Real.sqrt (Real.log 2) := by positivity
    have hK : 0 ≤ 2 + 1 / Real.sqrt (Real.log 2) := by linarith
    have hOne : (1 : ℝ) ≤
        (Real.toNNReal (2 + 1 / Real.sqrt (Real.log 2)) : ℝ) := by
      rw [Real.toNNReal_of_nonneg hK]
      change 1 ≤ 2 + 1 / Real.sqrt (Real.log 2)
      linarith
    exact_mod_cast hOne
  · intro n mean
    exact ⟨latentMixture_satisfiesPsiTwoL2Bound mean,
      gaussianMixtureMeasure_satisfiesPsiTwoL2Bound mean,
      fun m i ↦ canonicalPoint_satisfiesPsiTwoL2Bound mean i⟩

end NumStability.HDP.Vector.GaussianMixture
