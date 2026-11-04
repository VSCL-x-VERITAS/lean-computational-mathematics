import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise476.CounterexampleScalar
import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise476.CounterexampleCanonical
import ComputationalMathematics.HDP.Vector.GaussianMixtureCounterexample
import ComputationalMathematics.Source.Vershynin.Chapter04.Algorithm47SpectralClustering.Contract
import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem475.Contract

/-! Analyst-derived child specifications; not printed author statements.
Each declaration is a proof-free Prop for independent source/target review. -/

noncomputable section

open Filter MeasureTheory ProbabilityTheory Set
open scoped ENNReal
open NumStability.HDP.Contract.Exercise476CounterexampleScalar
open NumStability.HDP.Contract.Theorem475Counterexample
open NumStability.HDP.Probability

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04Theorem475WitnessChildTarget : Prop :=
  ∀ {A c : ℝ}, 0 < A → 0 < c →
    ∀ᶠ k : ℕ in atTop,
        0 < k ∧ ∃ (hn : 0 < dimension A c k),
          let mean : Fin (dimension A c k) → ℝ :=
            coordinateMean hn (radius A k)
          let μ := NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure
            k (dimension A c k)
          let points := fun i ω j ↦ (ω i).1 * mean j + (ω i).2 j
          0 < epsilon k ∧
          A * Real.sqrt (Real.log (1 / epsilon k)) ≤ NumStability.vecNorm2 mean ∧
          Real.rpow (((dimension A c k : ℕ) : ℝ) /
            NumStability.vecNorm2 mean) c ≤ (k : ℝ) ∧
          μ Set.univ = 1 ∧
          (∀ (S : Finset (Fin k)) (L : Fin k → Set ℝ)
            (B : Fin k → Set (Fin (dimension A c k) → ℝ)),
            (∀ i ∈ S, MeasurableSet (L i)) →
            (∀ i ∈ S, MeasurableSet (B i)) →
            μ {ω | ∀ i ∈ S, (ω i).1 ∈ L i ∧ (ω i).2 ∈ B i} =
              ∏ i ∈ S,
                NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure (L i) *
                  NumStability.standardGaussianVectorMeasure (dimension A c k) (B i)) ∧
          (∀ i, Measurable (points i) ∧
            μ.map (points i) =
              Measure.map (fun z : ℝ × (Fin (dimension A c k) → ℝ) ↦
                fun j ↦ z.1 * mean j + z.2 j)
                (NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure.prod
                  (NumStability.standardGaussianVectorMeasure (dimension A c k)))) ∧
          (∀ i, μ {ω | (ω i).1 = -1} = 1 / 2 ∧
            μ {ω | (ω i).1 = 1} = 1 / 2) ∧
          (∃ spectralRule :
              (Fin k → Fin (dimension A c k) → ℝ) → Fin (dimension A c k) → ℝ,
            ∀ X,
              let M : Matrix (Fin (dimension A c k)) (Fin (dimension A c k)) ℝ :=
                fun a b ↦ (k : ℝ)⁻¹ * ∑ i, X i a * X i b
              (∑ j, spectralRule X j ^ 2) = 1 ∧
                ∃ eigenvalue : ℝ,
                  (∀ a, (∑ b, M a b * spectralRule X b) = eigenvalue * spectralRule X a) ∧
                  ∀ w : Fin (dimension A c k) → ℝ, (∑ j, w j ^ 2) = 1 →
                    (∑ a, w a * ∑ b, M a b * w b) ≤ eigenvalue) ∧
          ∀ directionRule :
              (Fin k → Fin (dimension A c k) → ℝ) → Fin (dimension A c k) → ℝ,
            ∀ good : Set (Fin k → ℝ × (Fin (dimension A c k) → ℝ)),
              (∃ measurable : Set (Fin k → ℝ × (Fin (dimension A c k) → ℝ)),
                MeasurableSet measurable ∧ good =ᵐ[μ] measurable) →
              (∀ ω ∈ good,
              NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
                (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
                (directionRule (fun i ↦ points i ω)) (fun i ↦ points i ω)
                (epsilon k * k)) →
              μ.real good < 1 - 4 * Real.exp (-((dimension A c k : ℕ) : ℝ))

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04Theorem475CorrectionChildTarget : Prop :=
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

end NumStability.HDP.Contract.DiscrepancyChildren
