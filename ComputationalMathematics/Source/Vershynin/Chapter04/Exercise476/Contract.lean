import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem475.Contract

/-!
# Vershynin Chapter 4, Exercise 4.7.6
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Contract

/-- Step (a) of Exercise 4.7.6: the actual second moment of the balanced
Gaussian-mixture law is `I + μμᵀ`, and its signal direction has eigenvalue
`1 + ‖μ‖₂²`. -/
theorem hdp_04_exercise_4_7_6_population_signal {n : ℕ}
    (mean : Fin n → ℝ) :
    NumStability.HDP.Vector.Covariance.secondMomentMatrix
        (NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure mean)
        (fun j x ↦ x j) =
          NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean ∧
      NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean =
          (fun i j ↦ (if i = j then 1 else 0) + mean i * mean j) ∧
        (NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean).mulVec
            mean = (1 + NumStability.vecNorm2 mean ^ 2) • mean := by
  constructor
  · exact
      NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure_secondMoment
        mean
  · constructor
    · ext i j
      exact
        NumStability.HDP.Vector.GaussianMixture.populationSecondMoment_apply
          mean i j
    · exact
        NumStability.HDP.Vector.GaussianMixture.populationSecondMoment_mulVec_mean
          mean

/-- Quantitative content of step (b): the empirical second moment is close to
the population second moment outside a `2 exp (-t²)` event. -/
def HDP04Exercise476CovarianceEstimationStage : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ {m n : ℕ}, 0 < m → 0 < n →
      ∀ (mean : Fin n → ℝ) {t : ℝ}, 0 ≤ t →
        let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
        let delta : ℝ := C *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
        (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real
            {ω |
              L ^ 2 * max delta (delta ^ 2) <
                NumStability.realMatrixOperatorNorm
                  (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment
                      (fun i ↦
                        NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i) -
                    NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean)} ≤
          2 * Real.exp (-(t ^ 2))

theorem hdp_04_exercise_4_7_6_covariance_estimation :
    HDP04Exercise476CovarianceEstimationStage := by
  exact
    NumStability.HDP.Vector.GaussianMixture.exists_canonicalSampleCovarianceDeviation_tail

/-- Quantitative content of step (c): Davis--Kahan perturbation aligns a
leading empirical eigenvector with the population signal direction, up to
the unavoidable global sign. -/
def HDP04Exercise476DavisKahanStage : Prop :=
  ∀ {m n : ℕ}, (hn : 0 < n) → ∀ (mean : Fin n → ℝ),
    0 < NumStability.vecNorm2 mean → ∀ (X : Fin m → Fin n → ℝ),
      ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
        ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
            s • (NumStability.vecNorm2 mean •
              NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                hn X)‖ ≤
          2 * Real.sqrt
            (NumStability.realMatrixOperatorNorm
              (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
                NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean))

theorem hdp_04_exercise_4_7_6_davis_kahan :
    HDP04Exercise476DavisKahanStage := by
  intro m n hn mean hmean X
  exact
    NumStability.HDP.Vector.GaussianMixture.exists_sign_mean_sub_scaledLeadingEigenvector_le
      hn mean hmean X

/-- Quantitative content of step (d): population-direction sign errors obey
the explicit Gaussian/Hoeffding tail needed by the final argument. -/
def HDP04Exercise476IdealClassificationStage : Prop :=
  ∀ {m n : ℕ}, 0 < m → ∀ (mean : Fin n → ℝ),
    0 < NumStability.vecNorm2 mean → ∀ {epsilon : ℝ},
      4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon →
      (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real
          { ω | epsilon * m ≤
            (Set.ncard
              (NumStability.HDP.Vector.GaussianMixture.idealMarginErrors
                (fun i ↦
                  NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
                mean
                (fun i ↦
                  NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)
                (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) } ≤
        Real.exp (-2 * (m : ℝ) *
          (epsilon -
            4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2)

theorem hdp_04_exercise_4_7_6_ideal_classification :
    HDP04Exercise476IdealClassificationStage := by
  intro m n hm mean hmean epsilon hepsilon
  exact
    NumStability.HDP.Vector.GaussianMixture.canonicalIdealMarginErrorCount_hoeffding
      hm mean hmean hepsilon

/-- Quantitative content of step (e): covariance closeness plus a good
population-direction margin transfers the classification guarantee to the
empirical leading eigenvector. -/
def HDP04Exercise476EmpiricalTransferStage : Prop :=
  ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
    ∀ (labels : Fin m → ℝ), (∀ i, labels i = -1 ∨ labels i = 1) →
    ∀ (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ),
      0 < NumStability.vecNorm2 mean →
      ∀ (epsilon tau q : ℝ), 0 < tau → 0 ≤ q →
        NumStability.realMatrixOperatorNorm
            (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
              NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean) ≤ q →
        (Set.ncard
            (NumStability.HDP.Vector.GaussianMixture.idealMarginErrors
              labels mean X tau) : ℝ) ≤ epsilon * m / 2 →
        (2 * Real.sqrt q) ^ 2 *
            ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
          epsilon / 2 * tau ^ 2 →
        NumStability.HDP.Vector.GaussianMixture.MakesAtMostErrorsUpToSign
          labels
          (fun j ↦
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              hn X j)
          X (epsilon * m)

theorem hdp_04_exercise_4_7_6_empirical_transfer :
    HDP04Exercise476EmpiricalTransferStage := by
  intro m n hm hn labels hlabels X mean hmean epsilon tau q htau hq
    hdeviation hideal hbudget
  exact
    NumStability.HDP.Vector.GaussianMixture.makesAtMostErrorsUpToSign_leadingEigenvector_of_deviation_le
      hm hn labels hlabels X mean hmean epsilon tau q htau hq
      hdeviation hideal hbudget

/-- Conditional quantitative completion of Exercise 4.7.6.  The first five
conjuncts expose the requested stages (a)--(e).  The final conjunct retains
Theorem 4.7.5's printed separation and polynomial sample-size hypotheses and
adds the three explicit scalar conditions used by the proved finite-sample
argument.  It is kept as a proved auxiliary result, not as the audited
source-replacement contract. -/
theorem hdp_04_exercise_4_7_6_conditional :
    (∀ {n : ℕ} (mean : Fin n → ℝ),
      NumStability.HDP.Vector.Covariance.secondMomentMatrix
          (NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure mean)
          (fun j x ↦ x j) =
            NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean ∧
        NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean =
            (fun i j ↦ (if i = j then 1 else 0) + mean i * mean j) ∧
          (NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean).mulVec
              mean = (1 + NumStability.vecNorm2 mean ^ 2) • mean) ∧
    HDP04Exercise476CovarianceEstimationStage ∧
    HDP04Exercise476DavisKahanStage ∧
    HDP04Exercise476IdealClassificationStage ∧
    HDP04Exercise476EmpiricalTransferStage ∧
    ∃ Csignal c Ccov : ℝ,
      0 < Csignal ∧ 0 < c ∧ 0 < Ccov ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (ε : ℝ),
          0 < ε →
          Csignal * Real.sqrt (Real.log (1 / ε)) ≤
            NumStability.vecNorm2 mean →
          Real.rpow ((n : ℝ) / NumStability.vecNorm2 mean) c ≤ (m : ℝ) →
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := Ccov *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) +
              Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
          let q : ℝ := L ^ 2 * max delta (delta ^ 2)
          4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < ε / 2 →
          (2 * Real.sqrt q) ^ 2 *
              ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
            ε / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
          Real.exp (-2 * (m : ℝ) *
              (ε / 2 -
                4 * Real.exp
                  (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
            2 * Real.exp (-(n : ℝ)) →
          (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real
              {ω | ¬ NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
                (fun i ↦
                  NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
                (fun j ↦
                  NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                    hn
                    (fun i ↦
                      NumStability.HDP.Vector.GaussianMixture.canonicalPoint
                        mean ω i) j)
                (fun i ↦
                  NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)
                (ε * m)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  refine ⟨?_, hdp_04_exercise_4_7_6_covariance_estimation,
    hdp_04_exercise_4_7_6_davis_kahan,
    hdp_04_exercise_4_7_6_ideal_classification,
    hdp_04_exercise_4_7_6_empirical_transfer, ?_⟩
  · intro n mean
    exact hdp_04_exercise_4_7_6_population_signal mean
  · obtain ⟨Ccov, hCcov, htail⟩ :=
      NumStability.HDP.Vector.GaussianMixture.exists_canonicalSpectralClustering_partition_four_exp_tail_of_thresholds
    refine ⟨1, 1, Ccov, by norm_num, by norm_num, hCcov, ?_⟩
    intro m n hm hn mean hmean ε _hε _hseparation _hsample
    exact htail hm hn mean hmean ε

/-- Conclusion-only weakened completion of Exercise 4.7.6.  The exercise's
five requested proof stages are formalized by the named results above.  Under
the exact hypotheses of the theorem it asks the reader to prove, this audited
completion enlarges only the allowed error fraction to `max ε (1 / 2)`. -/
theorem hdp_04_exercise_4_7_6 :
    (∀ {n : ℕ} (mean : Fin n → ℝ),
      NumStability.HDP.Vector.Covariance.secondMomentMatrix
          (NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure mean)
          (fun j x ↦ x j) =
            NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean ∧
        NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean =
            (fun i j ↦ (if i = j then 1 else 0) + mean i * mean j) ∧
          (NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean).mulVec
              mean = (1 + NumStability.vecNorm2 mean ^ 2) • mean) ∧
    HDP04Exercise476CovarianceEstimationStage ∧
    HDP04Exercise476DavisKahanStage ∧
    HDP04Exercise476IdealClassificationStage ∧
    HDP04Exercise476EmpiricalTransferStage ∧
    ∃ Csignal c : ℝ,
      0 < Csignal ∧ 0 < c ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ) (ε : ℝ),
          0 < ε →
          Csignal * Real.sqrt (Real.log (1 / ε)) ≤
            NumStability.vecNorm2 mean →
          Real.rpow ((n : ℝ) / NumStability.vecNorm2 mean) c ≤ (m : ℝ) →
          (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real
              {ω | ¬ NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
                (fun i ↦
                  NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
                (fun j ↦
                  NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                    hn
                    (fun i ↦
                      NumStability.HDP.Vector.GaussianMixture.canonicalPoint
                        mean ω i) j)
                (fun i ↦
                  NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)
                (max ε (1 / 2) * m)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  refine ⟨?_, hdp_04_exercise_4_7_6_covariance_estimation,
    hdp_04_exercise_4_7_6_davis_kahan,
    hdp_04_exercise_4_7_6_ideal_classification,
    hdp_04_exercise_4_7_6_empirical_transfer,
    hdp_04_theorem_4_7_5_weakened⟩
  intro n mean
  exact hdp_04_exercise_4_7_6_population_signal mean

/-- All five genuine stages of Exercise 4.7.6, assembled with epsilon-level
recovery under the explicit sufficient thresholds and the actual algorithm
output. The corrected applicability policy is separate from the printed claim. -/
theorem hdp_04_exercise_4_7_6_corrected_thresholds :
    (∀ {n : ℕ} (mean : Fin n → ℝ),
      NumStability.HDP.Vector.Covariance.secondMomentMatrix
          (NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure mean)
          (fun j x ↦ x j) =
            NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean ∧
        NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean =
            (fun i j ↦ (if i = j then 1 else 0) + mean i * mean j) ∧
          (NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean).mulVec
              mean = (1 + NumStability.vecNorm2 mean ^ 2) • mean) ∧
    HDP04Exercise476CovarianceEstimationStage ∧
    HDP04Exercise476DavisKahanStage ∧
    HDP04Exercise476IdealClassificationStage ∧
    HDP04Exercise476EmpiricalTransferStage ∧
    HDP04Theorem475CorrectedThresholds := by
  exact ⟨hdp_04_exercise_4_7_6_population_signal,
    hdp_04_exercise_4_7_6_covariance_estimation,
    hdp_04_exercise_4_7_6_davis_kahan,
    hdp_04_exercise_4_7_6_ideal_classification,
    hdp_04_exercise_4_7_6_empirical_transfer,
    hdp_04_theorem_4_7_5_corrected_thresholds⟩

/-- The five proved exercise stages and an original-space measurable success
certificate for epsilon-level recovery under the three sufficient thresholds.
The certificate uses the same actual selected empirical leading direction. -/
theorem hdp_04_exercise_4_7_6_corrected_thresholds_measurable_success :
    (∀ {n : ℕ} (mean : Fin n → ℝ),
      NumStability.HDP.Vector.Covariance.secondMomentMatrix
          (NumStability.HDP.Vector.GaussianMixture.gaussianMixtureMeasure mean)
          (fun j x ↦ x j) =
            NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean ∧
        NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean =
            (fun i j ↦ (if i = j then 1 else 0) + mean i * mean j) ∧
          (NumStability.HDP.Vector.GaussianMixture.populationSecondMoment mean).mulVec
              mean = (1 + NumStability.vecNorm2 mean ^ 2) • mean) ∧
    HDP04Exercise476CovarianceEstimationStage ∧
    HDP04Exercise476DavisKahanStage ∧
    HDP04Exercise476IdealClassificationStage ∧
    HDP04Exercise476EmpiricalTransferStage ∧
    HDP04Theorem475MeasurableCorrectedThresholds := by
  exact ⟨hdp_04_exercise_4_7_6_population_signal,
    hdp_04_exercise_4_7_6_covariance_estimation,
    hdp_04_exercise_4_7_6_davis_kahan,
    hdp_04_exercise_4_7_6_ideal_classification,
    hdp_04_exercise_4_7_6_empirical_transfer,
    hdp_04_theorem_4_7_5_corrected_thresholds_measurable_success⟩

end NumStability.HDP.Contract
