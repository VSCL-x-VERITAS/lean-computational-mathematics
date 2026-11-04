import ComputationalMathematics.HDP.Vector.GaussianMixturePositiveScaling

/-!
# Shared covariance event for estimated-amplitude partition recovery

The same good covariance event certifies both the empirical unit direction and
positivity of its clipped amplitude. Reusing the existing two-event probability
assembly avoids charging a second covariance tail. The four explicit finite
thresholds remain; no printed polynomial sample condition is asserted.
-/

noncomputable section
open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- The estimated-amplitude partition has a four-exponential tail under one
covariance constant and the four explicit finite thresholds. -/
theorem exists_canonicalEstimatedScale_partition_four_exp_tail_of_shared_thresholds :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (epsilon : ℝ),
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := C * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
            Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
          let q : ℝ := L ^ 2 * max delta (delta ^ 2)
          4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2 →
          (2 * Real.sqrt q) ^ 2 *
              ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
            epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
          Real.exp (-2 * (m : ℝ) *
              (epsilon / 2 -
                4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
            2 * Real.exp (-(n : ℝ)) →
          q < NumStability.vecNorm2 mean ^ 2 →
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
                X (epsilon * m)} ≤ 4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, hcovariance⟩ := exists_canonicalSampleCovarianceDeviation_tail
  refine ⟨C, hC, ?_⟩
  intro m n hm hn mean hmean epsilon
  dsimp only
  intro hidealScale hbudget hidealThreshold hsmall
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let X : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → Fin n → ℝ :=
    fun ω i ↦ canonicalPoint mean ω i
  let labels : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → ℝ :=
    fun ω i ↦ canonicalLabel ω i
  let direction : (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ :=
    fun ω j ↦
      NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn (X ω) j
  let scale : (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun ω ↦ Real.sqrt (max
      (NumStability.hermitianOrderedEigenvalue
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian (X ω))
        ⟨0, hn⟩ - 1) 0)
  let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
  let delta : ℝ := C * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
    Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
  let q : ℝ := L ^ 2 * max delta (delta ^ 2)
  let covarianceBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | q < NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
        populationSecondMoment mean)}
  let idealBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | epsilon / 2 * m ≤
      (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)}
  let labelBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1}
  have hq : 0 ≤ q := by dsimp [q, L]; positivity
  have hcovarianceTail : μ.real covarianceBad ≤ 2 * Real.exp (-(n : ℝ)) := by
    simpa [μ, covarianceBad, q, delta, L, X,
      NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment,
      NumStability.HDP.Vector.Covariance.randomSampleCovariance,
      Real.sq_sqrt (Nat.cast_nonneg n)] using
      (hcovariance hm hn mean (t := Real.sqrt (n : ℝ)) (Real.sqrt_nonneg _))
  have hidealTail : μ.real idealBad ≤ 2 * Real.exp (-(n : ℝ)) := by
    have htail := canonicalIdealMarginErrorCount_hoeffding hm mean hmean hidealScale
    have hraw : μ.real idealBad ≤ Real.exp (-2 * (m : ℝ) *
        (epsilon / 2 - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
      simpa [μ, idealBad, labels, X] using htail
    exact hraw.trans hidealThreshold
  have hlabelZero : μ labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    exact not_not_intro hω
  have hlabelRealZero : μ.real labelBad = 0 := by
    rw [Measure.real_def, hlabelZero]; simp
  have hidealWithLabels : μ.real (idealBad ∪ labelBad) ≤ 2 * Real.exp (-(n : ℝ)) := by
    calc
      μ.real (idealBad ∪ labelBad) ≤ μ.real idealBad + μ.real labelBad :=
        measureReal_union_le _ _
      _ = μ.real idealBad := by rw [hlabelRealZero, add_zero]
      _ ≤ _ := hidealTail
  have hstrongTail : μ.real
      {ω | ¬ MakesAtMostErrorsUpToSign (labels ω)
        (scale ω • direction ω) (X ω) (epsilon * m)} ≤ 4 * Real.exp (-(n : ℝ)) := by
    apply spectral_clustering_failure_tail_of_two_bad_events X labels
      (fun ω ↦ scale ω • direction ω) epsilon covarianceBad (idealBad ∪ labelBad)
      hcovarianceTail hidealWithLabels
    intro ω hcovGood hidealGood
    have hdeviation : NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
          populationSecondMoment mean) ≤ q := le_of_not_gt hcovGood
    have hideal : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) ≤ epsilon * m / 2 := by
      have hlt : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
          (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) < epsilon / 2 * m :=
        lt_of_not_ge (fun h ↦ hidealGood (Or.inl h))
      nlinarith
    have hlabels : ∀ i, labels ω i = -1 ∨ labels ω i = 1 :=
      not_not.mp (fun h ↦ hidealGood (Or.inr h))
    have hunit := makesAtMostErrorsUpToSign_leadingEigenvector_of_deviation_le
      hm hn (labels ω) hlabels (X ω) mean hmean epsilon
      (NumStability.vecNorm2 mean ^ 2 / 2) q (by positivity) hq
      hdeviation hideal hbudget
    have hswap : NumStability.realMatrixOperatorNorm
        (populationSecondMoment mean -
          NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω)) =
        NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
            populationSecondMoment mean) := by
      unfold NumStability.realMatrixOperatorNorm NumStability.realMatrixContinuousLinearMap
      simp only [map_sub]
      exact norm_sub_rev _ _
    have hpositive : 0 < scale ω :=
      spectralAmplitude_pos_of_operatorError_lt_meanNorm_sq hn mean hmean
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω))
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian (X ω))
        (by rw [hswap]; exact hdeviation.trans_lt hsmall)
    exact (makesAtMostErrorsUpToSign_pos_smul_iff (labels ω) (direction ω)
      (X ω) (epsilon * m) (scale ω) hpositive).mpr hunit
  have hsubset :
      {ω | ¬ MakesAtMostPartitionErrorsUpToSwap (labels ω)
        (scale ω • direction ω) (X ω) (epsilon * m)} ⊆
      {ω | ¬ MakesAtMostErrorsUpToSign (labels ω)
        (scale ω • direction ω) (X ω) (epsilon * m)} ∪ labelBad := by
    intro ω hfailure
    by_contra hnot
    simp only [Set.mem_union, not_or] at hnot
    exact hfailure (makesAtMostErrorsUpToSign_implies_partitionErrorsUpToSwap
      (labels ω) (scale ω • direction ω) (X ω) (epsilon * m)
      (not_not.mp hnot.2) (not_not.mp hnot.1))
  change μ.real {ω | ¬ MakesAtMostPartitionErrorsUpToSwap (labels ω)
    (scale ω • direction ω) (X ω) (epsilon * m)} ≤ 4 * Real.exp (-(n : ℝ))
  calc
    _ ≤ μ.real ({ω | ¬ MakesAtMostErrorsUpToSign (labels ω)
        (scale ω • direction ω) (X ω) (epsilon * m)} ∪ labelBad) :=
      measureReal_mono hsubset (measure_ne_top _ _)
    _ ≤ μ.real {ω | ¬ MakesAtMostErrorsUpToSign (labels ω)
        (scale ω • direction ω) (X ω) (epsilon * m)} + μ.real labelBad :=
      measureReal_union_le _ _
    _ ≤ 4 * Real.exp (-(n : ℝ)) := by rw [hlabelRealZero, add_zero]; exact hstrongTail

end NumStability.HDP.Vector.GaussianMixture
