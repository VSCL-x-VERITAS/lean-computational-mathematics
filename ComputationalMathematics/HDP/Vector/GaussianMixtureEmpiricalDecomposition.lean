import ComputationalMathematics.HDP.Vector.CovarianceEstimation
import ComputationalMathematics.HDP.Vector.GaussianMixtureIdeal

/-!
# Ordinary empirical signal/noise decomposition

This deterministic identity uses the existing uncentered empirical covariance.
It specifies its sign and sample-size hypotheses explicitly and selects no
author convention or Gaussian probability claim.
-/

noncomputable section

open Matrix MeasureTheory
open scoped BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- The empirical average of sign-weighted noise vectors. -/
def signedNoiseMean {m n : ℕ} (θ : Fin m → ℝ) (G : Fin m → Fin n → ℝ) :
    Fin n → ℝ := fun j ↦ (m : ℝ)⁻¹ * ∑ i, θ i * G i j

/-- The empirical signal covariance is exact when every sign has square one;
all remaining terms are the noise covariance and two signal/noise cross terms. -/
theorem sampleCovariance_affine_sign_decomposition {m n : ℕ}
    (hm : 0 < m) (θ : Fin m → ℝ) (hθ : ∀ i, θ i ^ 2 = 1)
    (mean : Fin n → ℝ) (G : Fin m → Fin n → ℝ) :
    NumStability.HDP.Vector.Covariance.sampleCovariance
        (fun i j ↦ θ i * mean j + G i j) =
      vecMulVec mean mean +
        vecMulVec mean (signedNoiseMean θ G) +
        vecMulVec (signedNoiseMean θ G) mean +
        NumStability.HDP.Vector.Covariance.sampleCovariance G := by
  have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hm)
  ext a b
  have hexpand (i : Fin m) :
      (θ i * mean a + G i a) * (θ i * mean b + G i b) =
        mean a * mean b + mean a * (θ i * G i b) +
          (θ i * G i a) * mean b + G i a * G i b := by
    calc
      _ = θ i ^ 2 * (mean a * mean b) + mean a * (θ i * G i b) +
          (θ i * G i a) * mean b + G i a * G i b := by ring
      _ = _ := by rw [hθ i, one_mul]
  simp only [NumStability.HDP.Vector.Covariance.sampleCovariance,
    Matrix.add_apply, vecMulVec_apply, signedNoiseMean]
  simp_rw [hexpand]
  simp only [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ,
    Fintype.card_fin, nsmul_eq_mul]
  rw [← Finset.mul_sum, ← Finset.sum_mul]
  field_simp

/-- Subtracting the population signal-plus-identity matrix leaves only
Gaussian noise fluctuation and the two empirical cross terms. -/
theorem sampleCovariance_affine_sign_sub_population {m n : ℕ}
    (hm : 0 < m) (θ : Fin m → ℝ) (hθ : ∀ i, θ i ^ 2 = 1)
    (mean : Fin n → ℝ) (G : Fin m → Fin n → ℝ) :
    NumStability.HDP.Vector.Covariance.sampleCovariance
        (fun i j ↦ θ i * mean j + G i j) - (1 + vecMulVec mean mean) =
      NumStability.HDP.Vector.Covariance.sampleCovariance G - 1 +
        vecMulVec mean (signedNoiseMean θ G) +
        vecMulVec (signedNoiseMean θ G) mean := by
  rw [sampleCovariance_affine_sign_decomposition hm θ hθ mean G]
  abel


/-- Under the canonical latent law the empirical signal/noise identity holds
almost surely. The sign support comes from the existing canonical model. -/
theorem canonicalSampleCovariance_signal_noise_ae {m n : ℕ}
    (hm : 0 < m) (mean : Fin n → ℝ) :
    ∀ᵐ ω ∂latentNoiseSampleMeasure m n,
      NumStability.HDP.Vector.Covariance.sampleCovariance
          (canonicalPoint mean ω) =
        vecMulVec mean mean +
          vecMulVec mean (signedNoiseMean (canonicalLabel ω) (canonicalNoise ω)) +
          vecMulVec (signedNoiseMean (canonicalLabel ω) (canonicalNoise ω)) mean +
          NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalNoise ω) := by
  filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
  have hs : ∀ i, canonicalLabel ω i ^ 2 = 1 := by
    intro i
    rcases hω i with hi | hi <;> rw [hi] <;> norm_num
  simpa only [canonicalPoint, mixtureMap, canonicalLabel, canonicalNoise] using
    sampleCovariance_affine_sign_decomposition hm
      (canonicalLabel ω) hs mean (canonicalNoise ω)

/-- The canonical empirical error is noise fluctuation plus two cross terms
almost surely, with no empirical signal fluctuation. -/
theorem canonicalSampleCovariance_sub_population_ae {m n : ℕ}
    (hm : 0 < m) (mean : Fin n → ℝ) :
    ∀ᵐ ω ∂latentNoiseSampleMeasure m n,
      NumStability.HDP.Vector.Covariance.sampleCovariance
          (canonicalPoint mean ω) - (1 + vecMulVec mean mean) =
        NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalNoise ω) - 1 +
          vecMulVec mean (signedNoiseMean (canonicalLabel ω) (canonicalNoise ω)) +
          vecMulVec (signedNoiseMean (canonicalLabel ω) (canonicalNoise ω)) mean := by
  filter_upwards [canonicalSampleCovariance_signal_noise_ae hm mean] with ω hω
  rw [hω]
  abel

end NumStability.HDP.Vector.GaussianMixture

