import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.ResidualCross

/-!
# Scalar least-squares sampling budgets

Rank comparisons and explicit scalar inequalities connect Walsh and supplied
leverage-dominated sampling budgets to dimension and accuracy scales. No
execution-cost or score-construction claim is made here.
-/

namespace NumStability
open scoped BigOperators

/-- The chosen column-space basis has at most the input number of columns. -/
theorem lsColumnSpace_rank_le_columns {m n : ℕ} (A : Fin m → Fin n → ℝ) :
    Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) ≤ n := by
  have heq : augmentedDataSpan A (fun _ => 0) =
      Submodule.span ℝ (Set.range (fun j : Fin n => euclideanVec (fun i => A i j))) := by
    apply le_antisymm
    · apply Submodule.span_le.mpr
      rintro _ ⟨c, rfl⟩
      cases c with
      | inl j => exact Submodule.subset_span (Set.mem_range_self j)
      | inr u =>
        have hz : augmentedDataVector A (fun _ => 0) (Sum.inr u) = 0 := by
          ext i; rfl
        rw [hz]
        exact Submodule.zero_mem _
    · apply Submodule.span_le.mpr
      rintro _ ⟨j, rfl⟩
      exact augmentedDataVector_mem_span A (fun _ => 0) (Sum.inl j)
  rw [heq]
  simpa using (finrank_range_le_card (R := ℝ) (fun j : Fin n => euclideanVec (fun i => A i j)))

/-- The chosen column-space basis has at most the ambient number of rows. -/
theorem lsColumnSpace_rank_le_rows {m n : ℕ} (A : Fin m → Fin n → ℝ) :
    Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) ≤ m := by
  simpa using (Submodule.finrank_le (augmentedDataSpan A (fun _ => 0)))

/-- A coarse but universal bound for both signed-Hadamard LS budgets at
failure probability1/2. The constant does not depend on the input data. -/
theorem hadamard_ls_budgets_le_source_scale {m n d : ℕ}
    (hm : 0 < m) (hd : 0 < d) (hdm : d ≤ m) (hdn : d ≤ n)
    {η : ℝ} (hη : 0 < η) (hηone : η ≤ 1) :
    let B := 4096 * (n : ℝ) * Real.log (2 * (m : ℝ)) / η
    let L := 2 * (d : ℝ) + 16 * Real.log (4 * (m : ℝ))
    10 * L * Real.log (8 * (d : ℝ)) ≤ B ∧ 32 * L / η ≤ B := by
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hdR : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have hdmR : (d : ℝ) ≤ (m : ℝ) := by exact_mod_cast hdm
  have hdnR : (d : ℝ) ≤ (n : ℝ) := by exact_mod_cast hdn
  have hmpos : (0 : ℝ) < (m : ℝ) := by positivity
  have hdpos : (0 : ℝ) < (d : ℝ) := by positivity
  have hlog2 : (1 / 2 : ℝ) ≤ Real.log 2 := by linarith [Real.log_two_gt_d9]
  have hlogm : 0 ≤ Real.log (m : ℝ) := Real.log_nonneg hmR
  have hlogd : 0 ≤ Real.log (d : ℝ) := Real.log_nonneg hdR
  have hlogdm : Real.log (d : ℝ) ≤ Real.log (m : ℝ) := Real.log_le_log hdpos hdmR
  have h2 : Real.log (2 * (m : ℝ)) = Real.log 2 + Real.log (m : ℝ) :=
    Real.log_mul (by norm_num) hmpos.ne'
  have h4 : Real.log (4 * (m : ℝ)) = 2 * Real.log 2 + Real.log (m : ℝ) := by
    rw [Real.log_mul (by norm_num) hmpos.ne']
    have : Real.log (4 : ℝ) = 2 * Real.log 2 := by
      rw [show (4 : ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]; ring
    rw [this]
  have h8 : Real.log (8 * (d : ℝ)) = 3 * Real.log 2 + Real.log (d : ℝ) := by
    rw [Real.log_mul (by norm_num) hdpos.ne']
    have : Real.log (8 : ℝ) = 3 * Real.log 2 := by
      rw [show (8 : ℝ) = 2 * (2 * 2) by norm_num,
        Real.log_mul (by norm_num) (by norm_num), Real.log_mul (by norm_num) (by norm_num)]; ring
    rw [this]
  have hl : (1 / 2 : ℝ) ≤ Real.log (2 * (m : ℝ)) := by linarith
  have h4le : Real.log (4 * (m : ℝ)) ≤ 2 * Real.log (2 * (m : ℝ)) := by linarith
  have h8le : Real.log (8 * (d : ℝ)) ≤ 3 * Real.log (2 * (m : ℝ)) := by linarith
  have h8coarse : Real.log (8 * (d : ℝ)) ≤ 8 * (d : ℝ) := by
    linarith [Real.log_le_sub_one_of_pos (show (0 : ℝ) < 8 * (d : ℝ) by positivity)]
  have h4nonneg : 0 ≤ Real.log (4 * (m : ℝ)) := by linarith
  have h8nonneg : 0 ≤ Real.log (8 * (d : ℝ)) := by linarith
  have hprod : Real.log (4 * (m : ℝ)) * Real.log (8 * (d : ℝ)) ≤
      16 * (d : ℝ) * Real.log (2 * (m : ℝ)) := by
    calc
      _ ≤ (2 * Real.log (2 * (m : ℝ))) * (8 * (d : ℝ)) :=
        mul_le_mul h4le h8coarse h8nonneg (by positivity)
      _ = _ := by ring
  have hdrlog : (d : ℝ) * Real.log (2 * (m : ℝ)) ≤
      (n : ℝ) * Real.log (2 * (m : ℝ)) := mul_le_mul_of_nonneg_right hdnR (by linarith)
  have hL : 2 * (d : ℝ) + 16 * Real.log (4 * (m : ℝ)) ≤
      36 * (d : ℝ) * Real.log (2 * (m : ℝ)) := by
    have := mul_le_mul_of_nonneg_right hdR (show 0 ≤ Real.log (2 * (m : ℝ)) by linarith)
    nlinarith
  have hemb : 10 * (2 * (d : ℝ) + 16 * Real.log (4 * (m : ℝ))) * Real.log (8 * (d : ℝ)) ≤
      2620 * (n : ℝ) * Real.log (2 * (m : ℝ)) := by
    have := mul_le_mul_of_nonneg_left h8le (show 0 ≤ (d : ℝ) by positivity)
    nlinarith
  dsimp
  constructor
  · apply (le_div_iff₀ hη).mpr
    have hnonneg : 0 ≤ 10 * (2 * (d : ℝ) + 16 * Real.log (4 * (m : ℝ))) * Real.log (8 * (d : ℝ)) := by positivity
    have := mul_le_mul_of_nonneg_left hηone hnonneg
    nlinarith
  · apply (div_le_div_iff_of_pos_right hη).mpr
    nlinarith

/-- A supplied relative leverage law has the same source scale with the
necessary reciprocal domination factor. -/
theorem dominated_leverage_ls_budgets_le_source_scale {m n d : ℕ}
    (hm : 0 < m) (hd : 0 < d) (hdm : d ≤ m) (hdn : d ≤ n)
    {η β : ℝ} (hη : 0 < η) (hηone : η ≤ 1) (hβ : 0 < β) :
    let B := 4096 * (n : ℝ) * Real.log (2 * (m : ℝ)) / (β * η)
    10 * ((d : ℝ) / β) * Real.log (4 * (d : ℝ)) ≤ B ∧
      16 * ((d : ℝ) / β) / η ≤ B := by
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hdR : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have hdmR : (d : ℝ) ≤ (m : ℝ) := by exact_mod_cast hdm
  have hdnR : (d : ℝ) ≤ (n : ℝ) := by exact_mod_cast hdn
  have hmpos : (0 : ℝ) < (m : ℝ) := by positivity
  have hdpos : (0 : ℝ) < (d : ℝ) := by positivity
  have hlog2 : (1 / 2 : ℝ) ≤ Real.log 2 := by linarith [Real.log_two_gt_d9]
  have hlogm := Real.log_nonneg hmR
  have hlogd := Real.log_nonneg hdR
  have hlogdm := Real.log_le_log hdpos hdmR
  have h2 : Real.log (2 * (m : ℝ)) = Real.log 2 + Real.log (m : ℝ) :=
    Real.log_mul (by norm_num) hmpos.ne'
  have h4 : Real.log (4 * (d : ℝ)) = 2 * Real.log 2 + Real.log (d : ℝ) := by
    rw [Real.log_mul (by norm_num) hdpos.ne']
    have : Real.log (4 : ℝ) = 2 * Real.log 2 := by
      rw [show (4 : ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]; ring
    rw [this]
  have hl : (1 / 2 : ℝ) ≤ Real.log (2 * (m : ℝ)) := by linarith
  have h4le : Real.log (4 * (d : ℝ)) ≤ 2 * Real.log (2 * (m : ℝ)) := by linarith
  have hdrlog : (d : ℝ) * Real.log (2 * (m : ℝ)) ≤
      (n : ℝ) * Real.log (2 * (m : ℝ)) := mul_le_mul_of_nonneg_right hdnR (by linarith)
  have hemb : 10 * (d : ℝ) * Real.log (4 * (d : ℝ)) ≤
      20 * (n : ℝ) * Real.log (2 * (m : ℝ)) := by
    have := mul_le_mul_of_nonneg_left h4le (show 0 ≤ (d : ℝ) by positivity)
    nlinarith
  have h4nonneg : 0 ≤ Real.log (4 * (d : ℝ)) := by linarith
  have hnonneg : 0 ≤ 10 * (d : ℝ) * Real.log (4 * (d : ℝ)) := by positivity
  have hmul := mul_le_mul_of_nonneg_left hηone hnonneg
  dsimp
  constructor
  · apply (le_div_iff₀ (mul_pos hβ hη)).mpr
    rw [show (10 * ((d : ℝ) / β) * Real.log (4 * (d : ℝ))) * (β * η) =
      10 * (d : ℝ) * Real.log (4 * (d : ℝ)) * η by field_simp]
    nlinarith
  · apply (le_div_iff₀ (mul_pos hβ hη)).mpr
    rw [show (16 * ((d : ℝ) / β) / η) * (β * η) = 16 * (d : ℝ) by field_simp]
    have := mul_le_mul_of_nonneg_left hl (show 0 ≤ (n : ℝ) by positivity)
    nlinarith

end NumStability
