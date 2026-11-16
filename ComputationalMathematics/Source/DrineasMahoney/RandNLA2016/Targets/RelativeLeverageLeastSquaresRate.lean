import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeastSquaresConstructions

/-! # Quantitative children of supplied-score leverage least squares

The score tolerance α is separate from residual tolerance ε. Its unavoidable
factor β⁻¹ is explicit. Bounded score tolerance α≤1/2 gives β⁻¹≤3, hence the
source scale with an absolute constant. No score-computation cost is asserted.
-/
namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets
open scoped BigOperators

/-- Exact outputs of the literal shared A/b importance-sampling sketch. -/
def IsRelativeLeverageLeastSquaresOutput {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ) (P : FiniteProbability (Fin m))
    (xHat : RowTrace m s → Fin n → ℝ) : Prop :=
  ∀ samples, IsLeastSquaresMinimizer (rowSampleSketchWithProb s A P.prob samples)
    (rowSampleVectorWithProb P.prob b samples) (xHat samples)

/-- Rank-complete quality of the actual supplied-score law, including existence
of actual outputs. Rank zero returns0 without dividing by a zero score sum. -/
def RelativeLeverageLeastSquaresQuality {m n : ℕ} (s : ℕ)
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ) (a : Fin m → ℝ)
    (α : ℝ) (hα : α < 1) (ha : ∀ _hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
      RelativeLeverageScores (lsColumnSpaceBasisMatrix A) a α)
    (ε : ℝ) : Prop :=
  (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) = 0 →
    IsLeastSquaresMinimizer A b (fun _ => 0) ∧
    ∀ xOpt : Fin n → ℝ, IsLeastSquaresMinimizer A b xOpt →
      vecNorm2 (lsResidual A b (fun _ => 0)) ≤ (1 + ε) * vecNorm2 (lsResidual A b xOpt)) ∧
  ∀ hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
    let P := relativeLeverageScoreProbability (lsColumnSpaceBasisMatrix A)
      (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd a hα (ha hd)
    (∃ xHat : RowTrace m s → Fin n → ℝ, IsRelativeLeverageLeastSquaresOutput A b P xHat) ∧
    ∀ (xHat : RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ),
      IsRelativeLeverageLeastSquaresOutput A b P xHat → IsLeastSquaresMinimizer A b xOpt →
      (1 / 2 : ℝ) ≤ (P.iid s).eventProb
        {samples | vecNorm2 (lsResidual A b (xHat samples)) ≤ (1 + ε) * vecNorm2 (lsResidual A b xOpt)}

/-- Original026-relative-error: every sufficient integer sample count for the
actual normalized approximate scores, with reciprocal accuracy dependence. -/
def relativeLeverageLeastSquaresRelativeError : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
      (a : Fin m → ℝ) (α ε : ℝ) (hα : α < 1)
      (ha : ∀ _hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
      RelativeLeverageScores (lsColumnSpaceBasisMatrix A) a α),
      0 < m → 0 < n → 0 < s → 0 ≤ α → 0 < ε → ε < 1 →
      C * (n : ℝ) * Real.log (2 * (m : ℝ)) / (((1 - α) / (1 + α)) * ε) ≤ (s : ℝ) →
      RelativeLeverageLeastSquaresQuality s A b a α hα ha ε

/-- Original026-samples: the ceiling of a dimension/accuracy/score-tolerance
budget gives successful actual outputs, and remains at most twice its scale. -/
def relativeLeverageLeastSquaresSamples : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ (m n : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
      (a : Fin m → ℝ) (α ε : ℝ) (hα : α < 1)
      (ha : ∀ _hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
      RelativeLeverageScores (lsColumnSpaceBasisMatrix A) a α),
      0 < m → 0 < n → 0 ≤ α → 0 < ε → ε < 1 →
      ∃ s : ℕ,
        s = ⌈C * (n : ℝ) * Real.log (2 * (m : ℝ)) / (((1 - α) / (1 + α)) * ε)⌉₊ ∧
        0 < s ∧ (s : ℝ) ≤ 2 * C * (n : ℝ) * Real.log (2 * (m : ℝ)) / (((1 - α) / (1 + α)) * ε) ∧
        RelativeLeverageLeastSquaresQuality s A b a α hα ha ε

/-- Source-scale relative-error child with a uniformly bounded internal score
approximation tolerance. In particular α=min(ε,1/2) is permitted. -/
def relativeLeverageLeastSquaresSourceRelativeError : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
      (a : Fin m → ℝ) (α ε : ℝ) (hα : α < 1)
      (ha : ∀ _hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
      RelativeLeverageScores (lsColumnSpaceBasisMatrix A) a α),
      0 < m → 0 < n → 0 < s → 0 ≤ α → α ≤ 1 / 2 → 0 < ε → ε < 1 →
      C * (n : ℝ) * Real.log (2 * (m : ℝ)) / ε ≤ (s : ℝ) →
      RelativeLeverageLeastSquaresQuality s A b a α hα ha ε

/-- Source-scale samples child for bounded supplied-score tolerance. Its
integer witness depends only on dimensions and residual accuracy. -/
def relativeLeverageLeastSquaresSourceSamples : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ (m n : ℕ) (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
      (a : Fin m → ℝ) (α ε : ℝ) (hα : α < 1)
      (ha : ∀ _hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)),
      RelativeLeverageScores (lsColumnSpaceBasisMatrix A) a α),
      0 < m → 0 < n → 0 ≤ α → α ≤ 1 / 2 → 0 < ε → ε < 1 →
      ∃ s : ℕ,
        s = ⌈C * (n : ℝ) * Real.log (2 * (m : ℝ)) / ε⌉₊ ∧
        0 < s ∧ (s : ℝ) ≤ 2 * C * (n : ℝ) * Real.log (2 * (m : ℝ)) / ε ∧
        RelativeLeverageLeastSquaresQuality s A b a α hα ha ε

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
