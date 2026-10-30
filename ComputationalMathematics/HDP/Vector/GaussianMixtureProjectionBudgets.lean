import ComputationalMathematics.HDP.Vector.GaussianMixtureProjectionPartitionRecovery

/-! Ordinary explicit numerical budgets; no source convention is selected. -/
noncomputable section

namespace NumStability.HDP.Vector.GaussianMixture

/-- A quadratic sample budget controls the covariance square-root parameter. -/
theorem covariance_delta_le_of_squared_sample_budget
    {m n : ℕ} (hm : 0 < m) (C ε : ℝ) (hC : 0 ≤ C) (hε : 0 < ε)
    (hsample : (4096 * C) ^ 2 * (n : ℝ) ≤ ε ^ 2 * (m : ℝ)) :
    C * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
      Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ)) ≤ ε / 2048 := by
  have hmR : 0 < (m : ℝ) := by exact_mod_cast hm
  have hmroot : 0 < Real.sqrt (m : ℝ) := Real.sqrt_pos.mpr hmR
  have hleft : (4096 * C * Real.sqrt (n : ℝ)) ^ 2 =
      (4096 * C) ^ 2 * (n : ℝ) := by rw [mul_pow, Real.sq_sqrt (Nat.cast_nonneg n)]
  have hright : (ε * Real.sqrt (m : ℝ)) ^ 2 = ε ^ 2 * (m : ℝ) := by
    rw [mul_pow, Real.sq_sqrt hmR.le]
  have hrootSq : (4096 * C * Real.sqrt (n : ℝ)) ^ 2 ≤
      (ε * Real.sqrt (m : ℝ)) ^ 2 := by rw [hleft, hright]; exact hsample
  have hroot : 4096 * C * Real.sqrt (n : ℝ) ≤ ε * Real.sqrt (m : ℝ) :=
    (sq_le_sq₀ (by positivity) (by positivity)).mp hrootSq
  calc
    _ = (2 * C * Real.sqrt (n : ℝ)) / Real.sqrt (m : ℝ) := by
      rw [Real.sqrt_div (Nat.cast_nonneg n)]; ring
    _ ≤ ε / 2048 := (div_le_iff₀ hmroot).mpr (by nlinarith [hroot])

/-- A small covariance parameter gives both the projection budget and amplitude positivity. -/
theorem projection_budget_and_small_error_of_delta_le
    (r ε δ : ℝ) (hr : 1 ≤ r) (hε : 0 < ε) (hεone : ε ≤ 1)
    (hδ : 0 ≤ δ) (hδsmall : δ ≤ ε / 2048) :
    let q := (2 * (r + 1)) ^ 2 * max δ (δ ^ 2)
    q ≤ ε * r ^ 2 / 128 ∧
      4 * q * (1 + r ^ 2 + q) ≤ ε / 2 * (r ^ 2 / 2) ^ 2 ∧ q < r ^ 2 := by
  dsimp only
  let q := (2 * (r + 1)) ^ 2 * max δ (δ ^ 2)
  have hr0 : 0 ≤ r := by linarith
  have hr2 : 1 ≤ r ^ 2 := by nlinarith
  have hδone : δ ≤ 1 := by linarith
  have hδsq : δ ^ 2 ≤ δ := by nlinarith
  have hL : (2 * (r + 1)) ^ 2 ≤ 16 * r ^ 2 := by
    nlinarith [mul_nonneg hr0 (show 0 ≤ r - 1 by linarith)]
  have hq : q ≤ ε * r ^ 2 / 128 := by
    calc
      q = (2 * (r + 1)) ^ 2 * δ := by dsimp only [q]; rw [max_eq_left hδsq]
      _ ≤ (16 * r ^ 2) * (ε / 2048) := mul_le_mul hL hδsmall hδ (by positivity)
      _ = _ := by ring
  have hq0 : 0 ≤ q := by dsimp [q]; positivity
  have hqone : q ≤ r ^ 2 / 128 := by
    nlinarith [mul_nonneg (show 0 ≤ 1 - ε by linarith) (sq_nonneg r)]
  have hqsmall : q < r ^ 2 := by nlinarith
  have hcoefficient : 1 + r ^ 2 + q ≤ 3 * r ^ 2 := by nlinarith
  have hcoefficient0 : 0 ≤ 1 + r ^ 2 + q := by positivity
  refine ⟨hq, ?_, hqsmall⟩
  calc
    _ ≤ (4 * (ε * r ^ 2 / 128)) * (3 * r ^ 2) :=
      mul_le_mul (mul_le_mul_of_nonneg_left hq (by norm_num))
        hcoefficient hcoefficient0 (by positivity)
    _ ≤ _ := by nlinarith [mul_nonneg hε.le (sq_nonneg (r ^ 2))]

/-- An explicit logarithmic signal threshold bounds the ideal-margin error rate. -/
theorem ideal_margin_rate_le_quarter_of_log_signal_budget
    (r ε : ℝ) (hε : 0 < ε) (hsignal : 64 * Real.log (16 / ε) ≤ r ^ 2) :
    4 * Real.exp (-(r ^ 2) / 64) ≤ ε / 4 := by
  have hexp : Real.exp (-(r ^ 2) / 64) ≤ ε / 16 := by
    calc
      _ ≤ Real.exp (-Real.log (16 / ε)) := Real.exp_le_exp.mpr (by nlinarith)
      _ = ε / 16 := by
        rw [Real.exp_neg, Real.exp_log (div_pos (by norm_num) hε)]
        simp only [inv_div]
  nlinarith

/-- A quadratic sample bound makes the ideal-count exponential no larger than exp(-n). -/
theorem ideal_count_exp_tail_le_of_squared_sample_budget
    {m n : ℕ} (ε p : ℝ) (hε : 0 < ε) (hp : p ≤ ε / 4)
    (hsample : 8 * (n : ℝ) ≤ ε ^ 2 * (m : ℝ)) :
    Real.exp (-2 * (m : ℝ) * (ε / 2 - p) ^ 2) ≤ Real.exp (-(n : ℝ)) := by
  have hdiff : ε / 4 ≤ ε / 2 - p := by linarith
  have hsq : (ε / 4) ^ 2 ≤ (ε / 2 - p) ^ 2 :=
    (sq_le_sq₀ (by positivity) (by linarith)).mpr hdiff
  have hmul := mul_le_mul_of_nonneg_left hsq (Nat.cast_nonneg m)
  apply Real.exp_le_exp.mpr
  nlinarith

end NumStability.HDP.Vector.GaussianMixture
