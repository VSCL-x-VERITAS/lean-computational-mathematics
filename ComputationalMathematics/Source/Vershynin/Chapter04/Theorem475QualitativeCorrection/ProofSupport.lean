import ComputationalMathematics.HDP.Vector.GaussianRecoveryBudget
import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem475.Contract

/-!
# Qualitative Gaussian recovery proof support

This parameter-dependent cutoff forwards the existing quantitative recovery
certificate after applying the source-independent eventual budget limits.
It is distinct from the printed polynomial sample claim.
-/

noncomputable section
set_option warningAsError true
open MeasureTheory

namespace NumStability.HDP.Contract.Theorem475QualitativeCorrection

theorem exists_sample_cutoff_for_actual_spectral_recovery
    {n : ℕ} (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean)
    (epsilon : ℝ) (hepsilon : 0 < epsilon)
    (hideal : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2) :
    ∃ M : ℕ, 0 < M ∧ ∀ {m : ℕ}, M ≤ m →
      let X := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i =>
        NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i
      let matrix := fun ω a b => (m : ℝ)⁻¹ * ∑ i, X ω i a * X ω i b
      let direction := fun ω j =>
        NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn (X ω) j
      (∀ ω,
        (∑ j, direction ω j ^ 2) = 1 ∧
        (∃ eigenvalue : ℝ,
          (∀ a, (∑ b, matrix ω a b * direction ω b) = eigenvalue * direction ω a) ∧
          (∀ w : Fin n → ℝ, (∑ j, w j ^ 2) = 1 →
            (∑ a, w a * ∑ b, matrix ω a b * w b) ≤ eigenvalue)) ∧
        (∃ first second : Set (Fin m),
          (∀ i, i ∈ first ↔ 0 < ∑ j, direction ω j * X ω i j) ∧
          (∀ i, i ∈ second ↔ (∑ j, direction ω j * X ω i j) ≤ 0))) ∧
      ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
        MeasurableSet good ∧
        1 - 4 * Real.exp (-(n : ℝ)) ≤
          (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real good ∧
        ∀ ω ∈ good,
          NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
            (fun i => NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
            (direction ω) (X ω) (epsilon * m) := by
  obtain ⟨Ccov, _hCcov, hcorrected⟩ :=
    NumStability.HDP.Contract.hdp_04_theorem_4_7_5_corrected_thresholds_measurable_success
  have heventual := NumStability.HDP.Vector.GaussianMixture.eventually_budget_and_confidence Ccov n
    (NumStability.vecNorm2 mean) epsilon hmean hepsilon hideal
  obtain ⟨M, hM⟩ := Filter.eventually_atTop.mp heventual
  refine ⟨max M 1, by omega, ?_⟩
  intro m hm
  have hmpositive : 0 < m := by omega
  obtain ⟨hbudget, hconfidence⟩ := hM m ((le_max_left M 1).trans hm)
  exact hcorrected hmpositive hn mean hmean epsilon hideal hbudget hconfidence


end NumStability.HDP.Contract.Theorem475QualitativeCorrection
