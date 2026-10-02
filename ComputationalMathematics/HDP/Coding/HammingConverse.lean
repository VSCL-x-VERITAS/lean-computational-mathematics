import ComputationalMathematics.HDP.Coding.HammingBalls
import ComputationalMathematics.HDP.Coding.PackingConverse
import ComputationalMathematics.HDP.Coding.Rate
import Mathlib.Data.Nat.Choose.Bounds
import Mathlib.Data.Nat.Factorial.BigOperators

/-!
# The Hamming converse bound

This file supplies the lower binomial estimate needed for the sphere-packing
converse and applies the disjoint-ball count to an error-correcting code.
-/

open Function Set

namespace NumStability.HDP.Coding

/-- The elementary lower estimate on a binomial coefficient used in the
Hamming bound. -/
theorem pow_div_pow_le_choose {n r : ℕ} (hr : 0 < r) (hrn : r ≤ n) :
    ((n : ℝ) / (r : ℝ)) ^ r ≤ (n.choose r : ℝ) := by
  have hrR : (0 : ℝ) < r := by exact_mod_cast hr
  have hfactor : ∀ i ∈ Finset.range r,
      (n : ℝ) / (r : ℝ) * (r - i : ℕ) ≤ (n - i : ℕ) := by
    intro i hi
    have hir : i ≤ r := (Finset.mem_range.mp hi).le
    have hin : i ≤ n := hir.trans hrn
    rw [Nat.cast_sub hir, Nat.cast_sub hin]
    rw [div_mul_eq_mul_div, div_le_iff₀ hrR]
    push_cast
    nlinarith [show (i : ℝ) ≥ 0 by positivity,
      show (r : ℝ) ≤ n by exact_mod_cast hrn]
  have hprod :
      ∏ i ∈ Finset.range r,
          ((n : ℝ) / (r : ℝ) * ((r - i : ℕ) : ℝ)) ≤
        ∏ i ∈ Finset.range r, ((n - i : ℕ) : ℝ) := by
    exact Finset.prod_le_prod
      (fun i hi ↦ mul_nonneg (by positivity) (by positivity)) hfactor
  have hleft :
      ∏ i ∈ Finset.range r,
          ((n : ℝ) / (r : ℝ) * ((r - i : ℕ) : ℝ)) =
        ((n : ℝ) / (r : ℝ)) ^ r * (Nat.factorial r : ℝ) := by
    rw [Finset.prod_mul_distrib]
    simp only [Finset.prod_const, Finset.card_range]
    rw [show (∏ i ∈ Finset.range r, ((r - i : ℕ) : ℝ)) =
        (Nat.factorial r : ℝ) by
      norm_cast
      rw [← Nat.descFactorial_eq_prod_range]
      simpa using Nat.descFactorial_eq_factorial_mul_choose r r]
  have hright :
      ∏ i ∈ Finset.range r, ((n - i : ℕ) : ℝ) =
        (Nat.factorial r : ℝ) * (n.choose r : ℝ) := by
    norm_cast
    rw [← Nat.descFactorial_eq_prod_range]
    exact Nat.descFactorial_eq_factorial_mul_choose n r
  rw [hleft, hright] at hprod
  have hfac : (0 : ℝ) < Nat.factorial r := by positivity
  nlinarith

/-- The image codebook has exactly `2^k` words. -/
theorem ErrorCorrectingCode.ncard_codebook {k n r : ℕ}
    (C : ErrorCorrectingCode k n r) :
    Set.ncard (Set.range C.encode) = 2 ^ k := by
  rw [Set.ncard_range_of_injective C.encode_injective]
  simp [BinaryWord]

/-- Exact sphere-packing count for an `r`-error-correcting binary code. -/
theorem ErrorCorrectingCode.pow_two_mul_hammingBallVolume_le
    {k n r : ℕ} (C : ErrorCorrectingCode k n r) :
    2 ^ k * hammingBallVolume n r ≤ 2 ^ n := by
  let P : Set (BinaryWord n) := Set.range C.encode
  have hPfin : P.Finite := Set.finite_range C.encode
  have hsep : ∀ x ∈ P, ∀ z ∈ P, x ≠ z →
      2 * r < hammingDist x z := by
    rintro _ ⟨a, rfl⟩ _ ⟨b, rfl⟩ hab
    apply C.two_mul_lt_hammingDist_encode
    intro h
    subst b
    exact hab rfl
  have hbound := card_mul_hammingBallVolume_half_le_of_separated P hPfin hsep
  have hhalf : 2 * r / 2 = r := by omega
  rw [hhalf] at hbound
  simpa [P, C.ncard_codebook] using hbound

/-- Real-valued sphere-packing inequality after inserting the elementary
lower estimate on the Hamming-ball volume. -/
theorem ErrorCorrectingCode.pow_two_mul_pow_div_le
    {k n r : ℕ} (C : ErrorCorrectingCode k n r)
    (hr : 0 < r) (hrn : r ≤ n) :
    (2 : ℝ) ^ k * ((n : ℝ) / (r : ℝ)) ^ r ≤ (2 : ℝ) ^ n := by
  have hchoose : ((n : ℝ) / (r : ℝ)) ^ r ≤ (n.choose r : ℝ) :=
    pow_div_pow_le_choose hr hrn
  have hchoose_ball : n.choose r ≤ hammingBallVolume n r := by
    unfold hammingBallVolume
    exact Finset.single_le_sum (fun _ _ ↦ Nat.zero_le _) (by simp)
  have hcount := C.pow_two_mul_hammingBallVolume_le
  exact calc
    (2 : ℝ) ^ k * ((n : ℝ) / (r : ℝ)) ^ r ≤
        (2 : ℝ) ^ k * (n.choose r : ℝ) := by gcongr
    _ ≤ (2 : ℝ) ^ k * (hammingBallVolume n r : ℝ) := by
      gcongr
    _ ≤ (2 : ℝ) ^ n := by exact_mod_cast hcount

/-- Logarithmic form of the Hamming converse. -/
theorem ErrorCorrectingCode.messageBits_add_errorTerm_le
    {k n r : ℕ} (C : ErrorCorrectingCode k n r)
    (hr : 0 < r) (hrn : r ≤ n) :
    (k : ℝ) + (r : ℝ) * Real.logb 2 ((n : ℝ) / (r : ℝ)) ≤ (n : ℝ) := by
  have hn : 0 < n := hr.trans_le hrn
  have hraw := C.pow_two_mul_pow_div_le hr hrn
  have hlog := Real.logb_le_logb_of_le (b := (2 : ℝ)) (by norm_num)
    (by positivity : 0 < (2 : ℝ) ^ k * ((n : ℝ) / (r : ℝ)) ^ r) hraw
  rw [Real.logb_mul (by positivity) (by positivity), Real.logb_pow,
    Real.logb_pow] at hlog
  norm_num at hlog
  convert hlog using 1 <;> norm_num [Real.logb_pow]

/-- Rate form of the Hamming converse: every binary code correcting an
`r/n` fraction of errors loses at least
`(r/n) log₂(1/(r/n))` in rate. -/
theorem ErrorCorrectingCode.codingRate_le_one_sub_errorFraction_mul_logb
    {k n r : ℕ} (C : ErrorCorrectingCode k n r)
    (hr : 0 < r) (hrn : r ≤ n) :
    codingRate k n ≤
      1 - errorFraction r n * Real.logb 2 (1 / errorFraction r n) := by
  have hn : 0 < n := hr.trans_le hrn
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hrR : (0 : ℝ) < r := by exact_mod_cast hr
  have hlog := C.messageBits_add_errorTerm_le hr hrn
  have harg : (1 : ℝ) / errorFraction r n = (n : ℝ) / (r : ℝ) := by
    unfold errorFraction
    field_simp
  rw [harg]
  unfold codingRate errorFraction
  apply (div_le_iff₀ hnR).2
  field_simp
  nlinarith

end NumStability.HDP.Coding
