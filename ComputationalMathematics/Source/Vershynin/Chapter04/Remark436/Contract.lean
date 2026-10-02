import ComputationalMathematics.HDP.Coding.GilbertVarshamov
import ComputationalMathematics.HDP.Coding.PackingConverse
import ComputationalMathematics.HDP.Coding.Rate
import Mathlib.Analysis.Complex.ExponentialBounds

/-!
# Vershynin Chapter 4, Remark 4.3.6
-/

namespace NumStability.HDP.Contract

/-- Corrected finite form of Remark 4.3.6.  For a prescribed integral number
of message bits, Theorem 4.3.5's sufficient length condition rearranges to
`R ≤ 1 - f(2δ)`, not `R ≥ 1 - f(2δ)`.  The radius condition is the same
condition required by the corrected Theorem 4.3.5. -/
theorem hdp_04_remark_4_3_6
    (k n r : ℕ) (hk : 0 < k) (hn : 0 < n) (hr : 0 < r)
    (h2r : 2 * r ≤ n)
    (hRate : NumStability.HDP.Coding.codingRate k n ≤
      1 - NumStability.HDP.Coding.rateLoss
        (2 * NumStability.HDP.Coding.errorFraction r n)) :
    NumStability.HDP.Coding.codingRate k n = (k : ℝ) / (n : ℝ) ∧
    NumStability.HDP.Coding.errorFraction r n = (r : ℝ) / (n : ℝ) ∧
    Nonempty (NumStability.HDP.Coding.ErrorCorrectingCode k n r) := by
  have _ := hk
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hBoundary :=
    NumStability.HDP.Coding.lengthBoundary_div_eq_one_sub_rateLoss_two_errorFraction
      n r hn hr
  rw [← hBoundary] at hRate
  have hLength : (k : ℝ) + 2 * (r : ℝ) *
      Real.logb 2 (Real.exp 1 * (n : ℝ) / (2 * (r : ℝ))) ≤ (n : ℝ) := by
    unfold NumStability.HDP.Coding.codingRate at hRate
    have hmul := (div_le_div_iff_of_pos_right hnR).mp hRate
    linarith
  exact ⟨rfl, rfl,
    ⟨NumStability.HDP.Coding.errorCorrectingCodeOfLengthLogBound
      hr h2r hLength⟩⟩

/-- No binary code carrying a positive number of message bits in two bits can
correct one error: two encoded messages would have to be more than two bits
apart in a two-coordinate Hamming cube. -/
theorem hdp_04_no_positive_message_code_length_two_correcting_one_error
    (k : ℕ) (hk : 0 < k) :
    ¬ Nonempty (NumStability.HDP.Coding.ErrorCorrectingCode k 2 1) := by
  rintro ⟨C⟩
  let x : NumStability.HDP.Coding.BinaryWord k := fun _ ↦ 0
  let z : NumStability.HDP.Coding.BinaryWord k := fun _ ↦ 1
  have hxz : x ≠ z := by
    intro h
    have := congrFun h (⟨0, hk⟩ : Fin k)
    simp [x, z] at this
  have hfar := C.two_mul_lt_hammingDist_encode hxz
  have hdiam := hammingDist_le_card_fintype
    (x := C.encode x) (y := C.encode z)
  simp only [Fintype.card_fin] at hdiam
  omega

/-- The literal finite-rate existence claim printed in Remark 4.3.6 fails at
`n = 2`, `r = 1`: its displayed lower bound is negative, but no code with a
positive number of message bits can correct one error in two coordinates. -/
theorem hdp_04_remark_4_3_6_printed_statement_counterexample :
    (1 - NumStability.HDP.Coding.rateLoss
        (2 * NumStability.HDP.Coding.errorFraction 1 2) < 0) ∧
      ¬ ∃ k : ℕ, 0 < k ∧
        Nonempty (NumStability.HDP.Coding.ErrorCorrectingCode k 2 1) ∧
        1 - NumStability.HDP.Coding.rateLoss
            (2 * NumStability.HDP.Coding.errorFraction 1 2) ≤
          NumStability.HDP.Coding.codingRate k 2 := by
  constructor
  · unfold NumStability.HDP.Coding.rateLoss
      NumStability.HDP.Coding.errorFraction
    norm_num
    have he : Real.logb 2 (Real.exp 1) = 1 / Real.log 2 := by
      rw [Real.logb, Real.log_exp]
    have hlog : Real.log 2 < 1 := by
      have h := Real.strictMonoOn_log (by norm_num : (0 : ℝ) < 2)
        (Real.exp_pos 1) Real.exp_one_gt_two
      simpa using h
    have hlogPos : 0 < Real.log 2 := Real.log_pos (by norm_num)
    have hgt : (1 : ℝ) < Real.logb 2 (Real.exp 1) := by
      rw [he, one_div]
      exact (one_lt_inv₀ hlogPos).2 hlog
    have hrhs : (1 : ℝ) * Real.logb 2 (Real.exp 1 / 1) =
        Real.logb 2 (Real.exp 1) := by
      rw [one_mul, div_one]
    exact hgt.trans_eq hrhs.symm
  · rintro ⟨k, hk, hcode, _hrate⟩
    exact hdp_04_no_positive_message_code_length_two_correcting_one_error
      k hk hcode

end NumStability.HDP.Contract
