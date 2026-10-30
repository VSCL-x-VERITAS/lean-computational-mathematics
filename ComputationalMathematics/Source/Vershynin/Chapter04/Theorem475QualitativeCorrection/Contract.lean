import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem475QualitativeCorrection.ProofSupport

/-!
# Qualitative Gaussian spectral recovery

The independently audited analyst correction uses a parameter-dependent sample
cutoff and the actual spectral algorithm. Its guarantee is distinct from the
printed polynomial sample condition.
-/

noncomputable section
set_option warningAsError true
open MeasureTheory

namespace NumStability.HDP.Contract

/-- A separately named analyst correction: parameter-dependent sufficient
sample cutoff, actual algorithm output and measurable original-law certificate.
This is not the printed power-law sample condition. -/
def HDP04QualitativeCorrectedGaussianRecovery : Prop :=
    ∀ (n : ℕ) (hn : 0 < n) (mean : Fin n → ℝ)
    (_hmean : 0 < NumStability.vecNorm2 mean)
    (epsilon : ℝ) (_hepsilon : 0 < epsilon)
    (_hideal : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2),
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
            (direction ω) (X ω) (epsilon * m)

/-- Independently audited analyst correction with a parameter-dependent cutoff. -/
theorem hdp_04_theorem_4_7_5_qualitative_corrected_recovery :
    HDP04QualitativeCorrectedGaussianRecovery := by
  intro n hn mean hmean epsilon hepsilon hideal
  exact NumStability.HDP.Contract.Theorem475QualitativeCorrection.exists_sample_cutoff_for_actual_spectral_recovery
    hn mean hmean epsilon hepsilon hideal

end NumStability.HDP.Contract
