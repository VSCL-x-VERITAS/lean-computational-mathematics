import ComputationalMathematics.HDP.Coding.HammingBalls
import Mathlib.Analysis.SpecialFunctions.Exp

/-!
# An exponential upper bound for binary Hamming-ball volume

This is the elementary binomial estimate used in the Gilbert--Varshamov
argument.  It is kept separate from the exact finite-cardinality development
in `HammingBalls`.
-/

noncomputable section

namespace NumStability.HDP.Coding

/-- For `1 ≤ m ≤ n`, the radius-`m` binary Hamming ball has volume at
most `(e n / m)^m`. -/
theorem hammingBallVolume_cast_le_exp_mul_div_pow
    {n m : ℕ} (hm : 0 < m) (hmn : m ≤ n) :
    (hammingBallVolume n m : ℝ) ≤
      (Real.exp 1 * (n : ℝ) / (m : ℝ)) ^ m := by
  let x : ℝ := (m : ℝ) / (n : ℝ)
  have hn : 0 < n := lt_of_lt_of_le hm hmn
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hmR : (0 : ℝ) < m := by exact_mod_cast hm
  have hx0 : 0 ≤ x := div_nonneg hmR.le hnR.le
  have hx1 : x ≤ 1 := (div_le_one hnR).2 (by exact_mod_cast hmn)
  have hweighted :
      x ^ m * (hammingBallVolume n m : ℝ) ≤ (1 + x) ^ n := by
    rw [hammingBallVolume, Nat.cast_sum]
    rw [Finset.mul_sum]
    calc
      ∑ j ∈ Finset.range (m + 1), x ^ m * (n.choose j : ℝ) ≤
          ∑ j ∈ Finset.range (m + 1),
            (n.choose j : ℝ) * x ^ j := by
        apply Finset.sum_le_sum
        intro j hj
        have hjm : j ≤ m := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
        have hpow : x ^ m ≤ x ^ j :=
          pow_le_pow_of_le_one hx0 hx1 hjm
        nlinarith [show (0 : ℝ) ≤ n.choose j by positivity]
      _ ≤ ∑ j ∈ Finset.range (n + 1),
            (n.choose j : ℝ) * x ^ j := by
        apply Finset.sum_le_sum_of_subset_of_nonneg
        · intro j hj
          simp only [Finset.mem_range] at hj ⊢
          omega
        · intro j _hj _hnot
          positivity
      _ = (1 + x) ^ n := by
        rw [show (1 + x) = (x + 1) by ring, add_pow]
        simp [mul_comm]
  have hexp : (1 + x) ^ n ≤ Real.exp (m : ℝ) := by
    calc
      (1 + x) ^ n ≤ (Real.exp x) ^ n := by
        gcongr
        simpa [add_comm] using Real.add_one_le_exp x
      _ = Real.exp (m : ℝ) := by
        rw [← Real.exp_nat_mul]
        congr 1
        dsimp [x]
        field_simp
  have hxpos : 0 < x := div_pos hmR hnR
  have hdivide : (hammingBallVolume n m : ℝ) ≤
      Real.exp (m : ℝ) / x ^ m := by
    apply (le_div_iff₀' (pow_pos hxpos m)).2
    exact hweighted.trans hexp
  calc
    (hammingBallVolume n m : ℝ) ≤
        Real.exp (m : ℝ) / x ^ m := hdivide
    _ = (Real.exp 1 * (n : ℝ) / (m : ℝ)) ^ m := by
      rw [show Real.exp (m : ℝ) = (Real.exp 1) ^ m by
        rw [← Real.exp_nat_mul]
        congr 1
        norm_num]
      have hbase : Real.exp 1 * (n : ℝ) / (m : ℝ) =
          Real.exp 1 / x := by
        dsimp [x]
        field_simp [ne_of_gt hmR, ne_of_gt hnR]
      rw [hbase]
      exact (div_pow (Real.exp 1) x m).symm

end NumStability.HDP.Coding
