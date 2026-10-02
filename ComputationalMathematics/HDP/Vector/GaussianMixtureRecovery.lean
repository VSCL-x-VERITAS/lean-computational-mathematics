import ComputationalMathematics.HDP.Vector.GaussianMixtureSpectral

/-!
# Finite-sample spectral recovery for the symmetric Gaussian mixture

This file assembles the covariance-deviation, ideal-margin, and deterministic
spectral-transfer steps for the canonical latent Gaussian-mixture sample.  The
result keeps the two finite-sample failure terms explicit; later source-level
corollaries can discharge the displayed arithmetic hypotheses at their chosen
parameter scale.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped RealInnerProductSpace

namespace NumStability.HDP.Vector.GaussianMixture

/-- A fully assembled finite-sample recovery theorem for the canonical
symmetric Gaussian mixture.  The hypotheses are the two transparent scalar
conditions needed by the ideal-margin and deterministic perturbation steps.
-/
theorem exists_canonicalSpectralClustering_tail_of_thresholds :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (ε : ℝ),
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) +
              Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
          let q : ℝ := L ^ 2 * max delta (delta ^ 2)
          4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < ε / 2 →
          (2 * Real.sqrt q) ^ 2 *
              ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
            ε / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
          (latentNoiseSampleMeasure m n).real
              {ω | ¬ MakesAtMostErrorsUpToSign
                (fun i ↦ canonicalLabel ω i)
                (fun j ↦
                  NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                    hn
                    (fun i ↦ canonicalPoint mean ω i) j)
                (fun i ↦ canonicalPoint mean ω i) (ε * m)} ≤
            2 * Real.exp (-(n : ℝ)) +
              Real.exp (-2 * (m : ℝ) *
                (ε / 2 -
                  4 * Real.exp
                    (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
  obtain ⟨C, hC, hcovariance⟩ :=
    exists_canonicalSampleCovarianceDeviation_tail
  refine ⟨C, hC, ?_⟩
  intro m n hm hn mean hmean ε
  dsimp only
  intro hidealScale hbudget
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ :=
    ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let X : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → Fin n → ℝ :=
    fun ω i ↦ canonicalPoint mean ω i
  let labels : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → ℝ :=
    fun ω i ↦ canonicalLabel ω i
  let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
  let delta : ℝ := C *
    (Real.sqrt ((n : ℝ) / (m : ℝ)) +
      Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
  let q : ℝ := L ^ 2 * max delta (delta ^ 2)
  let covarianceBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | q < NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment
          (X ω) - populationSecondMoment mean)}
  let idealBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ε / 2 * m ≤
      (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)}
  let labelBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1}
  let failure : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ MakesAtMostErrorsUpToSign (labels ω)
      (fun j ↦
        NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
          hn (X ω) j)
      (X ω) (ε * m)}
  have hq : 0 ≤ q := by
    dsimp [q, L]
    positivity
  have hcovarianceTail : μ.real covarianceBad ≤
      2 * Real.exp (-(n : ℝ)) := by
    have htail := hcovariance hm hn mean
      (t := Real.sqrt (n : ℝ)) (Real.sqrt_nonneg _)
    have hsqrt : Real.sqrt (n : ℝ) ^ 2 = (n : ℝ) :=
      Real.sq_sqrt (Nat.cast_nonneg n)
    rw [hsqrt] at htail
    simpa [μ, covarianceBad, q, delta, L,
      NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment,
      NumStability.HDP.Vector.Covariance.randomSampleCovariance, X] using htail
  have hidealTail : μ.real idealBad ≤
      Real.exp (-2 * (m : ℝ) *
        (ε / 2 - 4 * Real.exp
          (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
    simpa [μ, idealBad, labels, X] using
      (canonicalIdealMarginErrorCount_hoeffding hm mean hmean hidealScale)
  have hlabelZero : μ labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    change ¬ ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1
    exact not_not_intro hω
  have hlabelRealZero : μ.real labelBad = 0 := by
    rw [Measure.real_def, hlabelZero]
    simp
  have hfailureSubset : failure ⊆ covarianceBad ∪ idealBad ∪ labelBad := by
    intro ω hfailure
    by_contra hnot
    simp only [Set.mem_union, not_or] at hnot
    have hdeviation :
        NumStability.realMatrixOperatorNorm
            (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment
                (X ω) - populationSecondMoment mean) ≤ q := by
      exact le_of_not_gt hnot.1.1
    have hideal :
        (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
          (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) ≤ ε * m / 2 := by
      have hlt :
          (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
            (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) < ε / 2 * m := by
        exact lt_of_not_ge hnot.1.2
      nlinarith
    have hlabels : ∀ i, labels ω i = -1 ∨ labels ω i = 1 := by
      have hlabelnot := hnot.2
      change ¬ ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1 at hlabelnot
      exact not_not.mp hlabelnot
    have hτ : 0 < NumStability.vecNorm2 mean ^ 2 / 2 := by positivity
    have hgood :=
      makesAtMostErrorsUpToSign_leadingEigenvector_of_deviation_le
        hm hn (labels ω) hlabels (X ω) mean hmean ε
        (NumStability.vecNorm2 mean ^ 2 / 2) q hτ hq
        hdeviation hideal hbudget
    exact hfailure hgood
  calc
    μ.real failure ≤ μ.real (covarianceBad ∪ idealBad ∪ labelBad) :=
      measureReal_mono hfailureSubset (measure_ne_top _ _)
    _ ≤ μ.real (covarianceBad ∪ idealBad) + μ.real labelBad :=
      measureReal_union_le _ _
    _ ≤ (μ.real covarianceBad + μ.real idealBad) + μ.real labelBad := by
      gcongr
      exact measureReal_union_le _ _
    _ ≤ 2 * Real.exp (-(n : ℝ)) +
        Real.exp (-2 * (m : ℝ) *
          (ε / 2 - 4 * Real.exp
            (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
      rw [hlabelRealZero, add_zero]
      linarith
    _ = _ := by rfl

/-- Four-exponential form of the assembled recovery theorem.  Unlike an
asymptotic sample-size slogan, the last hypothesis states the exact arithmetic
needed for the ideal-label deviation term to be at most `2 exp (-n)`. -/
theorem exists_canonicalSpectralClustering_four_exp_tail_of_thresholds :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (ε : ℝ),
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := C *
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
          (latentNoiseSampleMeasure m n).real
              {ω | ¬ MakesAtMostErrorsUpToSign
                (fun i ↦ canonicalLabel ω i)
                (fun j ↦
                  NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                    hn (fun i ↦ canonicalPoint mean ω i) j)
                (fun i ↦ canonicalPoint mean ω i) (ε * m)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, htail⟩ :=
    exists_canonicalSpectralClustering_tail_of_thresholds
  refine ⟨C, hC, ?_⟩
  intro m n hm hn mean hmean ε
  dsimp only
  intro hidealScale hbudget hidealTail
  have h := htail hm hn mean hmean ε hidealScale hbudget
  linarith

end NumStability.HDP.Vector.GaussianMixture
