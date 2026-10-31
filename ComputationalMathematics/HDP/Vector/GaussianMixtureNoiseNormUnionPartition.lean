import ComputationalMathematics.HDP.Vector.GaussianMixtureEmpiricalErrorTail
import ComputationalMathematics.HDP.Vector.GaussianMixtureIdeal
import ComputationalMathematics.HDP.Vector.GaussianMixtureNoiseNormSpectral
import ComputationalMathematics.HDP.Vector.GaussianMixtureNoiseNormUnionTail
import ComputationalMathematics.HDP.Vector.GaussianMixturePositiveScaling

/-!
# Same-sample clipped-amplitude partition recovery with explicit rare-event union confidence thresholds.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- Rare ideal/noise count union bounds and the existing covariance estimate
give actual clipped-amplitude partition recovery under explicit thresholds. -/
theorem exists_canonicalEstimatedScale_partition_four_exp_tail_of_noise_norm_union_thresholds :
    ∃ C D c : ℝ, 0 < C ∧ 0 < D ∧ 0 < c ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (epsilon t : ℝ), 0 < epsilon → 0 ≤ t →
          let delta : ℝ := C * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
            Real.sqrt (2 * (n : ℝ)) / Real.sqrt (m : ℝ))
          let rNoise : ℝ := D * (Real.sqrt (n : ℝ) + Real.sqrt (2 * (n : ℝ))) /
            Real.sqrt (m : ℝ)
          let q : ℝ := 4 * max delta (delta ^ 2) + 2 * NumStability.vecNorm2 mean * rNoise
          (m : ℝ) * (4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ≤
            Real.exp (-(n : ℝ)) →
          (m : ℝ) * (2 * Real.exp (-(c * t ^ 2))) ≤ Real.exp (-(n : ℝ)) →
          (2 * Real.sqrt 2 * q / NumStability.vecNorm2 mean) *
              (NumStability.vecNorm2 mean + (Real.sqrt (n : ℝ) + t)) <
            NumStability.vecNorm2 mean ^ 2 / 2 →
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
  obtain ⟨C, D, hC, hD, hcovariance⟩ :=
    exists_canonicalSampleCovarianceDeviation_signal_noise_dimension_tail
  obtain ⟨c, hc, hnoiseCount⟩ := exists_canonicalNoise_norm_exceptional_count_union_dimension_tail
  refine ⟨C, D, c, hC, hD, hc, ?_⟩
  intro m n hm hn mean hmean epsilon t hepsilon ht
  dsimp only
  intro hidealConfidence hnoiseConfidence hmargin hsmall
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
  let delta : ℝ := C * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
    Real.sqrt (2 * (n : ℝ)) / Real.sqrt (m : ℝ))
  let rNoise : ℝ := D * (Real.sqrt (n : ℝ) + Real.sqrt (2 * (n : ℝ))) /
    Real.sqrt (m : ℝ)
  let q : ℝ := 4 * max delta (delta ^ 2) + 2 * NumStability.vecNorm2 mean * rNoise
  let covarianceBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | q < NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
        populationSecondMoment mean)}
  let idealBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | epsilon / 2 * m ≤
      (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)}
  let noiseBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | epsilon / 2 * m ≤ (Set.ncard
      {i | Real.sqrt (n : ℝ) + t < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)}
  let labelBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1}
  have hq : 0 ≤ q := by dsimp [q, rNoise]; positivity
  have hcovarianceTail : μ.real covarianceBad ≤ 2 * Real.exp (-(n : ℝ)) := by
    simpa only [μ, covarianceBad, q, delta, rNoise, X,
      NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment,
      populationSecondMoment] using (hcovariance hm hn mean)
  have hidealTail : μ.real idealBad ≤ Real.exp (-(n : ℝ)) := by
    have htail := canonicalIdealMarginErrorCount_union_tail
      hm mean hmean (ε := epsilon / 2) (by positivity)
    calc
      μ.real idealBad ≤ (m : ℝ) *
          (4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) := by
        simpa [μ, idealBad, labels, X] using htail
      _ ≤ _ := hidealConfidence
  have hnoiseTail : μ.real noiseBad ≤ Real.exp (-(n : ℝ)) := by
    have htail := hnoiseCount (m := m) hn t (epsilon / 2 * m) ht
      (by
        have hmReal : (0 : ℝ) < m := by exact_mod_cast hm
        exact mul_pos (div_pos hepsilon (by norm_num)) hmReal) hnoiseConfidence
    simpa [μ, noiseBad] using htail
  have hlabelZero : μ labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    exact not_not_intro hω
  have hlabelRealZero : μ.real labelBad = 0 := by
    rw [Measure.real_def, hlabelZero]; simp
  have hcountsWithLabels : μ.real ((idealBad ∪ noiseBad) ∪ labelBad) ≤
      2 * Real.exp (-(n : ℝ)) := by
    calc
      _ ≤ μ.real (idealBad ∪ noiseBad) + μ.real labelBad := measureReal_union_le _ _
      _ ≤ μ.real idealBad + μ.real noiseBad + μ.real labelBad :=
        add_le_add (measureReal_union_le _ _) (le_refl _)
      _ ≤ _ := by rw [hlabelRealZero]; linarith
  have hstrongTail : μ.real
      {ω | ¬ MakesAtMostErrorsUpToSign (labels ω)
        (scale ω • direction ω) (X ω) (epsilon * m)} ≤ 4 * Real.exp (-(n : ℝ)) := by
    apply spectral_clustering_failure_tail_of_two_bad_events X labels
      (fun ω ↦ scale ω • direction ω) epsilon covarianceBad ((idealBad ∪ noiseBad) ∪ labelBad)
      hcovarianceTail hcountsWithLabels
    intro ω hcovGood hcountsGood
    have hdeviation : NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment (X ω) -
          populationSecondMoment mean) ≤ q := le_of_not_gt hcovGood
    have hideal : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) ≤ epsilon * m / 2 := by
      have hlt : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
          (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) < epsilon / 2 * m :=
        lt_of_not_ge (fun h ↦ hcountsGood (Or.inl (Or.inl h)))
      nlinarith
    have hnoise : (Set.ncard
        {i | Real.sqrt (n : ℝ) + t < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ) ≤
          epsilon * m / 2 := by
      have hlt : (Set.ncard
          {i | Real.sqrt (n : ℝ) + t < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ) <
            epsilon / 2 * m :=
        lt_of_not_ge (fun h ↦ hcountsGood (Or.inl (Or.inr h)))
      nlinarith
    have hlabels : ∀ i, labels ω i = -1 ∨ labels ω i = 1 :=
      not_not.mp (fun h ↦ hcountsGood (Or.inr h))
    have hdecomposition : ∀ i, X ω i = labels ω i • mean + canonicalNoise ω i := by
      intro i
      ext j
      rfl
    have hunit := makesAtMostErrorsUpToSign_leadingEigenvector_of_noise_norm_margin
      hn (labels ω) hlabels (X ω) (canonicalNoise ω) mean hmean hdecomposition epsilon
      (NumStability.vecNorm2 mean ^ 2 / 2) (Real.sqrt (n : ℝ) + t) q hq
      hdeviation hmargin hideal hnoise
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
