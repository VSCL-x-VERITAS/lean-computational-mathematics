import ComputationalMathematics.HDP.Vector.GaussianMixtureAllUnitThresholds
import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise476.Contract

/-! Proof-free analyst-derived child targets for independent V6 source review.
The two correction targets are distinct from their printed parent IDs. -/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped BigOperators RealInnerProductSpace ENNReal
open NumStability.HDP.Vector.GaussianMixture

namespace NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit

/-- One global identity or swap for the printed strict-positive/nonpositive
partition. Zero scores belong to the nonpositive output class. -/
def betterMatchingErrorCount {m n : ℕ} (labels : Fin m → ℝ)
    (v : EuclideanSpace ℝ (Fin n)) (X : Fin m → Fin n → ℝ) : ℝ :=
  min
    ((Set.ncard {i : Fin m |
      ¬ ((0 < ∑ j, v j * X i j) ↔ labels i = 1)} : ℝ))
    ((Set.ncard {i : Fin m |
      ¬ ((0 < ∑ j, v j * X i j) ↔ labels i = -1)} : ℝ))

/-- The original IID fair-label and standard-Gaussian-noise joint model,
including finite rectangle independence and the observed mixture marginal. -/
def jointLawContract {m n : ℕ} (mean : Fin n → ℝ) : Prop :=
  let μ := latentNoiseSampleMeasure m n
  μ Set.univ = 1 ∧
    (∀ (S : Finset (Fin m)) (L : Fin m → Set ℝ)
        (B : Fin m → Set (Fin n → ℝ)),
      (∀ i ∈ S, MeasurableSet (L i)) →
      (∀ i ∈ S, MeasurableSet (B i)) →
      μ {ω | ∀ i ∈ S, (ω i).1 ∈ L i ∧ (ω i).2 ∈ B i} =
        ∏ i ∈ S,
          NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure (L i) *
            NumStability.standardGaussianVectorMeasure n (B i)) ∧
    (∀ i : Fin m, μ {ω | (ω i).1 = -1} = 1 / 2 ∧
      μ {ω | (ω i).1 = 1} = 1 / 2) ∧
    (∀ i : Fin m,
      Measurable (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalPoint mean ω i) ∧
      μ.map (fun ω ↦ canonicalPoint mean ω i) =
        gaussianMixtureMeasure mean)

/-- Unit top vectors satisfy the exact empirical eigenvalue, maximal Rayleigh
quotient, and the printed output partition. -/
def unitTopOutputContract {m n : ℕ} (hn : 0 < n)
    (X : Fin m → Fin n → ℝ) (v : EuclideanSpace ℝ (Fin n)) : Prop :=
  let M := NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X
  ‖v‖ = 1 ∧
    M.toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
        ⟨0, hn⟩ • v ∧
    (∀ w : EuclideanSpace ℝ (Fin n), ‖w‖ = 1 →
      NumStability.matrixRayleighForm M w ≤ NumStability.matrixRayleighForm M v) ∧
    (∃ first second : Set (Fin m),
      (∀ i, i ∈ first ↔ 0 < ∑ j, v j * X i j) ∧
      (∀ i, i ∈ second ↔ (∑ j, v j * X i j) ≤ 0))

/-- Exact three-threshold simultaneous guarantee. The absolute covariance
constant precedes all data and all rules; good precedes every vector and rule. -/
def allUnitFinalThresholds : Prop :=
  ∃ Ccov : ℝ, 0 < Ccov ∧
    ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
      ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
      ∀ (epsilon : ℝ), 0 < epsilon →
        let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
        let delta : ℝ := Ccov *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) +
            Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
        let q : ℝ := L ^ 2 * max delta (delta ^ 2)
        let X := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i ↦ canonicalPoint mean ω i
        4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2 →
        (2 * Real.sqrt q) ^ 2 *
          ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
            epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
        Real.exp (-2 * (m : ℝ) *
          (epsilon / 2 -
            4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
          2 * Real.exp (-(n : ℝ)) →
        (∀ (sample : Fin m → Fin n → ℝ)
            (v : EuclideanSpace ℝ (Fin n)),
          IsUnitTopEmpiricalEigenvector hn sample v →
          unitTopOutputContract hn sample v) ∧
        ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
          MeasurableSet good ∧
          1 - 4 * Real.exp (-(n : ℝ)) ≤
            (latentNoiseSampleMeasure m n).real good ∧
          (∀ ω ∈ good, (∀ i : Fin m, (ω i).1 = -1 ∨ (ω i).1 = 1) ∧
            ∀ v : EuclideanSpace ℝ (Fin n),
              IsUnitTopEmpiricalEigenvector hn (X ω) v →
              betterMatchingErrorCount (fun i ↦ (ω i).1) v (X ω) ≤
                epsilon * m) ∧
          (∀ rule : (Fin m → Fin n → ℝ) → EuclideanSpace ℝ (Fin n),
            IsDataOnlyUnitTopRule hn rule →
            ∀ ω ∈ good,
              betterMatchingErrorCount (fun i ↦ (ω i).1)
                (rule (X ω)) (X ω) ≤ epsilon * m)

/-- The theorem's analyst correction: the original joint law and the full
all-unit conditional certificate, not a canonical-selector alias. -/
def HDP04Theorem475AllUnitCorrectionChildTarget : Prop :=
  (∀ {m n : ℕ}, 0 < m → 0 < n →
    ∀ (mean : Fin n → ℝ), jointLawContract (m := m) mean) ∧
    allUnitFinalThresholds

/-- Exercise stage (a), including the largest population eigenvalue and every
unit population top vector, valid also in dimension one. -/
def exercisePopulationAllUnitStage : Prop :=
  (∀ {n : ℕ} (mean : Fin n → ℝ),
    NumStability.HDP.Vector.Covariance.secondMomentMatrix
        (gaussianMixtureMeasure mean) (fun j x ↦ x j) =
      populationSecondMoment mean ∧
    populationSecondMoment mean =
      (fun i j ↦ (if i = j then 1 else 0) + mean i * mean j) ∧
    (populationSecondMoment mean).mulVec mean =
      (1 + NumStability.vecNorm2 mean ^ 2) • mean) ∧
  (∀ {n : ℕ} (hn : 0 < n) (mean : Fin n → ℝ),
    0 < NumStability.vecNorm2 mean →
    let M := populationSecondMoment mean
    let top := NumStability.hermitianOrderedEigenvalue
      (populationSecondMoment_isHermitian mean) ⟨0, hn⟩
    top = 1 + NumStability.vecNorm2 mean ^ 2 ∧
      ∀ v : EuclideanSpace ℝ (Fin n), ‖v‖ = 1 →
        M.toEuclideanLin v = top • v →
        ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
          v = s • populationDirection mean)

/-- Exercise stage (c), with positive sample size and every unit top vector. -/
def exercisePerturbationAllUnitStage : Prop :=
  ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
    ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
    ∀ (X : Fin m → Fin n → ℝ) (v : EuclideanSpace ℝ (Fin n)),
      IsUnitTopEmpiricalEigenvector hn X v →
      ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
        ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
          s • (NumStability.vecNorm2 mean • v)‖ ≤
          2 * Real.sqrt (NumStability.realMatrixOperatorNorm
            (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
              populationSecondMoment mean))

/-- Exercise stage (e), simultaneously for each unit top vector. It preserves
both the conservative sign-error and literal partition conclusions. -/
def exerciseTransferAllUnitStage : Prop :=
  ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
    ∀ (labels : Fin m → ℝ), (∀ i, labels i = -1 ∨ labels i = 1) →
    ∀ (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ),
      0 < NumStability.vecNorm2 mean →
      ∀ (epsilon tau q : ℝ), 0 < tau → 0 ≤ q →
        NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
            populationSecondMoment mean) ≤ q →
        (Set.ncard (idealMarginErrors labels mean X tau) : ℝ) ≤
          epsilon * m / 2 →
        (2 * Real.sqrt q) ^ 2 *
          ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
            epsilon / 2 * tau ^ 2 →
        ∀ v : EuclideanSpace ℝ (Fin n),
          IsUnitTopEmpiricalEigenvector hn X v →
          MakesAtMostErrorsUpToSign labels (fun j ↦ v j) X (epsilon * m) ∧
          betterMatchingErrorCount labels v X ≤ epsilon * m

/-- All five genuine exercise stages plus the SAME all-unit final certificate.
The old canonical selected-direction stage contracts are not imported as a
replacement for the uniform vector quantifiers. -/
def HDP04Exercise476AllUnitCorrectionChildTarget : Prop :=
  (∀ {m n : ℕ}, 0 < m → 0 < n →
    ∀ (mean : Fin n → ℝ), jointLawContract (m := m) mean) ∧
  exercisePopulationAllUnitStage ∧
  HDP04Exercise476CovarianceEstimationStage ∧
  exercisePerturbationAllUnitStage ∧
  HDP04Exercise476IdealClassificationStage ∧
  exerciseTransferAllUnitStage ∧
  allUnitFinalThresholds

end NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit
