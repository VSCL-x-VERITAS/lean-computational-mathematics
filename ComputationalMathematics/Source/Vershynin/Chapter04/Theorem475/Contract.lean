import ComputationalMathematics.HDP.Probability.BinaryTesting
import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionRecovery
import ComputationalMathematics.Source.Vershynin.Chapter04.Algorithm47SpectralClustering.Contract

/-!
# Vershynin Chapter 4, Theorem 4.7.5
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Contract

/-- A conditional finite-sample form associated with Theorem 4.7.5.  The three
additional displayed scalar hypotheses are the exact ideal-margin,
perturbation-budget, and ideal-count conditions used by the proved probability
argument.  This useful strengthened-hypothesis result is kept separate from the
audited source replacement below. -/
theorem hdp_04_theorem_4_7_5_conditional :
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
  obtain ⟨Ccov, hCcov, htail⟩ :=
    NumStability.HDP.Vector.GaussianMixture.exists_canonicalSpectralClustering_partition_four_exp_tail_of_thresholds
  refine ⟨1, 1, Ccov, by norm_num, by norm_num, hCcov, ?_⟩
  intro m n hm hn mean hmean ε _hε _hseparation _hsample
  exact htail hm hn mean hmean ε

/-- Conclusion-only weakening of Theorem 4.7.5 under its printed hypotheses.
The objects, algorithm, quantifiers, and hypotheses are unchanged, while the
allowed error fraction is enlarged to `max ε (1 / 2)`.  The up-to-swap
interpretation makes this enlarged conclusion deterministic for binary labels;
the null exceptional label event is retained explicitly by the probability
model. -/
theorem hdp_04_theorem_4_7_5_weakened :
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
  refine ⟨1, 1, by norm_num, by norm_num, ?_⟩
  intro m n _hm hn mean ε _hε _hseparation _hsample
  rw [
    NumStability.HDP.Vector.GaussianMixture.canonicalSpectralClustering_partition_max_half_failure_measure_zero
      hn mean ε]
  positivity

/-- A sufficient-threshold correction of the printed recovery guarantee.
It uses the actual selected algorithm output and bounds real-valued outer
failure measure at the original epsilon error budget. The three inequalities
replace the printed separation/sample-size applicability policy. -/
def HDP04Theorem475CorrectedThresholds : Prop :=
  ∃ Ccov : ℝ, 0 < Ccov ∧
    ∀ {m n : ℕ}, 0 < m → (hn : 0 < n) →
      ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
      ∀ (epsilon : ℝ),
        let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
        let delta : ℝ := Ccov *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) +
            Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
        let q : ℝ := L ^ 2 * max delta (delta ^ 2)
        let X := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i ↦
          NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i
        let M := fun ω a b ↦ (m : ℝ)⁻¹ * ∑ i, X ω i a * X ω i b
        let direction := fun ω j ↦
          NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn (X ω) j
        4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2 →
        (2 * Real.sqrt q) ^ 2 *
            ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
          epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
        Real.exp (-2 * (m : ℝ) *
            (epsilon / 2 -
              4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
          2 * Real.exp (-(n : ℝ)) →
        (∀ ω,
          (∑ j, direction ω j ^ 2) = 1 ∧
          (∃ eigenvalue : ℝ,
            (∀ a, (∑ b, M ω a b * direction ω b) = eigenvalue * direction ω a) ∧
            (∀ w : Fin n → ℝ, (∑ j, w j ^ 2) = 1 →
              (∑ a, w a * ∑ b, M ω a b * w b) ≤ eigenvalue)) ∧
          (∃ first second : Set (Fin m),
            (∀ i, i ∈ first ↔ 0 < ∑ j, direction ω j * X ω i j) ∧
            (∀ i, i ∈ second ↔ (∑ j, direction ω j * X ω i j) ≤ 0))) ∧
        (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real
            {ω | ¬ NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
              (direction ω) (X ω) (epsilon * m)} ≤
          4 * Real.exp (-(n : ℝ))

/-- Epsilon-level recovery under the three genuinely used sufficient
thresholds, together with the actual algorithm's coordinate output properties.
This is a separately named correction, not literal source equivalence. -/
theorem hdp_04_theorem_4_7_5_corrected_thresholds :
    HDP04Theorem475CorrectedThresholds := by
  obtain ⟨Ccov, hCcov, htail⟩ :=
    NumStability.HDP.Vector.GaussianMixture.exists_canonicalSpectralClustering_partition_four_exp_tail_of_thresholds
  refine ⟨Ccov, hCcov, ?_⟩
  intro m n hm hn mean hmean epsilon
  dsimp only
  intro hideal hbudget hconfidence
  refine ⟨?_, htail hm hn mean hmean epsilon hideal hbudget hconfidence⟩
  intro ω
  exact hdp_04_algorithm_4_7_spectral_clustering hn
    (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)

/-- The sufficient-threshold correction with an original-space measurable
success certificate for the same actual selected direction. The full success
set and the selector are not assumed to be measurable. -/
def HDP04Theorem475MeasurableCorrectedThresholds : Prop :=
  ∃ Ccov : ℝ, 0 < Ccov ∧
    ∀ {m n : ℕ}, 0 < m → (hn : 0 < n) →
      ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
      ∀ (epsilon : ℝ),
        let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
        let delta : ℝ := Ccov *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) +
            Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
        let q : ℝ := L ^ 2 * max delta (delta ^ 2)
        let X := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i ↦
          NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i
        let M := fun ω a b ↦ (m : ℝ)⁻¹ * ∑ i, X ω i a * X ω i b
        let direction := fun ω j ↦
          NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn (X ω) j
        4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2 →
        (2 * Real.sqrt q) ^ 2 *
            ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
          epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
        Real.exp (-2 * (m : ℝ) *
            (epsilon / 2 -
              4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
          2 * Real.exp (-(n : ℝ)) →
        (∀ ω,
          (∑ j, direction ω j ^ 2) = 1 ∧
          (∃ eigenvalue : ℝ,
            (∀ a, (∑ b, M ω a b * direction ω b) = eigenvalue * direction ω a) ∧
            (∀ w : Fin n → ℝ, (∑ j, w j ^ 2) = 1 →
              (∑ a, w a * ∑ b, M ω a b * w b) ≤ eigenvalue)) ∧
          (∃ first second : Set (Fin m),
            (∀ i, i ∈ first ↔ 0 < ∑ j, direction ω j * X ω i j) ∧
            (∀ i, i ∈ second ↔ (∑ j, direction ω j * X ω i j) ≤ 0))) ∧
        ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
          MeasurableSet good ∧
          1 - 4 * Real.exp (-(n : ℝ)) ≤
            (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real good ∧
          ∀ ω ∈ good,
            NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
              (direction ω) (X ω) (epsilon * m)

/-- Ordinary probability of a measurable success certificate under all three
explicit sufficient thresholds, for the same actual algorithm output. -/
theorem hdp_04_theorem_4_7_5_corrected_thresholds_measurable_success :
    HDP04Theorem475MeasurableCorrectedThresholds := by
  obtain ⟨Ccov, hCcov, houter⟩ := hdp_04_theorem_4_7_5_corrected_thresholds
  refine ⟨Ccov, hCcov, ?_⟩
  intro m n hm hn mean hmean epsilon
  dsimp only
  intro hideal hbudget hconfidence
  obtain ⟨houtput, hfailure⟩ := houter hm hn mean hmean epsilon hideal hbudget hconfidence
  let mu := NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure mu :=
    ⟨by simp [mu, NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure]⟩
  let success : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
      (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
      (fun j ↦ NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
        hn (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i) j)
      (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)
      (epsilon * m)}
  obtain ⟨good, hgood, hsubset, hmass⟩ :=
    NumStability.HDP.Probability.exists_measurable_subset_of_failure_measureReal_le
      (μ := mu) success hfailure
  exact ⟨houtput, good, hgood, hmass, fun ω hω ↦ hsubset hω⟩

end NumStability.HDP.Contract
