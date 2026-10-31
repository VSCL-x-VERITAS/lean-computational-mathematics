import ComputationalMathematics.HDP.Vector.GaussianMixtureLinearPerturbation
import ComputationalMathematics.HDP.Vector.GaussianMixtureNoiseNormMargin
import ComputationalMathematics.HDP.Vector.GaussianMixtureSpectral

/-!
# Actual unit-top spectral classification through an explicit row-noise norm-margin budget.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- The actual unit-top direction inherits classification from explicit
operator perturbation, ideal-error and exceptional-noise count thresholds. -/
theorem makesAtMostErrorsUpToSign_leadingEigenvector_of_noise_norm_margin
    {m n : ℕ} (hn : 0 < n)
    (labels : Fin m → ℝ) (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (X Z : Fin m → Fin n → ℝ) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean)
    (hdecomposition : ∀ i, X i = labels i • mean + Z i)
    (epsilon tau radius q : ℝ) (hq : 0 ≤ q)
    (hdeviation : NumStability.realMatrixOperatorNorm
      (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean) ≤ q)
    (hmargin : (2 * Real.sqrt 2 * q / NumStability.vecNorm2 mean) *
      (NumStability.vecNorm2 mean + radius) < tau)
    (hideal : (Set.ncard (idealMarginErrors labels mean X tau) : ℝ) ≤ epsilon * m / 2)
    (hnoise : (Set.ncard {i | radius < NumStability.vecNorm2 (Z i)} : ℝ) ≤
      epsilon * m / 2) :
    MakesAtMostErrorsUpToSign labels
      (fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn X j) X
      (epsilon * m) := by
  let r := NumStability.vecNorm2 mean
  let T := EuclideanSpectralClustering.sampleSecondMoment X
  let e := NumStability.realMatrixOperatorNorm (T - populationSecondMoment mean)
  let v : Fin n → ℝ := fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn X j
  have hswap : NumStability.realMatrixOperatorNorm (populationSecondMoment mean - T) = e := by
    change NumStability.realMatrixOperatorNorm (populationSecondMoment mean - T) =
      NumStability.realMatrixOperatorNorm (T - populationSecondMoment mean)
    unfold NumStability.realMatrixOperatorNorm NumStability.realMatrixContinuousLinearMap
    simp only [map_sub]
    exact norm_sub_rev _ _
  obtain ⟨s, hs, hdist⟩ := exists_sign_mean_sub_scaledUnitTopEigenvector_le_linear
    hn mean hmean T (EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
    (EuclideanSpectralClustering.leadingEigenvector hn X)
    (EuclideanSpectralClustering.norm_leadingEigenvector hn X)
    (EuclideanSpectralClustering.sampleSecondMoment_apply_leadingEigenvector hn X)
  rw [hswap] at hdist
  have hvec : (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
      s • (r • EuclideanSpectralClustering.leadingEigenvector hn X) =
      WithLp.toLp 2 (mean - s • (r • v)) := by
    ext j
    rfl
  rw [hvec, Spherical.norm_toLp_eq_vecNorm2] at hdist
  change NumStability.vecNorm2 (mean - s • (r • v)) ≤ 2 * Real.sqrt 2 * e / r at hdist
  have hbound : NumStability.vecNorm2 (mean - s • (r • v)) ≤
      2 * Real.sqrt 2 * q / r :=
    hdist.trans (div_le_div_of_nonneg_right
      (mul_le_mul_of_nonneg_left hdeviation (by positivity)) hmean.le)
  have hscaled : MakesAtMostErrorsUpToSign labels (r • v) X (epsilon * m) :=
    makesAtMostErrorsUpToSign_of_margin_and_noise_norm
      labels mean (r • v) X Z s (2 * Real.sqrt 2 * q / r) tau epsilon radius
      hs hlabels hdecomposition (by positivity) hbound hmargin hideal hnoise
  exact (makesAtMostErrorsUpToSign_pos_smul_iff labels v X (epsilon * m) r hmean).mp hscaled

end NumStability.HDP.Vector.GaussianMixture
