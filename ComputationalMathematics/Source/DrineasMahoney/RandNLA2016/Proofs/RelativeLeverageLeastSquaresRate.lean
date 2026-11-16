import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.Existence
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.DominatedResidualCross
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.SampleBudgets
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.RelativeLeverageLeastSquaresRate

/-!
# Supplied relative-leverage least-squares rates

These wrappers establish the quantitative contracts for actual normalized
supplied scores and exact minimizers, including the rank-zero branch. The score
approximation factor remains explicit; no score-computation cost is asserted.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

/-- The supplied approximate-score algorithm has reciprocal residual-accuracy
sample dependence; its analysis uses the actual normalized scores. -/
theorem relativeLeverageLeastSquaresRelativeError : Targets.relativeLeverageLeastSquaresRelativeError := by
  refine ⟨4096, by norm_num, ?_⟩
  intro m n s A b a α ε hα ha hm _hn hs hα0 hε hεone hbudget
  have hβ : 0 < (1 - α) / (1 + α) := div_pos (by linarith) (by linarith)
  have hβone : (1 - α) / (1 + α) ≤ 1 := (div_le_one (by linarith)).mpr (by linarith)
  constructor
  · intro hz
    constructor
    · intro y
      exact le_of_eq (lsObjective_eq_of_zero_columnSpace_basis A hz b (fun _ => 0) y)
    · intro xOpt _hopt
      apply lsResidual_norm_le_of_objective_le hε.le
      rw [lsObjective_eq_of_zero_columnSpace_basis A hz b (fun _ => 0) xOpt]
      have := lsObjective_nonneg A b xOpt
      nlinarith
  · intro hd
    let U := lsColumnSpaceBasisMatrix A
    let P := relativeLeverageScoreProbability U (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd a hα (ha hd)
    have hdom : ∀ i, ((1 - α) / (1 + α)) * rowNormSq U i /
        (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) ≤ P.prob i := by
      intro i
      simpa only [mul_div_assoc] using relativeLeverageScoreProbability_ge_fraction U
        (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd a hα0 hα (ha hd) i
    constructor
    · exact ⟨fun samples => leastSquaresMinimizer
        (rowSampleSketchWithProb s A P.prob samples) (rowSampleVectorWithProb P.prob b samples),
        fun _ => leastSquaresMinimizer_isLeastSquaresMinimizer _ _⟩
    · intro xHat xOpt hhat hopt
      have hb := dominated_leverage_ls_budgets_le_source_scale hm hd
        (lsColumnSpace_rank_le_rows A) (lsColumnSpace_rank_le_columns A) hε hεone.le hβ
      have hp := dominatedLeverageTraceProbability_eventProb_lsObjective_le_one_add_eta A b U
        (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) (lsColumnSpaceColumnCoords A)
        (lsColumnSpaceBasisInputCoords A) (lsColumnSpaceBasisMatrix_input_representation A)
        (lsColumnSpaceBasisMatrix_range_representation A) P hd (by exact_mod_cast hs)
        xHat xOpt hopt hhat hβ hβone hε (δ := (1 / 2 : ℝ)) (by norm_num) (by norm_num) hdom
        (by
          dsimp at hb ⊢
          rw [show (2 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)) / (1 / 2) =
            4 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) by ring]
          exact hb.1.trans hbudget)
        (by
          dsimp at hb ⊢
          convert hb.2.trans hbudget using 1; ring)
      norm_num only [sub_half] at hp
      apply hp.trans
      apply FiniteProbability.eventProb_mono
      intro samples hgood
      exact lsResidual_norm_le_of_objective_le hε.le hgood

/-- The ceiling of the sufficient source-scale budget is a genuine successful
algorithm budget, including singular and zero matrices. -/
theorem relativeLeverageLeastSquaresSamples : Targets.relativeLeverageLeastSquaresSamples := by
  obtain ⟨C, hC, hquality⟩ := relativeLeverageLeastSquaresRelativeError
  refine ⟨C, hC, ?_⟩
  intro m n A b a α ε hα ha hm hn hα0 hε hεone
  have hβ : 0 < (1 - α) / (1 + α) := div_pos (by linarith) (by linarith)
  have hβone : (1 - α) / (1 + α) ≤ 1 := (div_le_one (by linarith)).mpr (by linarith)
  let B := C * (n : ℝ) * Real.log (2 * (m : ℝ)) / (((1 - α) / (1 + α)) * ε)
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hnR : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hlog : (1 / 2 : ℝ) ≤ Real.log (2 * (m : ℝ)) := by
    have := Real.log_le_log (show (0 : ℝ) < 2 by norm_num)
      (show (2 : ℝ) ≤ 2 * (m : ℝ) by linarith)
    linarith [Real.log_two_gt_d9]
  have hden : 0 < ((1 - α) / (1 + α)) * ε := mul_pos hβ hε
  have hdenone : ((1 - α) / (1 + α)) * ε ≤ 1 := by nlinarith
  have hBpos : 0 < B := by dsimp [B]; positivity
  have hceilpos : 0 < ⌈B⌉₊ := Nat.ceil_pos.mpr hBpos
  have hceil : B ≤ (⌈B⌉₊ : ℝ) := Nat.le_ceil B
  have hBhalf : (1 / 2 : ℝ) ≤ B := by
    apply (le_div_iff₀ hden).mpr
    have hCn : 1 ≤ C * (n : ℝ) := by nlinarith
    have := mul_le_mul_of_nonneg_right hCn (show 0 ≤ Real.log (2 * (m : ℝ)) by linarith)
    nlinarith
  have hB : 1 ≤ 2 * B := by linarith
  have hupper : (⌈B⌉₊ : ℝ) ≤ 2 * B := by
    by_cases hBle : B ≤ 1
    · have hc : ⌈B⌉₊ ≤ 1 := (Nat.ceil_le).mpr (by exact_mod_cast hBle)
      exact (show (⌈B⌉₊ : ℝ) ≤ 1 by exact_mod_cast hc).trans hB
    · have hB1 : 1 ≤ B := (lt_of_not_ge hBle).le
      have hc := Nat.ceil_lt_add_one (show 0 ≤ B by positivity)
      linarith
  refine ⟨⌈B⌉₊, rfl, hceilpos, ?_, ?_⟩
  · convert hupper using 1; dsimp [B]; ring
  · exact hquality m n ⌈B⌉₊ A b a α ε hα ha hm hn hceilpos hα0 hε hεone hceil

end NumStability.Source.DrineasMahoney.RandNLA2016
