import ComputationalMathematics.HDP.Vector.GaussianMixturePositiveScaling
import ComputationalMathematics.HDP.Vector.GaussianMixtureConcentration
import ComputationalMathematics.HDP.Vector.EuclideanSpectralClustering

/-!
# Nonpositive empirical amplitude in the Gaussian mixture

A strict covariance-error threshold controls failure of positivity of the
clipped empirical spectral amplitude, using the existing covariance tail
constant and its two-exponential probability bound.
-/

open MeasureTheory

namespace NumStability.HDP.Vector.GaussianMixture

theorem exists_canonicalSpectralAmplitude_nonpositive_tail_of_threshold :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → ∀ (hn : 0 < n) (mean : Fin n → ℝ),
        0 < NumStability.vecNorm2 mean → ∀ {t : ℝ}, 0 ≤ t →
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          let q : ℝ := L ^ 2 * max delta (delta ^ 2)
          q < NumStability.vecNorm2 mean ^ 2 →
          (latentNoiseSampleMeasure m n).real
            {ω |
              let X : Fin m → Fin n → ℝ := fun i ↦ canonicalPoint mean ω i
              Real.sqrt (max
                (NumStability.hermitianOrderedEigenvalue
                  (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
                  ⟨0, hn⟩ - 1) 0) ≤ 0} ≤ 2 * Real.exp (-(t ^ 2)) := by
  obtain ⟨C, hC, hcovariance⟩ := exists_canonicalSampleCovarianceDeviation_tail
  refine ⟨C, hC, ?_⟩
  intro m n hm hn mean hmean t ht
  dsimp only
  intro hsmall
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let X : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → Fin n → ℝ :=
    fun ω i ↦ canonicalPoint mean ω i
  let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
  let delta : ℝ := C *
    (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
  let q : ℝ := L ^ 2 * max delta (delta ^ 2)
  let covarianceBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | q < NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
        populationSecondMoment mean)}
  let failure : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | Real.sqrt (max
      (NumStability.hermitianOrderedEigenvalue
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian (X ω))
        ⟨0, hn⟩ - 1) 0) ≤ 0}
  change μ.real failure ≤ 2 * Real.exp (-(t ^ 2))
  have hcovarianceTail : μ.real covarianceBad ≤ 2 * Real.exp (-(t ^ 2)) := by
    simpa [μ, covarianceBad, q, delta, L, X,
      NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment,
      NumStability.HDP.Vector.Covariance.randomSampleCovariance] using
        (hcovariance hm hn mean (t := t) ht)
  have hsubset : failure ⊆ covarianceBad := by
    intro ω hfailure
    by_contra hnot
    have hdeviation :
        NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
            populationSecondMoment mean) ≤ q := le_of_not_gt hnot
    have hswap :
        NumStability.realMatrixOperatorNorm
          (populationSecondMoment mean -
            NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω)) =
        NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
            populationSecondMoment mean) := by
      unfold NumStability.realMatrixOperatorNorm NumStability.realMatrixContinuousLinearMap
      simp only [map_sub]
      exact norm_sub_rev _ _
    have herror :
        NumStability.realMatrixOperatorNorm
          (populationSecondMoment mean -
            NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω)) <
          NumStability.vecNorm2 mean ^ 2 := by
      rw [hswap]
      exact hdeviation.trans_lt hsmall
    have hpositive := spectralAmplitude_pos_of_operatorError_lt_meanNorm_sq
      hn mean hmean
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω))
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian (X ω))
      herror
    exact not_lt_of_ge hfailure hpositive
  exact (measureReal_mono hsubset (measure_ne_top _ _)).trans hcovarianceTail

end NumStability.HDP.Vector.GaussianMixture
