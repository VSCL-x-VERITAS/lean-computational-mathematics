import ComputationalMathematics.HDP.Vector.GaussianMixtureProjectionMargin

/-! Ordinary dimension-free deterministic spectral transfer; source conventions remain open. -/
noncomputable section
open Matrix

namespace NumStability.HDP.Vector.GaussianMixture

/-- Covariance deviation controls spectral classification through a dimension-free budget. -/
theorem makesAtMostErrorsUpToSign_leadingEigenvector_of_projection_budget
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (labels : Fin m → ℝ) (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (ε τ q : ℝ)
    (hτ : 0 < τ) (hq : 0 ≤ q)
    (hdeviation : NumStability.realMatrixOperatorNorm
      (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean) ≤ q)
    (hideal : (Set.ncard (idealMarginErrors labels mean X τ) : ℝ) ≤ ε * m / 2)
    (hbudget : 4 * q * (1 + NumStability.vecNorm2 mean ^ 2 + q) ≤ ε / 2 * τ ^ 2) :
    MakesAtMostErrorsUpToSign labels
      (fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn X j) X (ε * m) := by
  let r := NumStability.vecNorm2 mean
  let e := NumStability.realMatrixOperatorNorm
    (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean)
  let v : Fin n → ℝ := fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn X j
  obtain ⟨s, hs, hdist⟩ := exists_sign_mean_sub_scaledLeadingEigenvector_le hn mean hmean X
  have hvec : (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
      s • (r • EuclideanSpectralClustering.leadingEigenvector hn X) =
      WithLp.toLp 2 (mean - s • (r • v)) := by
    ext j
    rfl
  rw [hvec, Spherical.norm_toLp_eq_vecNorm2] at hdist
  change NumStability.vecNorm2 (mean - s • (r • v)) ≤ 2 * Real.sqrt e at hdist
  have he : 0 ≤ e := norm_nonneg _
  have heq : e ≤ q := hdeviation
  have hd : 0 ≤ NumStability.vecNorm2 (mean - s • (r • v)) := NumStability.vecNorm2_nonneg _
  have hroot : 0 ≤ 2 * Real.sqrt e := by positivity
  have hsq : NumStability.vecNorm2 (mean - s • (r • v)) ^ 2 ≤ 4 * q := by
    nlinarith [Real.sq_sqrt he]
  have hcoefficient : 1 + r ^ 2 + e ≤ 1 + r ^ 2 + q := by linarith
  have hcoefficient_nonneg : 0 ≤ 1 + r ^ 2 + q := by positivity
  have hactual : (1 + r ^ 2 + e) * NumStability.vecNorm2 (mean - s • (r • v)) ^ 2 ≤
      ε / 2 * τ ^ 2 := by
    calc
      _ ≤ (1 + r ^ 2 + q) * (4 * q) :=
        mul_le_mul hcoefficient hsq (sq_nonneg _) hcoefficient_nonneg
      _ ≤ _ := by nlinarith [hbudget]
  have hscaled : MakesAtMostErrorsUpToSign labels (r • v) X (ε * m) :=
    makesAtMostErrorsUpToSign_of_margin_and_projection_energy hm labels mean (r • v) X
      s τ ε hs hlabels hτ hideal hactual
  exact (makesAtMostErrorsUpToSign_pos_smul_iff labels v X (ε * m) r hmean).mp hscaled

end NumStability.HDP.Vector.GaussianMixture
