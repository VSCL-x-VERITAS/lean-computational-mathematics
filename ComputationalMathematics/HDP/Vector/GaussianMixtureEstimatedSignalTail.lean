import ComputationalMathematics.HDP.Vector.GaussianMixtureEstimatedVector
import ComputationalMathematics.HDP.Vector.GaussianMixtureConcentration
import ComputationalMathematics.HDP.Vector.EuclideanSpectralClustering

/-!
# Estimated-signal deviation under the Gaussian sample law

The bound composes the existing covariance tail, unit empirical top selector,
and sign-aligned estimated-amplitude vector estimate. The constant and failure
probability are inherited from the covariance producer.
-/

open MeasureTheory

namespace NumStability.HDP.Vector.GaussianMixture

theorem exists_canonicalEstimatedSignalDeviation_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → ∀ (hn : 0 < n) (mean : Fin n → ℝ),
        0 < NumStability.vecNorm2 mean → ∀ {t : ℝ}, 0 ≤ t →
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          let q : ℝ := L ^ 2 * max delta (delta ^ 2)
          (latentNoiseSampleMeasure m n).real
            {ω |
              let X : Fin m → Fin n → ℝ := fun i ↦ canonicalPoint mean ω i
              let v := NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X
              let a := Real.sqrt (max
                (NumStability.hermitianOrderedEigenvalue
                  (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
                  ⟨0, hn⟩ - 1) 0)
              ¬ ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
                ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (a • v)‖ ≤
                  (2 * Real.sqrt 2 + 1) * q / NumStability.vecNorm2 mean} ≤
            2 * Real.exp (-(t ^ 2)) := by
  obtain ⟨C, hC, hcovariance⟩ := exists_canonicalSampleCovarianceDeviation_tail
  refine ⟨C, hC, ?_⟩
  intro m n hm hn mean hmean t ht
  dsimp only
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
    {ω | ¬ ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
      ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
        s • (Real.sqrt (max
          (NumStability.hermitianOrderedEigenvalue
            (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian (X ω))
            ⟨0, hn⟩ - 1) 0) •
          NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn (X ω))‖ ≤
        (2 * Real.sqrt 2 + 1) * q / NumStability.vecNorm2 mean}
  change μ.real failure ≤ 2 * Real.exp (-(t ^ 2))
  have hcovarianceTail : μ.real covarianceBad ≤ 2 * Real.exp (-(t ^ 2)) := by
    simpa [μ, covarianceBad, q, delta, L, X,
      NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment,
      NumStability.HDP.Vector.Covariance.randomSampleCovariance] using
        (hcovariance hm hn mean (t := t) ht)
  have hcoefficient : 0 ≤ 2 * Real.sqrt 2 + 1 := by positivity
  have hsubset : failure ⊆ covarianceBad := by
    intro ω hfailure
    by_contra hnot
    have hdeviation :
        NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
            populationSecondMoment mean) ≤ q := le_of_not_gt hnot
    obtain ⟨s, hs, hdist⟩ :=
      exists_sign_mean_sub_spectralAmplitudeTopEigenvector_le hn mean hmean
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω))
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian (X ω))
        (NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn (X ω))
        (NumStability.HDP.Vector.EuclideanSpectralClustering.norm_leadingEigenvector hn (X ω))
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_apply_leadingEigenvector hn (X ω))
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
    rw [hswap] at hdist
    exact hfailure ⟨s, hs, hdist.trans
      (div_le_div_of_nonneg_right
        (mul_le_mul_of_nonneg_left hdeviation hcoefficient) hmean.le)⟩
  exact (measureReal_mono hsubset (measure_ne_top _ _)).trans hcovarianceTail

end NumStability.HDP.Vector.GaussianMixture
