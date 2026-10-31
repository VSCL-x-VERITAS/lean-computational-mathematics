import ComputationalMathematics.HDP.Vector.GaussianMixtureFixedConfidenceBudgetAssembly

/-!
# Absolute sample constant for a fixed-confidence partition certificate

This ordinary theorem specializes the existing covariance tail at three square
roots of the dimension. No printed source theorem is selected here.
-/
noncomputable section
open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- One absolute quadratic sample constant suffices for a measurable 99%
certificate for the actual unit leading eigenvector's partition. -/
theorem exists_measurable_actualUnit_partition_certificate_of_numerical_budgets :
    ∃ K : ℝ, 0 < K ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ),
          1 ≤ NumStability.vecNorm2 mean →
          64 * Real.log (1600 : ℝ) ≤ NumStability.vecNorm2 mean ^ 2 →
          K * (n : ℝ) ≤ ((1 : ℝ) / 100) ^ 2 * (m : ℝ) →
          ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
            MeasurableSet good ∧
            (∀ ω ∈ good, MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ canonicalLabel ω i)
              (fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn
                (fun i ↦ canonicalPoint mean ω i) j)
              (fun i ↦ canonicalPoint mean ω i) ((1 : ℝ) / 100 * m)) ∧
            (99 : ℝ) / 100 < (latentNoiseSampleMeasure m n).real good := by
  obtain ⟨C, hC, htail⟩ := exists_canonicalSampleCovarianceDeviation_tail
  let C' := 2 * C
  let K : ℝ := max ((4096 * C') ^ 2) 72
  refine ⟨K, lt_of_lt_of_le (by norm_num : (0 : ℝ) < 72) (le_max_right _ _), ?_⟩
  intro m n hm hn mean hr hsignal hsample
  have hsampleCov : (4096 * C') ^ 2 * (n : ℝ) ≤
      ((1 : ℝ) / 100) ^ 2 * (m : ℝ) :=
    (mul_le_mul_of_nonneg_right (le_max_left _ _) (Nat.cast_nonneg n)).trans hsample
  have hsampleIdeal : 72 * (n : ℝ) ≤
      ((1 : ℝ) / 100) ^ 2 * (m : ℝ) :=
    (mul_le_mul_of_nonneg_right (le_max_right _ _) (Nat.cast_nonneg n)).trans hsample
  let δ : ℝ := C' * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
    Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
  have hδ : 0 ≤ δ := by dsimp [δ, C']; positivity
  have hδsmall : δ ≤ (1 : ℝ) / 100 / 2048 :=
    covariance_delta_le_of_squared_sample_budget hm C' ((1 : ℝ) / 100)
      (by dsimp [C']; positivity) (by norm_num) hsampleCov
  have hcovariance : (latentNoiseSampleMeasure m n).real
      {ω | (2 * (NumStability.vecNorm2 mean + 1)) ^ 2 * max δ (δ ^ 2) <
        NumStability.realMatrixOperatorNorm
          (EuclideanSpectralClustering.sampleSecondMoment
            (fun i ↦ canonicalPoint mean ω i) - populationSecondMoment mean)} ≤
        2 * Real.exp (-9 * (n : ℝ)) := by
    have hraw := htail hm hn mean (t := 3 * Real.sqrt (n : ℝ)) (by positivity)
    have hsqrt : Real.sqrt ((n : ℝ) / (m : ℝ)) =
        Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ) :=
      Real.sqrt_div (Nat.cast_nonneg n) _
    have hdelta : C * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
        (3 * Real.sqrt (n : ℝ)) / Real.sqrt (m : ℝ)) = δ := by
      dsimp [δ, C']
      rw [hsqrt]
      ring
    have htSquare : (3 * Real.sqrt (n : ℝ)) ^ 2 = 9 * (n : ℝ) := by
      rw [mul_pow, Real.sq_sqrt (Nat.cast_nonneg n)]
      ring
    simpa only [EuclideanSpectralClustering.sampleSecondMoment,
      NumStability.HDP.Vector.Covariance.randomSampleCovariance,
      hdelta, htSquare, neg_mul] using hraw
  exact exists_measurable_actualUnit_partition_certificate_of_fixed_confidence_budgets
    hm hn mean hr hsignal δ hδ hδsmall hsampleIdeal hcovariance

/-- A single absolute threshold controls both the sample size and signal norm
for the ordinary measurable certificate. -/
theorem exists_measurable_actualUnit_partition_certificate_of_one_threshold :
    ∃ A : ℝ, 0 < A ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ),
          A ≤ NumStability.vecNorm2 mean →
          A * (n : ℝ) ≤ (m : ℝ) →
          ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
            MeasurableSet good ∧
            (∀ ω ∈ good, MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ canonicalLabel ω i)
              (fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn
                (fun i ↦ canonicalPoint mean ω i) j)
              (fun i ↦ canonicalPoint mean ω i) ((1 : ℝ) / 100 * m)) ∧
            (99 : ℝ) / 100 < (latentNoiseSampleMeasure m n).real good := by
  obtain ⟨K, hK, hmain⟩ :=
    exists_measurable_actualUnit_partition_certificate_of_numerical_budgets
  let A : ℝ := max (10000 * K) (64 * Real.log (1600 : ℝ) + 1)
  refine ⟨A, lt_of_lt_of_le (by nlinarith : 0 < 10000 * K) (le_max_left _ _), ?_⟩
  intro m n hm hn mean hsignal hsample
  have hlog : 0 ≤ Real.log (1600 : ℝ) := Real.log_nonneg (by norm_num)
  have hsignalBound : 64 * Real.log (1600 : ℝ) + 1 ≤
      NumStability.vecNorm2 mean := (le_max_right _ _).trans hsignal
  have hr : 1 ≤ NumStability.vecNorm2 mean := by nlinarith
  have hrSignal : 64 * Real.log (1600 : ℝ) ≤
      NumStability.vecNorm2 mean ^ 2 := by
    have hnonneg : 0 ≤ NumStability.vecNorm2 mean := by nlinarith
    nlinarith
  have hKsample : K * (n : ℝ) ≤ ((1 : ℝ) / 100) ^ 2 * (m : ℝ) := by
    have hn0 : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
    have hlarge : 10000 * K * (n : ℝ) ≤ A * (n : ℝ) :=
      mul_le_mul_of_nonneg_right (le_max_left _ _) hn0
    nlinarith
  exact hmain hm hn mean hr hrSignal hKsample

end NumStability.HDP.Vector.GaussianMixture
