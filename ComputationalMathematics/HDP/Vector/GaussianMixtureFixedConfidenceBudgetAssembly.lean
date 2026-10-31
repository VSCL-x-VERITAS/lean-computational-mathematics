import ComputationalMathematics.HDP.Vector.GaussianMixtureFixedConfidenceScalar

/-!
# Fixed-confidence certificate from covariance and sample budgets

This ordinary result combines the actual-unit-direction event certificate with
the scalar one-percent tail bound. It selects no printed source claim.
-/
noncomputable section
open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- A small covariance parameter, logarithmic signal budget, and fixed
Hoeffding sample budget give a measurable 99% partition certificate. -/
theorem exists_measurable_actualUnit_partition_certificate_of_fixed_confidence_budgets
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (mean : Fin n → ℝ)
    (hr : 1 ≤ NumStability.vecNorm2 mean)
    (hsignal : 64 * Real.log (1600 : ℝ) ≤ NumStability.vecNorm2 mean ^ 2)
    (δ : ℝ) (hδ : 0 ≤ δ) (hδsmall : δ ≤ (1 : ℝ) / 100 / 2048)
    (hsample : 72 * (n : ℝ) ≤ ((1 : ℝ) / 100) ^ 2 * (m : ℝ))
    (hcovariance : (latentNoiseSampleMeasure m n).real
      {ω | (2 * (NumStability.vecNorm2 mean + 1)) ^ 2 * max δ (δ ^ 2) <
        NumStability.realMatrixOperatorNorm
          (EuclideanSpectralClustering.sampleSecondMoment
            (fun i ↦ canonicalPoint mean ω i) - populationSecondMoment mean)} ≤
          2 * Real.exp (-9 * (n : ℝ))) :
    ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
      MeasurableSet good ∧
      (∀ ω ∈ good, MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel ω i)
        (fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn
          (fun i ↦ canonicalPoint mean ω i) j)
        (fun i ↦ canonicalPoint mean ω i) ((1 : ℝ) / 100 * m)) ∧
      (99 : ℝ) / 100 < (latentNoiseSampleMeasure m n).real good := by
  let r := NumStability.vecNorm2 mean
  let q := (2 * (r + 1)) ^ 2 * max δ (δ ^ 2)
  have hmean : 0 < r := lt_of_lt_of_le zero_lt_one hr
  have hq : 0 ≤ q := by dsimp [q]; positivity
  have hbudgets := projection_budget_and_small_error_of_delta_le
    r ((1 : ℝ) / 100) δ hr (by norm_num) (by norm_num) hδ hδsmall
  have hidealRate : 4 * Real.exp (-(r ^ 2) / 64) ≤ (1 : ℝ) / 100 / 4 := by
    simpa only [r] using ideal_margin_rate_le_quarter_of_log_signal_budget
      r ((1 : ℝ) / 100) (by norm_num) (by norm_num [div_eq_mul_inv] at hsignal ⊢; exact hsignal)
  have hidealScale : 4 * Real.exp (-(r ^ 2) / 64) < (1 : ℝ) / 100 / 2 :=
    lt_of_le_of_lt hidealRate (by norm_num)
  have hsample9 : 8 * ((9 * n : ℕ) : ℝ) ≤ ((1 : ℝ) / 100) ^ 2 * (m : ℝ) := by
    convert hsample using 1
    norm_num [Nat.cast_mul]
    ring
  have hidealTail : Real.exp (-2 * (m : ℝ) *
      ((1 : ℝ) / 100 / 2 - 4 * Real.exp (-(r ^ 2) / 64)) ^ 2) ≤
        Real.exp (-9 * (n : ℝ)) := by
    simpa [Nat.cast_mul, mul_assoc, r] using
      ideal_count_exp_tail_le_of_squared_sample_budget
        ((1 : ℝ) / 100) (4 * Real.exp (-(r ^ 2) / 64))
        (by norm_num) hidealRate hsample9
  obtain ⟨good, hmeas, hgood, hmass⟩ :=
    exists_measurable_actualUnit_partition_certificate_of_covariance_tail
      hm hn mean hmean ((1 : ℝ) / 100) q (2 * Real.exp (-9 * (n : ℝ)))
      hq hidealScale hbudgets.2.1 (by simpa [q, r] using hcovariance)
  refine ⟨good, hmeas, hgood, ?_⟩
  have htail := three_exp_neg_nine_mul_dim_lt_one_percent n hn
  nlinarith

end NumStability.HDP.Vector.GaussianMixture
