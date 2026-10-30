import ComputationalMathematics.HDP.Vector.GaussianMixtureRelativeL2
import ComputationalMathematics.HDP.Vector.GeneralCovarianceEstimation

/-!
# Covariance expectation for the Gaussian mixture

One absolute constant bounds the expected operator norm error of the actual
canonical sample covariance, relative to its population operator norm. The
bound holds for every positive sample size and every dimension, including zero,
by the general iid covariance theorem and the uniform relative marginal bound.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Vector.GaussianMixture

/-- Expected covariance error for actual canonical observations, with an
absolute constant and their actual population operator norm. -/
theorem exists_canonicalSampleCovarianceExpectation_relative_bound :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → ∀ (mean : Fin n → ℝ),
        (∫ ω, NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.Covariance.randomSampleCovariance
            (fun i ω ↦ canonicalPoint mean ω i) ω - populationSecondMoment mean)
          ∂latentNoiseSampleMeasure m n) ≤
          C * (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            NumStability.realMatrixOperatorNorm (populationSecondMoment mean) := by
  obtain ⟨D, hD, hBound⟩ :=
    NumStability.HDP.Vector.Covariance.exists_expected_sampleCovariance_error_bound_of_iid_all_dimensions
  obtain ⟨K, hK, hRelative⟩ := exists_mixture_absolute_relativePsiTwoL2Bound
  have hKpos : (0 : ℝ) < K := by
    have hOne : (1 : ℝ) ≤ K := by exact_mod_cast hK
    linarith
  refine ⟨D * (K : ℝ) ^ 2, mul_pos hD (sq_pos_of_pos hKpos), ?_⟩
  intro m n hm mean
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  let first : Fin m := ⟨0, hm⟩
  let Z := fun ω ↦ canonicalPoint mean ω first
  let X : Fin m → (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ :=
    fun i ω ↦ canonicalPoint mean ω i
  have hMeas (i : Fin m) (j : Fin n) :
      Measurable (fun ω ↦ canonicalPoint mean ω i j) :=
    (measurable_pi_apply j).comp (measurable_canonicalPoint mean i)
  have hIdent (i : Fin m) : IdentDistrib (X i) Z
      (latentNoiseSampleMeasure m n) (latentNoiseSampleMeasure m n) :=
    (canonicalPoint_hasLaw m n mean i).identDistrib
      (canonicalPoint_hasLaw m n mean first)
  have hRaw := hBound hm Z X K hK (hMeas first)
    (fun j ↦ canonicalPoint_coordinate_memLp_two mean first j) hMeas hIdent
    (canonicalPoints_iIndep m n mean) ((hRelative n mean).2.2 m first)
  simpa only [Z, X, canonicalPoint_secondMoment] using hRaw

end NumStability.HDP.Vector.GaussianMixture
