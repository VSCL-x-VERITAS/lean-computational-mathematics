import ComputationalMathematics.HDP.Vector.GaussianMixturePolynomialBudgets

/-!
# Ordinary polynomial sufficient budgets for the estimated partition

The latent binary labels give an unconditional half-error guarantee for every
direction. Below one half, the existing numerical tail and scalar budget
conversions give a single absolute polynomial sample constant. This is a
separately labelled sufficient result; the 2018 printed sample condition and
its source conventions remain separate.
-/
noncomputable section
open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- Under the canonical binary-label law, any possibly sample-dependent
direction has a null partition-failure event at error tolerance at least half.
No measurability assumption on the direction is needed for this null event. -/
theorem canonical_partition_failure_measure_zero_of_half_le
    {m n : ℕ} (mean : Fin n → ℝ)
    (direction : (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ)
    (ε : ℝ) (hhalf : 1 / 2 ≤ ε) :
    (latentNoiseSampleMeasure m n).real
      {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel ω i) (direction ω)
        (fun i ↦ canonicalPoint mean ω i) (ε * m)} = 0 := by
  have hzero : (latentNoiseSampleMeasure m n)
      {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel ω i) (direction ω)
        (fun i ↦ canonicalPoint mean ω i) (ε * m)} = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    exact not_not_intro
      (makesAtMostPartitionErrorsUpToSwap_of_half_le
        (fun i ↦ canonicalLabel ω i) (direction ω)
        (fun i ↦ canonicalPoint mean ω i) hω hhalf)
  rw [Measure.real_def, hzero]
  simp

/-- One absolute constant in the polynomial sample and square-root logarithmic
signal conditions suffices for the actual clipped-amplitude canonical partition
tail, for every positive error fraction. -/
theorem exists_canonicalEstimatedScale_partition_four_exp_tail_of_polynomial_budgets :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ) (ε : ℝ), 0 < ε →
          C * Real.sqrt (Real.log (1 / ε)) ≤ NumStability.vecNorm2 mean →
          ε ^ (-C) * (n : ℝ) ≤ (m : ℝ) →
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
  obtain ⟨K, _hK, htail⟩ :=
    exists_canonicalEstimatedScale_partition_four_exp_tail_of_numerical_budgets
  let C : ℝ := max (2 + Real.log (max K 1) / Real.log 2) 20
  refine ⟨C, lt_of_lt_of_le (by norm_num : (0 : ℝ) < 20) (le_max_right _ _), ?_⟩
  intro m n hm hn mean ε hε hsignal hsample
  by_cases hhalf : ε ≤ 1 / 2
  · apply htail hm hn mean ε hε (by linarith)
    · exact log_signal_budget_of_polynomial_signal_budget C ε _ hε hhalf
        (NumStability.vecNorm2_nonneg mean) (le_max_right _ _) hsignal
    · exact quadratic_sample_budget_of_polynomial_sample_budget K C ε _ _
        hε hhalf (Nat.cast_nonneg n) (le_max_left _ _) hsample
  · have hhalf' : 1 / 2 ≤ ε := le_of_lt (lt_of_not_ge hhalf)
    have hz := canonical_partition_failure_measure_zero_of_half_le mean
      (fun ω ↦
        let X : Fin m → Fin n → ℝ := fun i ↦ canonicalPoint mean ω i
        let a := Real.sqrt (max
          (NumStability.hermitianOrderedEigenvalue
            (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
            ⟨0, hn⟩ - 1) 0)
        a • (fun j ↦
          NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X j))
      ε hhalf'
    rw [hz]
    positivity

end NumStability.HDP.Vector.GaussianMixture
