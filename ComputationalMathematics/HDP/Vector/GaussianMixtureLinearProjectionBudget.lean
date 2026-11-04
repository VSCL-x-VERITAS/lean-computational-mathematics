import ComputationalMathematics.HDP.Vector.GaussianMixtureLinearPerturbation
import ComputationalMathematics.HDP.Vector.GaussianMixtureProjectionSpectral

/-!
# Linear unit-top direction transfer through the existing projection-energy budget.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- The existing linear unit-top perturbation estimate sharpens the deterministic
projection budget to a quadratic operator error divided by the signal norm squared. -/
theorem makesAtMostErrorsUpToSign_leadingEigenvector_of_linear_projection_budget
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (labels : Fin m → ℝ) (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (ε τ q : ℝ)
    (hτ : 0 < τ) (hq : 0 ≤ q)
    (hdeviation : NumStability.realMatrixOperatorNorm
      (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean) ≤ q)
    (hideal : (Set.ncard (idealMarginErrors labels mean X τ) : ℝ) ≤ ε * m / 2)
    (hbudget : (8 * q ^ 2 / NumStability.vecNorm2 mean ^ 2) *
      (1 + NumStability.vecNorm2 mean ^ 2 + q) ≤ ε / 2 * τ ^ 2) :
    MakesAtMostErrorsUpToSign labels
      (fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn X j) X (ε * m) := by
  let r := NumStability.vecNorm2 mean
  let T := EuclideanSpectralClustering.sampleSecondMoment X
  let e := NumStability.realMatrixOperatorNorm (T - populationSecondMoment mean)
  let v : Fin n → ℝ := fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn X j
  have hr : 0 < r := hmean
  have he : 0 ≤ e := norm_nonneg _
  have heq : e ≤ q := hdeviation
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
  have hd : 0 ≤ NumStability.vecNorm2 (mean - s • (r • v)) := NumStability.vecNorm2_nonneg _
  have hroot : 0 ≤ 2 * Real.sqrt 2 * e / r := by positivity
  have heqsq : e ^ 2 ≤ q ^ 2 := (sq_le_sq₀ he hq).mpr heq
  have hsq : NumStability.vecNorm2 (mean - s • (r • v)) ^ 2 ≤ 8 * q ^ 2 / r ^ 2 := by
    calc
      _ ≤ (2 * Real.sqrt 2 * e / r) ^ 2 := (sq_le_sq₀ hd hroot).mpr hdist
      _ = 8 * e ^ 2 / r ^ 2 := by
        rw [div_pow, mul_pow, mul_pow, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
        ring
      _ ≤ _ := div_le_div_of_nonneg_right
        (mul_le_mul_of_nonneg_left heqsq (by norm_num)) (sq_nonneg r)
  have hcoefficient : 1 + r ^ 2 + e ≤ 1 + r ^ 2 + q := by linarith
  have hcoefficient_nonneg : 0 ≤ 1 + r ^ 2 + q := by positivity
  have hactual : (1 + r ^ 2 + e) * NumStability.vecNorm2 (mean - s • (r • v)) ^ 2 ≤
      ε / 2 * τ ^ 2 := by
    calc
      _ ≤ (1 + r ^ 2 + q) * (8 * q ^ 2 / r ^ 2) :=
        mul_le_mul hcoefficient hsq (sq_nonneg _) hcoefficient_nonneg
      _ ≤ _ := by simpa only [mul_comm] using hbudget
  have hscaled : MakesAtMostErrorsUpToSign labels (r • v) X (ε * m) :=
    makesAtMostErrorsUpToSign_of_margin_and_projection_energy hm labels mean (r • v) X
      s τ ε hs hlabels hτ hideal hactual
  exact (makesAtMostErrorsUpToSign_pos_smul_iff labels v X (ε * m) r hmean).mp hscaled

end NumStability.HDP.Vector.GaussianMixture
