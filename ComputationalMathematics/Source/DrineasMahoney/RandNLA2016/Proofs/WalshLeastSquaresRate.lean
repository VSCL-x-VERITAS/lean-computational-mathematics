import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.Existence
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.SampleBudgets
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation08.LeastSquaresSketch.HadamardRelativeErrorRate
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.WalshLeastSquaresRate

/-! # Relative residual guarantee for Walsh least-squares sketches -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

private theorem walsh_output_exists {q n s : ℕ}
    (A : Fin (2 ^ q) → Fin n → ℝ) (b : Fin (2 ^ q) → ℝ) :
    ∃ xHat : RademacherTrace (2 ^ q) × RowTrace (2 ^ q) s → Fin n → ℝ,
      Targets.IsWalshLeastSquaresOutput A b xHat := by
  refine ⟨fun z => leastSquaresMinimizer
    (rowSampleSketchWithProb s (preconditionRows
      (matMul (2 ^ q) (Targets.leastSquaresWalshMatrix q)
        (diagMatrix (rademacherSignVector z.1))) A) uniformRowProb z.2)
    (rowSampleVectorWithProb uniformRowProb (matMulVec (2 ^ q)
      (matMul (2 ^ q) (Targets.leastSquaresWalshMatrix q)
        (diagMatrix (rademacherSignVector z.1))) b) z.2), ?_⟩
  intro ω samples
  exact leastSquaresMinimizer_isLeastSquaresMinimizer _ _

theorem walshUniformLeastSquaresRelativeError : Targets.walshUniformLeastSquaresRelativeError := by
  refine ⟨4096, by norm_num, ?_⟩
  intro q n s A b hm ε _hn hs hε hεone hbudget
  refine ⟨walsh_output_exists A b, ?_⟩
  intro xHat xOpt hhat hopt
  by_cases hz : Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) = 0
  · have hevent : (signedHadamardUniformRowTraceProbability (m := 2 ^ q) (s := s) hm).eventProb
        {z | vecNorm2 (lsResidual A b (xHat z)) ≤ (1 + ε) * vecNorm2 (lsResidual A b xOpt)} = 1 := by
      apply FiniteProbability.eventProb_eq_one_of_forall
      intro z
      exact lsResidual_norm_le_one_add_eta_of_zero_column_rank A b hz (xHat z) xOpt hε.le
    rw [hevent]; norm_num
  · have hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) := Nat.pos_of_ne_zero hz
    have hb := hadamard_ls_budgets_le_source_scale hm hd
      (lsColumnSpace_rank_le_rows A) (lsColumnSpace_rank_le_columns A) hε hεone.le
    have hp := signedHadamardUniformRowTraceProbability_eventProb_lsResidual_norm_le_one_add_eta_of_rank_sample_count
      (Targets.leastSquaresWalshMatrix q) A b
      (isOrthogonal_sqrt_inv_nat_mul_sylvesterSignPattern q)
      (hadamardFlat_sqrt_inv_nat_mul_sylvesterSignPattern q) hm hd
      (by exact_mod_cast hs) xHat xOpt hopt hhat hε
      (δ := (1 / 2 : ℝ)) (by norm_num) (by norm_num)
      (by
        dsimp at hb ⊢
        rw [show (2 * (((2 ^ q : ℕ) : ℝ))) / (1 / 2) = 4 * (((2 ^ q : ℕ) : ℝ)) by ring,
          show (4 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)) / (1 / 2) =
            8 * (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ) by ring]
        exact hb.1.trans hbudget)
      (by
        dsimp at hb ⊢
        rw [show (2 * (((2 ^ q : ℕ) : ℝ))) / (1 / 2) = 4 * (((2 ^ q : ℕ) : ℝ)) by ring]
        convert hb.2.trans hbudget using 1; ring)

    norm_num at hp ⊢
    exact hp

theorem walshUniformLeastSquaresSamples : Targets.walshUniformLeastSquaresSamples := by
  obtain ⟨C, hC, hquality⟩ := walshUniformLeastSquaresRelativeError
  refine ⟨C, hC, ?_⟩
  intro q n A b hm ε hn hε hεone
  let B := C * (n : ℝ) * Real.log (2 * ((2 ^ q : ℕ) : ℝ)) / ε
  have hmR : (1 : ℝ) ≤ ((2 ^ q : ℕ) : ℝ) := by exact_mod_cast hm
  have hnR : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hlog : (1 / 2 : ℝ) ≤ Real.log (2 * ((2 ^ q : ℕ) : ℝ)) := by
    have := Real.log_le_log (show (0 : ℝ) < 2 by norm_num)
      (show (2 : ℝ) ≤ 2 * ((2 ^ q : ℕ) : ℝ) by linarith)
    linarith [Real.log_two_gt_d9]
  have hBpos : 0 < B := by dsimp [B]; positivity
  have hceilpos : 0 < ⌈B⌉₊ := by
    exact Nat.ceil_pos.mpr hBpos
  have hceil : B ≤ (⌈B⌉₊ : ℝ) := Nat.le_ceil B
  have hBhalf : (1 / 2 : ℝ) ≤ B := by
    apply (le_div_iff₀ hε).mpr
    have hCn : 1 ≤ C * (n : ℝ) := by nlinarith
    have := mul_le_mul_of_nonneg_right hCn (show 0 ≤ Real.log (2 * ((2 ^ q : ℕ) : ℝ)) by linarith)
    nlinarith
  -- Increasing the witness constant ensures one full unit for rounding.
  -- The proof below uses C≥1 and the sharp lower logarithm bound.
  have hB : 1 ≤ 2 * B := by linarith
  have hupper : (⌈B⌉₊ : ℝ) ≤ 2 * B := by
    by_cases hBle : B ≤ 1
    · have hc : ⌈B⌉₊ ≤ 1 := (Nat.ceil_le).mpr (by exact_mod_cast hBle)
      exact (show (⌈B⌉₊ : ℝ) ≤ 1 by exact_mod_cast hc).trans hB
    · have hB1 : 1 ≤ B := (lt_of_not_ge hBle).le
      have hc := Nat.ceil_lt_add_one (show 0 ≤ B by positivity)
      linarith
  obtain ⟨hexists, hall⟩ := hquality q n ⌈B⌉₊ A b hm ε hn hceilpos hε hεone hceil
  obtain ⟨xHat, hhat⟩ := hexists
  refine ⟨⌈B⌉₊, rfl, hceilpos, ?_, xHat, hhat, ?_⟩
  · convert hupper using 1; dsimp [B]; ring
  · intro xOpt hopt
    exact hall xHat xOpt hhat hopt

end NumStability.Source.DrineasMahoney.RandNLA2016
