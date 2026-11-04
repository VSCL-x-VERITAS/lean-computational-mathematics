import ComputationalMathematics.HDP.Vector.GaussianMixtureFixedConfidenceEventAssembly

/-!
# Fixed-confidence Gaussian tail arithmetic

This module provides an ordinary numerical bound for every positive ambient
dimension. It selects no source claim or clustering algorithm contract.
-/
noncomputable section

namespace NumStability.HDP.Vector.GaussianMixture

/-- The fixed Gaussian tail target covers the smallest positive dimension. -/
theorem three_exp_neg_nine_mul_dim_lt_one_percent (n : ℕ) (hn : 0 < n) :
    3 * Real.exp (-9 * (n : ℝ)) < (1 : ℝ) / 100 := by
  have hbig : (300 : ℝ) < Real.exp 9 := by
    calc
      (300 : ℝ) < ∑ i ∈ Finset.range 5, (9 : ℝ) ^ i / i.factorial := by
        norm_num [Finset.sum_range_succ]
      _ ≤ Real.exp 9 := Real.sum_le_exp_of_nonneg (by norm_num) 5
  have hpos : 0 < Real.exp (-9) := Real.exp_pos _
  have hmul : Real.exp (-9) * Real.exp 9 = 1 := by
    rw [← Real.exp_add]
    norm_num
    rfl
  have hbase : 3 * Real.exp (-9) < (1 : ℝ) / 100 := by
    have hdiff : 0 < (Real.exp 9 - 300) * Real.exp (-9) :=
      mul_pos (sub_pos.mpr hbig) hpos
    nlinarith
  have hnreal : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hmono : Real.exp (-9 * (n : ℝ)) ≤ Real.exp (-9) :=
    Real.exp_le_exp.mpr (by nlinarith)
  nlinarith


end NumStability.HDP.Vector.GaussianMixture
