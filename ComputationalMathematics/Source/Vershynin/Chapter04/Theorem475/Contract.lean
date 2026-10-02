import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionRecovery

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

end NumStability.HDP.Contract
