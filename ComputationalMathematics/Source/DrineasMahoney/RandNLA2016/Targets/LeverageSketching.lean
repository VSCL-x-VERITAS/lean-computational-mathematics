import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.ResidualCross
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation07.SubspaceEmbedding.Leverage

/-!
# Exact leverage sketching source contracts

Equation (7), p. 85, is instantiated by Algorithm 2 with the exact normalized
leverage distribution of a positive-dimensional orthonormal basis. The stated
sample budget is an explicit sufficient second-moment budget; the survey does
not specify an equation-(7) sample count.

Equation (8), p. 86, minimizes the unsquared Euclidean residual. Its page-87
sampling consequence is represented here for exact leverage probabilities and
exact sketch minimizers, with the same sampled rows and scaling for `A` and
`b`. Positive input rank includes one. Rank zero has a separate deterministic
branch because the normalized leverage distribution is undefined there.

These contracts concern mathematical guarantees. Approximate leverage-score
construction, its computational cost, and the survey's running-time assertions
are separate obligations and are not asserted by these contracts.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Equation (7), with a literal independent leverage row sketch and a
sufficient sample budget, including the displayed identity-Gram equality. -/
def leverageSubspaceEmbedding : Prop :=
  ∀ (m n s : ℕ) (U : Fin m → Fin n → ℝ)
    (hU : HasOrthonormalColumns U) (hn : 0 < n)
    (ε δ : ℝ),
    0 < s → 0 < ε → ε < 1 → 0 < δ → δ < 1 →
    1 / ((s : ℝ) * (ε / (n : ℝ)) ^ 2) ≤ δ →
      1 - δ ≤ (leverageTraceProbability (steps := s) U hU hn).eventProb
        {samples |
          opNorm2 (fun j k => rowGram U j k - rowSampleGram s U samples j k) =
            opNorm2 (fun j k => idMatrix n j k - rowSampleGram s U samples j k) ∧
          opNorm2 (fun j k => idMatrix n j k - rowSampleGram s U samples j k) ≤ ε}

/-- Equation (8)'s residual-norm minimization agrees with the squared objective
used by the library. Neither uniqueness nor exact solvability is required. -/
def leastSquaresResidualMinimum : Prop :=
  ∀ (m n : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ) (xOpt : Fin n → ℝ),
    IsLeastSquaresMinimizer A b xOpt ↔
      ∀ x, vecNorm2 (lsResidual A b xOpt) ≤ vecNorm2 (lsResidual A b x)

/-- Exact-leverage mathematical case of the page-87 LS guarantee, measured in
squared residual objective. The sample count depends reciprocally on accuracy
at fixed confidence. Basis dimension is the input rank, not augmented rank. -/
def leverageLeastSquaresObjective : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)))
    (xHat : RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ)
    (η δ : ℝ),
    0 < s → 0 < η → η < 1 → 0 < δ → δ < 1 →
    IsLeastSquaresMinimizer A b xOpt →
    (∀ samples, IsLeastSquaresMinimizer
      (rowSampleLSMatrixWithBasisScale s (lsColumnSpaceBasisMatrix A) A samples)
      (rowSampleLSVectorWithBasisScale s (lsColumnSpaceBasisMatrix A) b samples)
      (xHat samples)) →
    10 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) *
      Real.log ((4 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)) / δ) ≤ (s : ℝ) →
    8 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) / (η * δ) ≤ (s : ℝ) →
      1 - δ ≤ (leverageTraceProbability (steps := s) (lsColumnSpaceBasisMatrix A)
        (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd).eventProb
        {samples | lsObjective A b (xHat samples) ≤ (1 + η) * lsObjective A b xOpt}

/-- The same exact-leverage sampler and exact sketch solution, measured in
Equation (8)'s unsquared Euclidean residual norm. -/
def leverageLeastSquaresResidualNorm : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)))
    (xHat : RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ)
    (η δ : ℝ),
    0 < s → 0 < η → η < 1 → 0 < δ → δ < 1 →
    IsLeastSquaresMinimizer A b xOpt →
    (∀ samples, IsLeastSquaresMinimizer
      (rowSampleLSMatrixWithBasisScale s (lsColumnSpaceBasisMatrix A) A samples)
      (rowSampleLSVectorWithBasisScale s (lsColumnSpaceBasisMatrix A) b samples)
      (xHat samples)) →
    10 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) *
      Real.log ((4 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)) / δ) ≤ (s : ℝ) →
    8 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) / (η * δ) ≤ (s : ℝ) →
      1 - δ ≤ (leverageTraceProbability (steps := s) (lsColumnSpaceBasisMatrix A)
        (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd).eventProb
        {samples | vecNorm2 (lsResidual A b (xHat samples)) ≤
          (1 + η) * vecNorm2 (lsResidual A b xOpt)}

/-- Zero input rank: every coefficient vector has the same residual objective;
no normalized leverage sampler or probability law is introduced. -/
def zeroRankLeastSquares : Prop :=
  ∀ (m n : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ),
    Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) = 0 →
    ∀ (xHat xOpt : Fin n → ℝ) (η : ℝ), 0 ≤ η →
      lsObjective A b xHat ≤ (1 + η) * lsObjective A b xOpt ∧
      vecNorm2 (lsResidual A b xHat) ≤ (1 + η) * vecNorm2 (lsResidual A b xOpt)

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
