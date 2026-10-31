import ComputationalMathematics.HDP.Vector.GaussianMixtureConcentration

/-!
# Ordinary signal-free specialization of the existing covariance tail.

These ordinary results reuse the actual latent model and earlier producers.
No author convention, Source target or printed sample commitment is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators
namespace NumStability.HDP.Vector.GaussianMixture

/-- The actual canonical Gaussian noise covariance has the existing absolute
Gram-deviation tail, without a signal-dependent factor. -/
theorem exists_canonicalNoise_sampleCovarianceDeviation_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        ∀ {t : ℝ}, 0 ≤ t →
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          (latentNoiseSampleMeasure m n).real
              {ω | 4 * max delta (delta ^ 2) <
                NumStability.realMatrixOperatorNorm
                  (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalNoise ω) -
                    (1 : Matrix (Fin n) (Fin n) ℝ))} ≤
            2 * Real.exp (-(t ^ 2)) := by
  obtain ⟨C, hC, hTail⟩ := exists_canonicalSampleCovarianceDeviation_tail
  refine ⟨C, hC, ?_⟩
  intro m n hm hn t ht
  have h := hTail hm hn (0 : Fin n → ℝ) ht
  have hPoint : ∀ ω : Fin m → ℝ × (Fin n → ℝ),
      canonicalPoint (0 : Fin n → ℝ) ω = canonicalNoise ω := by
    intro ω
    funext i j
    simp [canonicalPoint, mixtureMap, canonicalNoise]
  have hPopulation : populationSecondMoment (0 : Fin n → ℝ) =
      (1 : Matrix (Fin n) (Fin n) ℝ) := by
    ext i j
    simp [populationSecondMoment]
  have hZero : NumStability.vecNorm2 (0 : Fin n → ℝ) = 0 :=
    NumStability.vecNorm2_zero
  dsimp only at h
  rw [hZero] at h
  norm_num only [zero_add, mul_one] at h
  simpa only [NumStability.HDP.Vector.Covariance.randomSampleCovariance,
    hPoint, hPopulation] using h

end NumStability.HDP.Vector.GaussianMixture
