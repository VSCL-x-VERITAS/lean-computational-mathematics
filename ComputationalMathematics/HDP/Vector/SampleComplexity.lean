import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
# Arithmetic form of covariance-estimation sample complexity
-/

noncomputable section

namespace NumStability.HDP.Vector.Covariance

/-- An error bound proportional to `a(√(n/m) + n/m)` is at most `ε` once
the aspect ratio is at most `(ε/(2a))²`. -/
theorem relativeError_le_of_aspectRatio_le
    {n m ε a error sigmaNorm : ℝ}
    (hn : 0 ≤ n) (hm : 0 < m) (hε0 : 0 < ε) (hε1 : ε < 1)
    (ha : 1 ≤ a) (hsigma : 0 ≤ sigmaNorm)
    (hbound : error ≤ a * (Real.sqrt (n / m) + n / m) * sigmaNorm)
    (hsize : n / m ≤ (ε / (2 * a)) ^ 2) :
    error ≤ ε * sigmaNorm := by
  have ha0 : 0 < a := lt_of_lt_of_le (by norm_num) ha
  have hden : 0 < 2 * a := mul_pos (by norm_num) ha0
  have hr0 : 0 ≤ ε / (2 * a) := div_nonneg hε0.le hden.le
  have hr1 : ε / (2 * a) ≤ 1 := by
    apply (div_le_one hden).2
    nlinarith
  have hq0 : 0 ≤ n / m := div_nonneg hn hm.le
  have hsqrt : Real.sqrt (n / m) ≤ ε / (2 * a) :=
    (Real.sqrt_le_iff).2 ⟨hr0, hsize⟩
  have hrsq : (ε / (2 * a)) ^ 2 ≤ ε / (2 * a) := by
    nlinarith [mul_nonneg hr0 (sub_nonneg.mpr hr1)]
  have hq : n / m ≤ ε / (2 * a) := hsize.trans hrsq
  have hfactor : a * (Real.sqrt (n / m) + n / m) ≤ ε := by
    calc
      a * (Real.sqrt (n / m) + n / m) ≤
          a * (ε / (2 * a) + ε / (2 * a)) := by gcongr
      _ = ε := by field_simp; ring
  exact hbound.trans (mul_le_mul_of_nonneg_right hfactor hsigma)

/-- Choose an integer sample count on the `ε⁻² n` scale.  The comparison
constant is explicit in `a`; in covariance estimation, `a = C K²`. -/
theorem exists_nat_sample_size_of_aspectRatio
    {n ε a : ℝ} (hn : 1 ≤ n) (hε0 : 0 < ε) (hε1 : ε < 1)
    (ha : 1 ≤ a) :
    ∃ m : ℕ, 0 < m ∧
      ((2 * a / ε) ^ 2 * n) ≤ (m : ℝ) ∧
      (m : ℝ) ≤ 2 * ((2 * a / ε) ^ 2 * n) ∧
      n / (m : ℝ) ≤ (ε / (2 * a)) ^ 2 := by
  let t : ℝ := (2 * a / ε) ^ 2 * n
  have ha0 : 0 < a := lt_of_lt_of_le (by norm_num) ha
  have hden : 0 < 2 * a := mul_pos (by norm_num) ha0
  have hb1 : 1 ≤ 2 * a / ε := by
    apply (le_div_iff₀ hε0).2
    nlinarith
  have ht1 : 1 ≤ t := by
    have hb2 : 1 ≤ (2 * a / ε) ^ 2 := by nlinarith [sq_nonneg (2 * a / ε - 1)]
    calc
      (1 : ℝ) = 1 * 1 := by ring
      _ ≤ (2 * a / ε) ^ 2 * n :=
        mul_le_mul hb2 hn (by norm_num) (by nlinarith)
  have ht0 : 0 ≤ t := le_trans (by norm_num) ht1
  have hmpos : 0 < ⌈t⌉₊ :=
    (Nat.one_le_ceil_iff).2 (lt_of_lt_of_le (by norm_num) ht1)
  refine ⟨⌈t⌉₊, ?_, ?_, ?_, ?_⟩
  · exact hmpos
  · exact Nat.le_ceil t
  · have hceil : (⌈t⌉₊ : ℝ) < t + 1 := Nat.ceil_lt_add_one ht0
    have h2t : t + 1 ≤ 2 * t := by linarith
    exact hceil.le.trans (by simpa [t] using h2t)
  · have hmreal : 0 < (⌈t⌉₊ : ℝ) := by exact_mod_cast hmpos
    have hq0 : 0 ≤ (ε / (2 * a)) ^ 2 := sq_nonneg _
    have hcancel : t * (ε / (2 * a)) ^ 2 = n := by
      dsimp [t]
      field_simp [ne_of_gt hε0, ne_of_gt hden]
    apply (div_le_iff₀ hmreal).2
    calc
      n = t * (ε / (2 * a)) ^ 2 := hcancel.symm
      _ ≤ (⌈t⌉₊ : ℝ) * (ε / (2 * a)) ^ 2 :=
        mul_le_mul_of_nonneg_right (Nat.le_ceil t) hq0
      _ = (ε / (2 * a)) ^ 2 * (⌈t⌉₊ : ℝ) := by ring

end NumStability.HDP.Vector.Covariance
