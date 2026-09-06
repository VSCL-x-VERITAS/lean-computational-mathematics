import Mathlib.Probability.ProbabilityMassFunction.Binomial
import Mathlib.Analysis.Asymptotics.AsymptoticEquivalent
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Tactic

/-!
# Central point mass of the fair binomial law

The exact finite-`n` identity underlying the central-binomial sharpness example
in Chapter 2.  Its Stirling asymptotic is developed separately.
-/

noncomputable section

open ENNReal NNReal
open Filter
open scoped Asymptotics

namespace NumStability.HDP.Scalar.IndependentSums.FairCoinCentralMass

/-- In `2n` fair trials, the probability of exactly `n` successes is
`2⁻²ⁿ * choose (2n) n`. -/
theorem fairBinomial_centralMass (n : ℕ) :
    PMF.binomial (1 / 2) (by norm_num) (2 * n)
        ⟨n, by omega⟩ =
      (2 : ℝ≥0∞)⁻¹ ^ (2 * n) * (Nat.choose (2 * n) n : ℝ≥0∞) := by
  rw [PMF.binomial_apply]
  norm_num [Fin.last, Fin.sub_def]
  have hsub : 2 * n - n = n := by omega
  rw [hsub, ← pow_add]
  congr 2 <;> omega

/-- The law of the standardized count in `2n` fair trials.  Since its mean is
`n` and its variance is `n / 2`, this is the even-index specialization of the
book's `Z_N`. -/
def standardizedFairBinomial (n : ℕ) : PMF ℝ :=
  (PMF.binomial (1 / 2) (by norm_num) (2 * n)).map
    (fun k : Fin (2 * n + 1) =>
      ((k : ℕ) : ℝ) - (n : ℝ) |> fun x =>
        x / Real.sqrt ((n : ℝ) / 2))

/-- At positive even indices, the standardized fair-binomial law assigns to
zero exactly the raw binomial law's central point mass. -/
theorem standardizedFairBinomial_zero (n : ℕ) (hn : 0 < n) :
    standardizedFairBinomial n 0 =
      PMF.binomial (1 / 2) (by norm_num) (2 * n) ⟨n, by omega⟩ := by
  rw [standardizedFairBinomial, PMF.map_apply, tsum_fintype]
  rw [Finset.sum_eq_single (⟨n, by omega⟩ : Fin (2 * n + 1))]
  · simp
  · intro b _hb hb
    have hbNat : (b : ℕ) ≠ n := by
      intro h
      apply hb
      exact Fin.ext h
    have hbReal : (((b : ℕ) : ℝ) - (n : ℝ)) ≠ 0 := by
      exact sub_ne_zero.mpr (by exact_mod_cast hbNat)
    have hsqrt : Real.sqrt ((n : ℝ) / 2) ≠ 0 := by
      have hnℝ : 0 < (n : ℝ) := by exact_mod_cast hn
      positivity
    have hvalue :
        (fun x : ℝ => x / Real.sqrt ((n : ℝ) / 2))
            (((b : ℕ) : ℝ) - (n : ℝ)) ≠ 0 := by
      exact div_ne_zero hbReal hsqrt
    rw [if_neg (Ne.symm hvalue)]
  · simp

/-- The real Stirling comparison term `sqrt(2πn) (n/e)^n`. -/
def stirlingTerm (n : ℕ) : ℝ :=
  Real.sqrt (2 * (n : ℝ) * Real.pi) * ((n : ℝ) / Real.exp 1) ^ n

/-- First asymptotic step for the central binomial coefficient: substituting
Stirling's formula into `(2n)!/(n!)²`.  A subsequent algebraic simplification
identifies the right side with `4ⁿ / sqrt(πn)`. -/
theorem centralBinom_isEquivalent_stirlingRatio :
    (fun n : ℕ => (Nat.choose (2 * n) n : ℝ)) ~[Filter.atTop]
      (fun n : ℕ => stirlingTerm (2 * n) / stirlingTerm n ^ 2) := by
  have hfactorial := Stirling.factorial_isEquivalent_stirling
  have hdouble : Filter.Tendsto (fun n : ℕ => 2 * n) Filter.atTop Filter.atTop :=
    tendsto_id.const_mul_atTop' (by norm_num : 0 < (2 : ℕ))
  have hnum :
      (fun n : ℕ => ((2 * n).factorial : ℝ)) ~[Filter.atTop]
        (fun n : ℕ => stirlingTerm (2 * n)) := by
    simpa [Function.comp_def, stirlingTerm] using hfactorial.comp_tendsto hdouble
  have hden :
      (fun n : ℕ => (n.factorial : ℝ) ^ 2) ~[Filter.atTop]
        (fun n : ℕ => stirlingTerm n ^ 2) := by
    simpa [stirlingTerm] using hfactorial.pow 2
  have hratio := hnum.div hden
  have hleft :
      (fun n : ℕ => ((2 * n).factorial : ℝ) / (n.factorial : ℝ) ^ 2) =ᶠ[Filter.atTop]
        (fun n : ℕ => (Nat.choose (2 * n) n : ℝ)) := by
    filter_upwards [] with n
    have hnfac : (n.factorial : ℝ) ≠ 0 := by positivity
    have hnat := Nat.choose_mul_factorial_mul_factorial (show n ≤ 2 * n by omega)
    have hsub : 2 * n - n = n := by omega
    rw [hsub] at hnat
    field_simp [hnfac]
    calc
      ((2 * n).factorial : ℝ) =
          (Nat.choose (2 * n) n : ℝ) * (n.factorial : ℝ) * (n.factorial : ℝ) := by
        exact_mod_cast hnat.symm
      _ = (n.factorial : ℝ) ^ 2 * (Nat.choose (2 * n) n : ℝ) := by ring
  exact hratio.congr_left hleft

/-- Algebraic simplification of the Stirling ratio at positive indices. -/
theorem stirlingRatio_eq_four_pow_div_sqrt (n : ℕ) (hn : 0 < n) :
    stirlingTerm (2 * n) / stirlingTerm n ^ 2 =
      (4 : ℝ) ^ n / Real.sqrt (Real.pi * (n : ℝ)) := by
  have hnℝ : 0 < (n : ℝ) := by exact_mod_cast hn
  have hsqrt_sq : Real.sqrt (Real.pi * (n : ℝ)) ^ 2 =
      Real.pi * (n : ℝ) := Real.sq_sqrt (by positivity)
  have hsqrt_ne : Real.sqrt (Real.pi * (n : ℝ)) ≠ 0 := by positivity
  have hbase_ne : (n : ℝ) / Real.exp 1 ≠ 0 := by positivity
  have hpow_ne : ((n : ℝ) / Real.exp 1) ^ (2 * n) ≠ 0 :=
    pow_ne_zero _ hbase_ne
  have hsqrt_num :
      Real.sqrt (2 * ((2 * n : ℕ) : ℝ) * Real.pi) =
        2 * Real.sqrt (Real.pi * (n : ℝ)) := by
    rw [show ((2 * n : ℕ) : ℝ) = 2 * (n : ℝ) by norm_num]
    rw [show 2 * (2 * (n : ℝ)) * Real.pi = 4 * (Real.pi * (n : ℝ)) by ring]
    rw [Real.sqrt_mul (by positivity : 0 ≤ (4 : ℝ))]
    norm_num
  have hsqrt_den :
      Real.sqrt (2 * (n : ℝ) * Real.pi) ^ 2 =
        2 * (n : ℝ) * Real.pi := Real.sq_sqrt (by positivity)
  have hpow :
      (((2 * n : ℕ) : ℝ) / Real.exp 1) ^ (2 * n) =
        (4 : ℝ) ^ n * ((n : ℝ) / Real.exp 1) ^ (2 * n) := by
    rw [show ((2 * n : ℕ) : ℝ) / Real.exp 1 =
      2 * ((n : ℝ) / Real.exp 1) by
        norm_num [Nat.cast_mul]
        ring]
    rw [mul_pow]
    have htwo : (2 : ℝ) ^ (2 * n) = 4 ^ n := by
      calc
        (2 : ℝ) ^ (2 * n) = ((2 : ℝ) ^ 2) ^ n := pow_mul _ _ _
        _ = 4 ^ n := by norm_num
    rw [htwo]
  rw [stirlingTerm, stirlingTerm, hsqrt_num, hpow, mul_pow, hsqrt_den]
  have hdenpow : (((n : ℝ) / Real.exp 1) ^ n) ^ 2 =
      ((n : ℝ) / Real.exp 1) ^ (2 * n) := by
    calc
      (((n : ℝ) / Real.exp 1) ^ n) ^ 2 =
          ((n : ℝ) / Real.exp 1) ^ (n * 2) := (pow_mul _ _ _).symm
      _ = ((n : ℝ) / Real.exp 1) ^ (2 * n) := by congr 1 <;> omega
  rw [hdenpow]
  field_simp [hpow_ne, hsqrt_ne]
  nlinarith [hsqrt_sq]

/-- The customary simplified Stirling equivalent for the central binomial
coefficient. -/
theorem centralBinom_isEquivalent_four_pow_div_sqrt :
    (fun n : ℕ => (Nat.choose (2 * n) n : ℝ)) ~[Filter.atTop]
      (fun n : ℕ => (4 : ℝ) ^ n / Real.sqrt (Real.pi * (n : ℝ))) := by
  refine centralBinom_isEquivalent_stirlingRatio.congr_right ?_
  filter_upwards [Filter.eventually_gt_atTop 0] with n hn
  exact stirlingRatio_eq_four_pow_div_sqrt n hn

/-- Multiplying the central-binomial equivalent by the fair-coin weight gives
the sharp central-mass equivalent, including its exact leading constant. -/
theorem fairCentralMassReal_isEquivalent_inv_sqrt_pi :
    (fun n : ℕ =>
        (2 : ℝ)⁻¹ ^ (2 * n) * (Nat.choose (2 * n) n : ℝ)) ~[Filter.atTop]
      (fun n : ℕ => 1 / Real.sqrt (Real.pi * (n : ℝ))) := by
  have hscale :
      (fun n : ℕ => (2 : ℝ)⁻¹ ^ (2 * n)) ~[Filter.atTop]
        (fun n : ℕ => (2 : ℝ)⁻¹ ^ (2 * n)) := Asymptotics.IsEquivalent.refl
  have hmul := hscale.mul centralBinom_isEquivalent_four_pow_div_sqrt
  refine hmul.congr_right ?_
  filter_upwards [] with n
  have htwo : (2 : ℝ) ^ (2 * n) = 4 ^ n := by
    calc
      (2 : ℝ) ^ (2 * n) = ((2 : ℝ) ^ 2) ^ n := pow_mul _ _ _
      _ = 4 ^ n := by norm_num
  have hcancel : (2 : ℝ)⁻¹ ^ (2 * n) * 4 ^ n = 1 := by
    rw [← htwo, ← mul_pow]
    norm_num
    exact one_pow _
  calc
    (2 : ℝ)⁻¹ ^ (2 * n) *
          ((4 : ℝ) ^ n / Real.sqrt (Real.pi * (n : ℝ))) =
        ((2 : ℝ)⁻¹ ^ (2 * n) * (4 : ℝ) ^ n) /
          Real.sqrt (Real.pi * (n : ℝ)) := by ring
    _ = 1 / Real.sqrt (Real.pi * (n : ℝ)) := by rw [hcancel]

/-- Replacing the exact leading constant by the book's constant-factor scale:
for `N = 2n`, the central mass is comparable to `1 / sqrt N`. -/
theorem fairCentralMassReal_isTheta_inv_sqrt_double :
    (fun n : ℕ =>
        (2 : ℝ)⁻¹ ^ (2 * n) * (Nat.choose (2 * n) n : ℝ)) =Θ[Filter.atTop]
      (fun n : ℕ => 1 / Real.sqrt (2 * (n : ℝ))) := by
  have hc : (Real.sqrt (Real.pi / 2))⁻¹ ≠ 0 := by positivity
  have heq :
      (fun n : ℕ => 1 / Real.sqrt (Real.pi * (n : ℝ))) =ᶠ[Filter.atTop]
        (fun n : ℕ =>
          (Real.sqrt (Real.pi / 2))⁻¹ *
            (1 / Real.sqrt (2 * (n : ℝ)))) := by
    filter_upwards [Filter.eventually_gt_atTop 0] with n hn
    have hnℝ : 0 < (n : ℝ) := by exact_mod_cast hn
    have hsqrt_double_ne : Real.sqrt (2 * (n : ℝ)) ≠ 0 := by positivity
    have hsqrt_const_ne : Real.sqrt (Real.pi / 2) ≠ 0 := by positivity
    have hsqrt :
        Real.sqrt (Real.pi * (n : ℝ)) =
          Real.sqrt (Real.pi / 2) * Real.sqrt (2 * (n : ℝ)) := by
      rw [← Real.sqrt_mul (by positivity : 0 ≤ Real.pi / 2)]
      congr 1
      ring
    rw [hsqrt]
    field_simp [hsqrt_double_ne, hsqrt_const_ne]
  have hpi :
      (fun n : ℕ => 1 / Real.sqrt (Real.pi * (n : ℝ))) =Θ[Filter.atTop]
        (fun n : ℕ => 1 / Real.sqrt (2 * (n : ℝ))) := by
    exact heq.isTheta.of_const_mul_right hc
  exact fairCentralMassReal_isEquivalent_inv_sqrt_pi.isTheta.trans hpi

end NumStability.HDP.Scalar.IndependentSums.FairCoinCentralMass
