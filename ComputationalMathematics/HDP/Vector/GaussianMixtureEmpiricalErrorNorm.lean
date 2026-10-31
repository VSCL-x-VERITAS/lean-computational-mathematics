import ComputationalMathematics.Analysis.OperatorNorms.RealComplexification
import ComputationalMathematics.HDP.Vector.GaussianMixtureEmpiricalDecomposition

/-!
# Ordinary empirical covariance error bounds from the exact decomposition.

These ordinary results reuse the actual latent model and earlier producers.
No author convention, Source target or printed sample commitment is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators
namespace NumStability.HDP.Vector.GaussianMixture

/-- The deterministic empirical error pays a product of signal and average
signed-noise norms for each of its two cross terms. -/
theorem sampleCovariance_affine_sign_error_norm_le {m n : ℕ}
    (hm : 0 < m) (θ : Fin m → ℝ) (hθ : ∀ i, θ i ^ 2 = 1)
    (mean : Fin n → ℝ) (G : Fin m → Fin n → ℝ) :
    NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.Covariance.sampleCovariance
          (fun i j ↦ θ i * mean j + G i j) - (1 + vecMulVec mean mean)) ≤
      NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.Covariance.sampleCovariance G - 1) +
        2 * NumStability.vecNorm2 mean * NumStability.vecNorm2 (signedNoiseMean θ G) := by
  have hTriangle (A B : Matrix (Fin n) (Fin n) ℝ) :
      NumStability.realMatrixOperatorNorm (A + B) ≤
        NumStability.realMatrixOperatorNorm A + NumStability.realMatrixOperatorNorm B := by
    unfold NumStability.realMatrixOperatorNorm
    simpa [NumStability.realMatrixContinuousLinearMap] using
      norm_add_le (NumStability.realMatrixContinuousLinearMap A)
        (NumStability.realMatrixContinuousLinearMap B)
  have hRank (x y : Fin n → ℝ) :
      NumStability.realMatrixOperatorNorm (vecMulVec x y) ≤
        NumStability.vecNorm2 x * NumStability.vecNorm2 y := by
    have h := NumStability.realMatrixOperatorNorm_le_frobNormRect
      (fun i j ↦ x i * y j)
    rw [NumStability.frobNormRect_outerProduct] at h
    exact h
  rw [sampleCovariance_affine_sign_sub_population hm θ hθ mean G]
  have hOne := hTriangle
    (NumStability.HDP.Vector.Covariance.sampleCovariance G - 1)
    (vecMulVec mean (signedNoiseMean θ G))
  have hTwo := hTriangle
    ((NumStability.HDP.Vector.Covariance.sampleCovariance G - 1) +
      vecMulVec mean (signedNoiseMean θ G))
    (vecMulVec (signedNoiseMean θ G) mean)
  have hRankA := hRank mean (signedNoiseMean θ G)
  have hRankB := hRank (signedNoiseMean θ G) mean
  nlinarith


/-- The same bound applies almost surely to the actual latent Gaussian model;
the almost-sure sign support is reused from its existing canonical law. -/
theorem canonicalSampleCovariance_error_norm_le_ae {m n : ℕ}
    (hm : 0 < m) (mean : Fin n → ℝ) :
    ∀ᵐ ω ∂latentNoiseSampleMeasure m n,
      NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalPoint mean ω) -
            (1 + vecMulVec mean mean)) ≤
        NumStability.realMatrixOperatorNorm
            (NumStability.HDP.Vector.Covariance.sampleCovariance (canonicalNoise ω) - 1) +
          2 * NumStability.vecNorm2 mean *
            NumStability.vecNorm2 (signedNoiseMean (canonicalLabel ω) (canonicalNoise ω)) := by
  filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
  have hs : ∀ i, canonicalLabel ω i ^ 2 = 1 := by
    intro i
    rcases hω i with hi | hi <;> rw [hi] <;> norm_num
  simpa only [canonicalPoint, mixtureMap, canonicalLabel, canonicalNoise] using
    sampleCovariance_affine_sign_error_norm_le hm (canonicalLabel ω) hs mean (canonicalNoise ω)

end NumStability.HDP.Vector.GaussianMixture
