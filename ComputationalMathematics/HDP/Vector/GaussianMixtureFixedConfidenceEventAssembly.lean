import ComputationalMathematics.HDP.Vector.GaussianMixtureProjectionBudgets
import ComputationalMathematics.HDP.Probability.BinaryTesting

/-! Ordinary actual-unit-direction event assembly. No source claim is selected. -/
noncomputable section
open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- A covariance outer-tail bound and the existing ideal-margin Hoeffding bound
give a measurable certificate for the actual unit leading eigenvector's literal
partition. This does not assume measurable eigenvector selection. -/
theorem exists_measurable_actualUnit_partition_certificate_of_covariance_tail
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (epsilon q eta : ℝ) (hq : 0 ≤ q)
    (hidealScale : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2)
    (hbudget : 4 * q * (1 + NumStability.vecNorm2 mean ^ 2 + q) ≤
      epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2)
    (hcovariance : (latentNoiseSampleMeasure m n).real
      {ω | q < NumStability.realMatrixOperatorNorm
        (EuclideanSpectralClustering.sampleSecondMoment
          (fun i ↦ canonicalPoint mean ω i) - populationSecondMoment mean)} ≤ eta) :
    ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
      MeasurableSet good ∧
      (∀ ω ∈ good, MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel ω i)
        (fun j ↦ EuclideanSpectralClustering.leadingEigenvector hn
          (fun i ↦ canonicalPoint mean ω i) j)
        (fun i ↦ canonicalPoint mean ω i) (epsilon * m)) ∧
      1 - (eta + Real.exp (-2 * (m : ℝ) *
        (epsilon / 2 - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2)) ≤
          (latentNoiseSampleMeasure m n).real good := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let X := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i ↦ canonicalPoint mean ω i
  let labels := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i ↦ canonicalLabel ω i
  let direction := fun (ω : Fin m → ℝ × (Fin n → ℝ)) j ↦
    EuclideanSpectralClustering.leadingEigenvector hn (X ω) j
  let covarianceBad := {ω | q < NumStability.realMatrixOperatorNorm
    (EuclideanSpectralClustering.sampleSecondMoment (X ω) - populationSecondMoment mean)}
  let idealBad := {ω | epsilon / 2 * m ≤
    (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
      (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)}
  let labelBad := {ω | ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1}
  let success := {ω | MakesAtMostPartitionErrorsUpToSwap
    (labels ω) (direction ω) (X ω) (epsilon * m)}
  have hlabelZero : μ labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    exact not_not_intro hω
  have hlabelRealZero : μ.real labelBad = 0 := by
    rw [Measure.real_def, hlabelZero]; simp
  have hidealTail := canonicalIdealMarginErrorCount_hoeffding hm mean hmean hidealScale
  have hsubset : successᶜ ⊆ covarianceBad ∪ (idealBad ∪ labelBad) := by
    intro ω hfailure
    by_contra hnot
    have hcov : ω ∉ covarianceBad := fun h ↦ hnot (Or.inl h)
    have hidealGood : ω ∉ idealBad := fun h ↦ hnot (Or.inr (Or.inl h))
    have hlabels : ∀ i, labels ω i = -1 ∨ labels ω i = 1 :=
      not_not.mp (fun h ↦ hnot (Or.inr (Or.inr h)))
    have hdeviation : NumStability.realMatrixOperatorNorm
        (EuclideanSpectralClustering.sampleSecondMoment (X ω) - populationSecondMoment mean) ≤ q :=
      le_of_not_gt hcov
    have hideal : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) ≤ epsilon * m / 2 := by
      have hlt : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
          (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) < epsilon / 2 * m :=
        lt_of_not_ge hidealGood
      nlinarith
    apply hfailure
    exact makesAtMostErrorsUpToSign_implies_partitionErrorsUpToSwap
      (labels ω) (direction ω) (X ω) (epsilon * m) hlabels
      (makesAtMostErrorsUpToSign_leadingEigenvector_of_projection_budget
        hm hn (labels ω) hlabels (X ω) mean hmean epsilon
        (NumStability.vecNorm2 mean ^ 2 / 2) q (by positivity) hq
        hdeviation hideal hbudget)
  have hfailure : μ.real successᶜ ≤ eta + Real.exp (-2 * (m : ℝ) *
      (epsilon / 2 - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
    calc
      _ ≤ μ.real (covarianceBad ∪ (idealBad ∪ labelBad)) := measureReal_mono hsubset
      _ ≤ μ.real covarianceBad + (μ.real idealBad + μ.real labelBad) := by
        exact (measureReal_union_le _ _).trans
          (add_le_add_right (measureReal_union_le _ _) _)
      _ = μ.real covarianceBad + μ.real idealBad := by rw [hlabelRealZero, add_zero]
      _ ≤ _ := add_le_add hcovariance hidealTail
  obtain ⟨good, hmeas, hgood, hmass⟩ :=
    NumStability.HDP.Probability.exists_measurable_subset_of_failure_measureReal_le
      success hfailure
  exact ⟨good, hmeas, hgood, hmass⟩


end NumStability.HDP.Vector.GaussianMixture
