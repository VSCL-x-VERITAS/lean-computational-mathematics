import ComputationalMathematics.HDP.Vector.GaussianMixtureEmpiricalErrorNorm
import ComputationalMathematics.HDP.Vector.GaussianMixtureNoiseCovarianceTail
import ComputationalMathematics.HDP.Vector.GaussianMixtureSignedNoiseAverage

/-!
# Ordinary dependent signal/noise covariance tails with explicit confidence allocation.

These ordinary results reuse the actual latent model and earlier producers.
No author convention, Source target or printed sample commitment is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators
namespace NumStability.HDP.Vector.GaussianMixture

/-- The actual empirical covariance error has a signal-linear cross-term
budget. The two empirical bad events are combined without independence. -/
theorem exists_canonicalSampleCovarianceDeviation_signal_noise_tail :
    ∃ C D : ℝ, 0 < C ∧ 0 < D ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        ∀ (mean : Fin n → ℝ) {t : ℝ}, 0 ≤ t →
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          let r : ℝ := D * (Real.sqrt (n : ℝ) + t) / Real.sqrt (m : ℝ)
          (latentNoiseSampleMeasure m n).real
              {ω | 4 * max delta (delta ^ 2) + 2 * NumStability.vecNorm2 mean * r <
                NumStability.realMatrixOperatorNorm
                  (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalPoint mean ω) -
                    (1 + vecMulVec mean mean))} ≤
            4 * Real.exp (-(t ^ 2)) := by
  obtain ⟨C, hC, hCovariance⟩ := exists_canonicalNoise_sampleCovarianceDeviation_tail
  obtain ⟨D, hD, hAverage⟩ := exists_canonicalSignedNoise_average_norm_tail
  refine ⟨C, D, hC, hD, ?_⟩
  intro m n hm hn mean t ht
  dsimp only
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let delta : ℝ := C *
    (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
  let r : ℝ := D * (Real.sqrt (n : ℝ) + t) / Real.sqrt (m : ℝ)
  let noiseBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | 4 * max delta (delta ^ 2) <
      NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalNoise ω) - 1)}
  let averageBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | r < NumStability.vecNorm2
      (signedNoiseMean (canonicalLabel ω) (canonicalNoise ω))}
  let failure : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | 4 * max delta (delta ^ 2) + 2 * NumStability.vecNorm2 mean * r <
      NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalPoint mean ω) -
          (1 + vecMulVec mean mean))}
  have hNoiseTail : μ.real noiseBad ≤ 2 * Real.exp (-(t ^ 2)) := by
    simpa only [μ, noiseBad, delta] using hCovariance hm hn ht
  have hAverageTail : μ.real averageBad ≤ 2 * Real.exp (-(t ^ 2)) := by
    simpa only [μ, averageBad, r, signedNoiseMean] using hAverage hm hn ht
  have hSubset : ∀ᵐ ω ∂μ, ω ∈ failure → ω ∈ noiseBad ∪ averageBad := by
    filter_upwards [canonicalSampleCovariance_error_norm_le_ae hm mean] with ω hω
    intro hf
    by_contra hout
    change ¬(ω ∈ noiseBad ∨ ω ∈ averageBad) at hout
    rcases not_or.mp hout with ⟨hNoise, hAverage⟩
    change ¬(4 * max delta (delta ^ 2) <
      NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalNoise ω) - 1)) at hNoise
    change ¬(r < NumStability.vecNorm2
      (signedNoiseMean (canonicalLabel ω) (canonicalNoise ω))) at hAverage
    have hNoiseLe := le_of_not_gt hNoise
    have hAverageLe := le_of_not_gt hAverage
    have hCrossLe := mul_le_mul_of_nonneg_left hAverageLe
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ 2) (NumStability.vecNorm2_nonneg mean))
    have hBound := hω.trans (add_le_add hNoiseLe hCrossLe)
    exact (not_lt_of_ge hBound) hf
  change μ.real failure ≤ _
  calc
    μ.real failure ≤ μ.real (noiseBad ∪ averageBad) := by
      exact ENNReal.toReal_mono (measure_ne_top _ _) (measure_mono_ae hSubset)
    _ ≤ μ.real noiseBad + μ.real averageBad := measureReal_union_le _ _
    _ ≤ 2 * Real.exp (-(t ^ 2)) + 2 * Real.exp (-(t ^ 2)) :=
      add_le_add hNoiseTail hAverageTail
    _ = 4 * Real.exp (-(t ^ 2)) := by ring


/-- Choosing deviation sqrt(2n) pays at most 2*exp(-n) for the whole
covariance bad event, leaving the separate ideal event its existing budget. -/
theorem exists_canonicalSampleCovarianceDeviation_signal_noise_dimension_tail :
    ∃ C D : ℝ, 0 < C ∧ 0 < D ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        ∀ (mean : Fin n → ℝ),
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) +
              Real.sqrt (2 * (n : ℝ)) / Real.sqrt (m : ℝ))
          let r : ℝ := D *
            (Real.sqrt (n : ℝ) + Real.sqrt (2 * (n : ℝ))) / Real.sqrt (m : ℝ)
          (latentNoiseSampleMeasure m n).real
              {ω | 4 * max delta (delta ^ 2) + 2 * NumStability.vecNorm2 mean * r <
                NumStability.realMatrixOperatorNorm
                  (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalPoint mean ω) -
                    (1 + vecMulVec mean mean))} ≤
            2 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, D, hC, hD, hTail⟩ :=
    exists_canonicalSampleCovarianceDeviation_signal_noise_tail
  refine ⟨C, D, hC, hD, ?_⟩
  intro m n hm hn mean
  have hRaw := hTail hm hn mean
    (t := Real.sqrt (2 * (n : ℝ))) (Real.sqrt_nonneg _)
  rw [Real.sq_sqrt (by positivity : 0 ≤ 2 * (n : ℝ))] at hRaw
  have hnR : 1 ≤ (n : ℝ) := by exact_mod_cast hn
  have hExp : (2 : ℝ) ≤ Real.exp (n : ℝ) := by
    linarith [Real.add_one_le_exp (n : ℝ)]
  have hFactor : Real.exp (-(2 * (n : ℝ))) * Real.exp (n : ℝ) =
      Real.exp (-(n : ℝ)) := by
    rw [← Real.exp_add]
    congr 1
    ring
  have hRate : 4 * Real.exp (-(2 * (n : ℝ))) ≤ 2 * Real.exp (-(n : ℝ)) := by
    calc
      4 * Real.exp (-(2 * (n : ℝ))) =
          (2 * Real.exp (-(2 * (n : ℝ)))) * 2 := by ring
      _ ≤ (2 * Real.exp (-(2 * (n : ℝ)))) * Real.exp (n : ℝ) :=
        mul_le_mul_of_nonneg_left hExp (by positivity)
      _ = 2 * Real.exp (-(n : ℝ)) := by rw [mul_assoc, hFactor]
  exact hRaw.trans hRate

end NumStability.HDP.Vector.GaussianMixture
