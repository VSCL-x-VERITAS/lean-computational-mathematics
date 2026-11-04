import ComputationalMathematics.HDP.Vector.GaussianMixtureProjectionBudgets

/-!
# Explicit quadratic sample condition for the estimated partition

One absolute constant suffices for all dimensions, sample sizes, mean vectors
and positive error fractions at most one. This ordinary composition preserves
the existing canonical law and clipped-amplitude partition rule; source
selector, measure and error-count conventions remain separate audit questions.
-/
noncomputable section
open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- An absolute quadratic sample constant and explicit logarithmic signal threshold
give the existing four-exponential estimated-partition tail. -/
theorem exists_canonicalEstimatedScale_partition_four_exp_tail_of_numerical_budgets :
    ∃ K : ℝ, 0 < K ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ) (ε : ℝ), 0 < ε → ε ≤ 1 →
          64 * Real.log (16 / ε) ≤ NumStability.vecNorm2 mean ^ 2 →
          K * (n : ℝ) ≤ ε ^ 2 * (m : ℝ) →
          (latentNoiseSampleMeasure m n).real
            {ω |
              let X : Fin m → Fin n → ℝ := fun i ↦ canonicalPoint mean ω i
              let a := Real.sqrt (max
                (NumStability.hermitianOrderedEigenvalue
                  (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
                  ⟨0, hn⟩ - 1) 0)
              ¬ MakesAtMostPartitionErrorsUpToSwap
                (fun i ↦ canonicalLabel ω i)
                (a • (fun j ↦
                  NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X j))
                X (ε * m)} ≤ 4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, htail⟩ :=
    exists_canonicalEstimatedScale_partition_four_exp_tail_of_projection_thresholds
  let K : ℝ := max ((4096 * C) ^ 2) 8
  refine ⟨K, lt_of_lt_of_le (by norm_num : (0 : ℝ) < 8) (le_max_right _ _), ?_⟩
  intro m n hm hn mean ε hε hεone hsignal hsample
  let r := NumStability.vecNorm2 mean
  have hr0 : 0 ≤ r := NumStability.vecNorm2_nonneg mean
  have hloglower : 1 - ε / 16 ≤ Real.log (16 / ε) := by
    simpa only [inv_div] using
      Real.one_sub_inv_le_log_of_pos (div_pos (by norm_num : (0 : ℝ) < 16) hε)
  have hr2 : 1 ≤ r ^ 2 := by dsimp [r]; nlinarith
  have hr : 1 ≤ r := by nlinarith
  have hmean : 0 < NumStability.vecNorm2 mean := lt_of_lt_of_le zero_lt_one hr
  have hsampleCov : (4096 * C) ^ 2 * (n : ℝ) ≤ ε ^ 2 * (m : ℝ) :=
    (mul_le_mul_of_nonneg_right (le_max_left _ _) (Nat.cast_nonneg n)).trans hsample
  have hsampleIdeal : 8 * (n : ℝ) ≤ ε ^ 2 * (m : ℝ) :=
    (mul_le_mul_of_nonneg_right (le_max_right _ _) (Nat.cast_nonneg n)).trans hsample
  let δ := C * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
    Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
  have hδ : 0 ≤ δ := by dsimp [δ]; positivity
  have hδsmall : δ ≤ ε / 2048 :=
    covariance_delta_le_of_squared_sample_budget hm C ε hC.le hε hsampleCov
  have hbudgets := projection_budget_and_small_error_of_delta_le r ε δ
    hr hε hεone hδ hδsmall
  have hidealRate : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) ≤ ε / 4 :=
    ideal_margin_rate_le_quarter_of_log_signal_budget _ ε hε hsignal
  have hidealScale : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < ε / 2 :=
    lt_of_le_of_lt hidealRate (by linarith)
  have hidealTail : Real.exp (-2 * (m : ℝ) *
      (ε / 2 - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
        2 * Real.exp (-(n : ℝ)) := by
    calc
      _ ≤ Real.exp (-(n : ℝ)) :=
        ideal_count_exp_tail_le_of_squared_sample_budget ε _ hε hidealRate hsampleIdeal
      _ ≤ _ := by nlinarith [Real.exp_pos (-(n : ℝ))]
  exact htail hm hn mean hmean ε hidealScale hbudgets.2.1 hidealTail hbudgets.2.2

end NumStability.HDP.Vector.GaussianMixture
