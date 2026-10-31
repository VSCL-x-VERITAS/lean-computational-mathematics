import ComputationalMathematics.HDP.Coding.GilbertVarshamov
import ComputationalMathematics.HDP.Coding.PackingConverse
import Mathlib.Analysis.Complex.ExponentialBounds

/-!
# Vershynin Chapter 4, Theorem 4.3.5

The printed statement omits the radius condition `2r ≤ n` used explicitly by
its proof when Exercise 4.2.16 is applied with `m = 2r`.  This file gives the
corrected theorem and a compiled counterexample to the literal statement.
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Theorem 4.3.5 with the proof-required applicability condition `2r ≤ n`
made explicit. -/
theorem hdp_04_theorem_4_3_5_corrected
    {k n r : ℕ} (hk : 0 < k) (hn : 0 < n) (hr : 0 < r)
    (h2r : 2 * r ≤ n)
    (hlen : (k : ℝ) + 2 * (r : ℝ) *
        Real.logb 2 (Real.exp 1 * (n : ℝ) / (2 * (r : ℝ))) ≤ (n : ℝ)) :
    Nonempty (NumStability.HDP.Coding.ErrorCorrectingCode k n r) := by
  have _ := hk
  have _ := hn
  exact ⟨NumStability.HDP.Coding.errorCorrectingCodeOfLengthLogBound hr h2r hlen⟩

/-- The literal printed hypotheses hold for `k=n=1, r=10`, because the
logarithmic term is negative. -/
theorem hdp_04_theorem_4_3_5_printed_hypotheses_hold_at_1_1_10 :
    (0 : ℕ) < 1 ∧ (0 : ℕ) < 1 ∧ (0 : ℕ) < 10 ∧
      ((1 : ℝ) + 2 * (10 : ℝ) *
        Real.logb 2 (Real.exp 1 * (1 : ℝ) / (2 * (10 : ℝ))) ≤ (1 : ℝ)) := by
  have hargpos : 0 < Real.exp 1 * (1 : ℝ) / (2 * (10 : ℝ)) := by positivity
  have harglt : Real.exp 1 * (1 : ℝ) / (2 * (10 : ℝ)) < 1 := by
    nlinarith [Real.exp_one_lt_three]
  have hlog : Real.logb 2
      (Real.exp 1 * (1 : ℝ) / (2 * (10 : ℝ))) < 0 :=
    Real.logb_neg (by norm_num) hargpos harglt
  norm_num at hlog ⊢
  linarith

/-- No one-bit code can correct ten errors: two distinct messages would need
codewords farther than twenty bits apart in a one-coordinate Hamming cube. -/
theorem hdp_04_no_error_correcting_code_1_1_10 :
    ¬ Nonempty (NumStability.HDP.Coding.ErrorCorrectingCode 1 1 10) := by
  rintro ⟨C⟩
  let x : NumStability.HDP.Coding.BinaryWord 1 := fun _ ↦ 0
  let z : NumStability.HDP.Coding.BinaryWord 1 := fun _ ↦ 1
  have hxz : x ≠ z := by
    intro h
    have := congrFun h (0 : Fin 1)
    simp [x, z] at this
  have hfar := C.two_mul_lt_hammingDist_encode hxz
  have hdiam := hammingDist_le_card_fintype
    (x := C.encode x) (y := C.encode z)
  simp only [Fintype.card_fin] at hdiam
  omega

/-- Consequently, the literal printed statement of Theorem 4.3.5 is false
without an additional radius restriction. -/
theorem hdp_04_theorem_4_3_5_printed_statement_counterexample :
    ((0 : ℕ) < 1 ∧ (0 : ℕ) < 1 ∧ (0 : ℕ) < 10 ∧
      ((1 : ℝ) + 2 * (10 : ℝ) *
        Real.logb 2 (Real.exp 1 * (1 : ℝ) / (2 * (10 : ℝ))) ≤ (1 : ℝ))) ∧
      ¬ Nonempty (NumStability.HDP.Coding.ErrorCorrectingCode 1 1 10) :=
  ⟨hdp_04_theorem_4_3_5_printed_hypotheses_hold_at_1_1_10,
    hdp_04_no_error_correcting_code_1_1_10⟩

end NumStability.HDP.Contract
