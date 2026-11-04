import ComputationalMathematics.HDP.Vector.GaussianMixtureNumericalPartitionRecovery
import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
# Ordinary polynomial-budget conversions

These scalar lemmas absorb a fixed quadratic sample constant into a real power
for error fractions at most one half, and convert the corresponding logarithmic
signal threshold. They do not reproduce the 2018 source's distinct sample-size
condition, select an author convention, or assert source faithfulness.
-/
noncomputable section

namespace NumStability.HDP.Vector.GaussianMixture

/-- For error fractions at most one half, the shifted logarithm is controlled
by five times the unshifted inverse-error logarithm. -/
theorem log_sixteen_div_le_five_log_inv_of_le_half (ε : ℝ)
    (hε : 0 < ε) (hhalf : ε ≤ 1 / 2) :
    Real.log (16 / ε) ≤ 5 * Real.log (1 / ε) := by
  have htwo : (2 : ℝ) ≤ 1 / ε := (le_div_iff₀ hε).2 (by linarith)
  have hlog := Real.log_le_log (by norm_num : (0 : ℝ) < 2) htwo
  have hlog16 : Real.log (16 : ℝ) = 4 * Real.log 2 := by
    have h16 : (16 : ℝ) = (2 : ℝ) ^ 4 := by norm_num
    rw [h16, Real.log_pow]
    norm_num
  rw [Real.log_div (by norm_num : (16 : ℝ) ≠ 0) hε.ne', hlog16,
    Real.log_div one_ne_zero hε.ne', Real.log_one]
  rw [Real.log_div one_ne_zero hε.ne', Real.log_one] at hlog
  linarith

/-- A sufficiently large real exponent absorbs any fixed quadratic sample
constant uniformly over positive error fractions at most one half. -/
theorem quadratic_sample_budget_of_polynomial_sample_budget (K C ε m n : ℝ)
    (hε : 0 < ε) (hhalf : ε ≤ 1 / 2) (hn : 0 ≤ n)
    (hC : 2 + Real.log (max K 1) / Real.log 2 ≤ C)
    (hsample : ε ^ (-C) * n ≤ m) :
    K * n ≤ ε ^ 2 * m := by
  let B : ℝ := Real.log (max K 1) / Real.log 2
  have hlogtwo : 0 < Real.log (2 : ℝ) := Real.log_pos (by norm_num)
  have hB : 0 ≤ B := div_nonneg (Real.log_nonneg (le_max_right K 1)) hlogtwo.le
  have htwo : (2 : ℝ) ≤ 1 / ε := (le_div_iff₀ hε).2 (by linarith)
  have hlog := Real.log_le_log (by norm_num : (0 : ℝ) < 2) htwo
  have hcount : max K 1 ≤ (1 / ε) ^ B := by
    apply Real.le_rpow_of_log_le (div_pos zero_lt_one hε)
    calc
      Real.log (max K 1) = B * Real.log 2 := by
        dsimp [B]
        rw [div_mul_cancel₀ _ hlogtwo.ne']
      _ ≤ B * Real.log (1 / ε) := mul_le_mul_of_nonneg_left hlog hB
  have hidentity : ε ^ 2 * ε ^ (-(2 + B)) = (1 / ε) ^ B := by
    calc
      ε ^ 2 * ε ^ (-(2 + B)) = ε ^ ((2 : ℝ) + -(2 + B)) := by
        rw [Real.rpow_add hε, Real.rpow_two]
      _ = ε ^ (-B) := by congr 1; ring
      _ = (1 / ε) ^ B := by rw [Real.rpow_neg_eq_inv_rpow, one_div]
  have hpow : ε ^ (-(2 + B)) ≤ ε ^ (-C) :=
    Real.rpow_le_rpow_of_exponent_ge hε (by linarith) (neg_le_neg hC)
  have hconstant : K ≤ ε ^ 2 * ε ^ (-C) := by
    calc
      K ≤ max K 1 := le_max_left K 1
      _ ≤ (1 / ε) ^ B := hcount
      _ = ε ^ 2 * ε ^ (-(2 + B)) := hidentity.symm
      _ ≤ ε ^ 2 * ε ^ (-C) := mul_le_mul_of_nonneg_left hpow (sq_nonneg ε)
  calc
    K * n ≤ (ε ^ 2 * ε ^ (-C)) * n := mul_le_mul_of_nonneg_right hconstant hn
    _ = ε ^ 2 * (ε ^ (-C) * n) := by ring
    _ ≤ ε ^ 2 * m := mul_le_mul_of_nonneg_left hsample (sq_nonneg ε)

/-- A coefficient at least twenty in the unshifted square-root logarithmic
signal condition implies the explicit numerical signal budget. -/
theorem log_signal_budget_of_polynomial_signal_budget (C ε r : ℝ)
    (hε : 0 < ε) (hhalf : ε ≤ 1 / 2) (hr : 0 ≤ r) (hC : 20 ≤ C)
    (hsignal : C * Real.sqrt (Real.log (1 / ε)) ≤ r) :
    64 * Real.log (16 / ε) ≤ r ^ 2 := by
  have htwo : (2 : ℝ) ≤ 1 / ε := (le_div_iff₀ hε).2 (by linarith)
  have hlog : 0 ≤ Real.log (1 / ε) := Real.log_nonneg (by linarith)
  have hsmall : 20 * Real.sqrt (Real.log (1 / ε)) ≤ r :=
    (mul_le_mul_of_nonneg_right hC (Real.sqrt_nonneg _)).trans hsignal
  have hsquare := (sq_le_sq₀ (by positivity : 0 ≤ 20 * Real.sqrt (Real.log (1 / ε))) hr).2 hsmall
  have hsqrt := Real.sq_sqrt hlog
  have hshift := log_sixteen_div_le_five_log_inv_of_le_half ε hε hhalf
  nlinarith

end NumStability.HDP.Vector.GaussianMixture
