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

end NumStability.Source.DrineasMahoney.RandNLA2016
