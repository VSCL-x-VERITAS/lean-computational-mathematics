import ComputationalMathematics.HDP.Vector.GaussianMixtureConcentration

/-!
# First moment of the symmetric Gaussian mixture

The already constructed fair independent sign and standard Gaussian laws give
an integrable coordinate with ordinary expectation zero. This is an ordinary
law calculation, including zero signal and every finite ambient dimension.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.GaussianMixture

/-- Each coordinate of the point-only symmetric mixture is integrable and has
ordinary expectation zero. -/
theorem gaussianMixtureMeasure_coordinate_mean_zero {n : ℕ}
    (mean : Fin n → ℝ) (j : Fin n) :
    Integrable (fun x : Fin n → ℝ ↦ x j) (gaussianMixtureMeasure mean) ∧
      (∫ x : Fin n → ℝ, x j ∂gaussianMixtureMeasure mean) = 0 := by
  have hSignLp := NumStability.HDP.Vector.Bernoulli.memLp_of_hasLaw_rademacher
    (latentSign_hasLaw n)
  have hNoiseLaw :=
    (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
      (latentNoise_isStandardNormal n)).2 j
  have hSignInt := hSignLp.integrable (by norm_num : 1 ≤ (2 : ℝ≥0∞))
  have hNoiseInt := hNoiseLaw.hasGaussianLaw.memLp_two.integrable
    (by norm_num : 1 ≤ (2 : ℝ≥0∞))
  have hSignMean := NumStability.HDP.Vector.Bernoulli.integral_eq_zero_of_hasLaw_rademacher
    (latentSign_hasLaw n)
  have hNoiseMean :
      (∫ z : ℝ × (Fin n → ℝ), z.2 j ∂latentNoiseObservationMeasure n) = 0 := by
    simpa using hNoiseLaw.integral_eq
  have hLatentMean :
      (∫ z : ℝ × (Fin n → ℝ), mixtureMap mean z j
        ∂latentNoiseObservationMeasure n) = 0 := by
    change (∫ z : ℝ × (Fin n → ℝ), z.1 * mean j + z.2 j
      ∂latentNoiseObservationMeasure n) = 0
    rw [integral_add (hSignInt.mul_const (mean j)) hNoiseInt,
      integral_mul_const, hSignMean, hNoiseMean, zero_mul, zero_add]
  have hMap : HasLaw (mixtureMap mean) (gaussianMixtureMeasure mean)
      (latentNoiseObservationMeasure n) :=
    ⟨(measurable_mixtureMap mean).aemeasurable, rfl⟩
  letI : IsFiniteMeasure (gaussianMixtureMeasure mean) :=
    hMap.isFiniteMeasure_iff.1 inferInstance
  have hMapIdent := hMap.identDistrib
    (ProbabilityTheory.HasLaw.id (μ := gaussianMixtureMeasure mean))
  have hCoord := hMapIdent.comp (measurable_pi_apply j)
  have hLp : MemLp (fun x : Fin n → ℝ ↦ x j) 2
      (gaussianMixtureMeasure mean) := by
    simpa [Function.comp_def] using
      hCoord.memLp_snd (mixtureMap_coordinate_memLp_two mean j)
  constructor
  · exact hLp.integrable (by norm_num)
  · have hIntegral := hMap.integral_comp
      (f := fun x : Fin n → ℝ ↦ x j) hLp.aestronglyMeasurable
    simpa [Function.comp_def] using hIntegral.symm.trans hLatentMean

end NumStability.HDP.Vector.GaussianMixture
