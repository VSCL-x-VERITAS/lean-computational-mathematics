import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeverageSketching

/-!
# Least-squares existence and exact-leverage output contracts

Equation (8), p. 86, has a minimizer for every finite real input, including
rank-deficient and empty matrices. The separate page-87 exact-leverage case
selects both an original minimizer and exact sketch minimizers and proves their
relative residual guarantee. Classical selection makes no computational-cost
or approximate-leverage-score assertion.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Equation (8): existence of a minimizer for both the squared library
objective and the paper's unsquared Euclidean residual, without rank hypotheses. -/
def leastSquaresMinimizerExists : Prop :=
  ∀ (m n : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ),
    ∃ xOpt : Fin n → ℝ,
      IsLeastSquaresMinimizer A b xOpt ∧
      ∀ x, vecNorm2 (lsResidual A b xOpt) ≤ vecNorm2 (lsResidual A b x)

/-- Mathematical exact-leverage case of the page-87 algorithm: original and
sampled minimizers exist and their returned residual satisfies the guarantee.
No minimizer or final error bound is supplied as a premise. Positive input rank
includes one; the all-rank minimizer-existence contract above includes rank zero. -/
def exactLeverageLeastSquaresOutput : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0))) (η δ : ℝ),
    0 < s → 0 < η → η < 1 → 0 < δ → δ < 1 →
    10 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) *
      Real.log ((4 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)) / δ) ≤ (s : ℝ) →
    8 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) / (η * δ) ≤ (s : ℝ) →
      ∃ (xOpt : Fin n → ℝ) (xHat : RowTrace m s → Fin n → ℝ),
        IsLeastSquaresMinimizer A b xOpt ∧
        (∀ samples, IsLeastSquaresMinimizer
          (rowSampleLSMatrixWithBasisScale s (lsColumnSpaceBasisMatrix A) A samples)
          (rowSampleLSVectorWithBasisScale s (lsColumnSpaceBasisMatrix A) b samples)
          (xHat samples)) ∧
        1 - δ ≤ (leverageTraceProbability (steps := s) (lsColumnSpaceBasisMatrix A)
          (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd).eventProb
          {samples | vecNorm2 (lsResidual A b (xHat samples)) ≤
            (1 + η) * vecNorm2 (lsResidual A b xOpt)}

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
