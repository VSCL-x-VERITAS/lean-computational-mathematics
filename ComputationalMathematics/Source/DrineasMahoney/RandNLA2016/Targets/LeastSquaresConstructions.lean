import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.RelativeLeverageScores
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.UniformResidualCross
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.ExactTransforms.UniformRowComposition
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeastSquaresExistence

/-! # Page-87 joint least-squares sketch constructions

Original claims026/027 specify constructions separately from their quantitative
children. Scores in026 are supplied relative approximations, not silently exact
scores. The Walsh realization in027 has 2^q rows; padding is not implicit.
Neither contract asserts score-computation cost, running time or sketch quality.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets
open scoped BigOperators

/-- Original026 construction: normalize supplied relative scores, use an iid
common A/b row sampler, and return actual sketch minimizers. Rank zero returns0
without introducing a leverage denominator. -/
def relativeLeverageLeastSquaresConstruction : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (a : Fin m → ℝ) (α : ℝ),
    0 < m → 0 < n → 0 < s → 0 ≤ α → α < 1 →
    (∀ _hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
      RelativeLeverageScores (lsColumnSpaceBasisMatrix A) a α) →
      (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) = 0 →
        IsLeastSquaresMinimizer A b (fun _ => 0)) ∧
      ∀ _hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
        ∃ (P : FiniteProbability (Fin m)) (xHat : RowTrace m s → Fin n → ℝ),
          (∀ i, P.prob i = a i / ∑ j : Fin m, a j) ∧
          (∀ i, ((1 - α) / (1 + α)) *
            (rowNormSq (lsColumnSpaceBasisMatrix A) i /
              (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)) ≤ P.prob i) ∧
          (∀ samples, (P.iid s).prob samples = ∏ t, P.prob (samples t)) ∧
          (P.iid s).eventProb {samples | ∀ t, 0 < P.prob (samples t)} = 1 ∧
          (∀ (samples : RowTrace m s) (t : Fin s) (j : Fin n), rowSampleSketchWithProb s A P.prob samples t j =
            A (samples t) j / Real.sqrt ((s : ℝ) * P.prob (samples t))) ∧
          (∀ (samples : RowTrace m s) (t : Fin s), rowSampleVectorWithProb P.prob b samples t =
            b (samples t) / Real.sqrt ((s : ℝ) * P.prob (samples t))) ∧
          ∀ samples, IsLeastSquaresMinimizer
            (rowSampleSketchWithProb s A P.prob samples)
            (rowSampleVectorWithProb P.prob b samples) (xHat samples) ∧
            ∀ x, vecNorm2 (lsResidual
              (rowSampleSketchWithProb s A P.prob samples)
              (rowSampleVectorWithProb P.prob b samples) (xHat samples)) ≤
              vecNorm2 (lsResidual
                (rowSampleSketchWithProb s A P.prob samples)
                (rowSampleVectorWithProb P.prob b samples) x)

/-- The concrete normalized Walsh matrix used by original027. -/
noncomputable def leastSquaresWalshMatrix (q : ℕ) : Fin (2 ^ q) → Fin (2 ^ q) → ℝ :=
  fun i k => Real.sqrt (((2 ^ q : ℕ) : ℝ)⁻¹) * sylvesterHadamardSignPattern q i k

/-- Original027 construction: independent signs then independent uniform row
sampling, with the same HD transform and scale on A and b. All input ranks are
allowed; minimizers are actual outputs rather than hypotheses. -/
def walshUniformLeastSquaresConstruction : Prop :=
  ∀ (q n s : ℕ) (A : Fin (2 ^ q) → Fin n → ℝ) (b : Fin (2 ^ q) → ℝ)
    (hm : 0 < 2 ^ q), 0 < n → 0 < s →
      let m := 2 ^ q
      let H := leastSquaresWalshMatrix q
      IsOrthogonal m H ∧ HadamardFlat m H ∧
      ∃ xHat : RademacherTrace m × RowTrace m s → Fin n → ℝ,
        (∀ z, (signedHadamardUniformRowTraceProbability (m := m) (s := s) hm).prob z =
          (rademacherTraceProbability m).prob z.1 *
            (uniformRowTraceProbability (steps := s) hm).prob z.2) ∧
        (∀ samples, (uniformRowTraceProbability (steps := s) hm).prob samples =
          ∏ _t : Fin s, ((m : ℝ)⁻¹)) ∧
        ∀ (ω : RademacherTrace m) (samples : RowTrace m s),
          let T := matMul m H (diagMatrix (rademacherSignVector ω))
          let B := preconditionRows T A
          let c := matMulVec m T b
          (∀ t j, rowSampleSketchWithProb s B uniformRowProb samples t j =
            Real.sqrt ((m : ℝ) / (s : ℝ)) * B (samples t) j) ∧
          (∀ t, rowSampleVectorWithProb uniformRowProb c samples t =
            Real.sqrt ((m : ℝ) / (s : ℝ)) * c (samples t)) ∧
          IsLeastSquaresMinimizer
            (rowSampleSketchWithProb s B uniformRowProb samples)
            (rowSampleVectorWithProb uniformRowProb c samples) (xHat (ω, samples)) ∧
          ∀ x, vecNorm2 (lsResidual
            (rowSampleSketchWithProb s B uniformRowProb samples)
            (rowSampleVectorWithProb uniformRowProb c samples) (xHat (ω, samples))) ≤
            vecNorm2 (lsResidual
              (rowSampleSketchWithProb s B uniformRowProb samples)
              (rowSampleVectorWithProb uniformRowProb c samples) x)

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
