import ComputationalMathematics.HDP.Tensor.SignedAnalyticFeature
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Series

/-!
# Scaled sine power series

The globally convergent coefficient sequence for `sin (c * x)` is packaged on
all natural degrees, with zero coefficients on the even degrees.  Its
absolute-coefficient series is the corresponding scaled hyperbolic sine.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Tensor

/-- The coefficient of degree `k` in the globally convergent power series for
`x ↦ sin (c * x)`. -/
def scaledSineCoefficient (c : ℝ) (k : ℕ) : ℝ :=
  if Even k then 0 else (-1 : ℝ) ^ (k / 2) * c ^ k / Nat.factorial k

theorem scaledSineCoefficient_even (c : ℝ) (m : ℕ) :
    scaledSineCoefficient c (2 * m) = 0 := by
  simp [scaledSineCoefficient]

theorem scaledSineCoefficient_odd (c : ℝ) (m : ℕ) :
    scaledSineCoefficient c (2 * m + 1) =
      (-1 : ℝ) ^ m * c ^ (2 * m + 1) / Nat.factorial (2 * m + 1) := by
  have hdiv : (2 * m + 1) / 2 = m := by omega
  simp [scaledSineCoefficient, hdiv]

theorem scaledSineCoefficient_hasSum (c x : ℝ) :
    HasSum (fun k : ℕ ↦ scaledSineCoefficient c k * x ^ k)
      (Real.sin (c * x)) := by
  have he : HasSum
      (fun m : ℕ ↦ scaledSineCoefficient c (2 * m) * x ^ (2 * m)) 0 := by
    simp [scaledSineCoefficient_even]
  have ho : HasSum
      (fun m : ℕ ↦ scaledSineCoefficient c (2 * m + 1) * x ^ (2 * m + 1))
      (Real.sin (c * x)) := by
    have hfun :
        (fun m : ℕ ↦ scaledSineCoefficient c (2 * m + 1) * x ^ (2 * m + 1)) =
          (fun m : ℕ ↦ (-1 : ℝ) ^ m * (c * x) ^ (2 * m + 1) /
            Nat.factorial (2 * m + 1)) := by
      funext m
      rw [scaledSineCoefficient_odd, mul_pow]
      ring
    rw [hfun]
    exact Real.hasSum_sin (c * x)
  simpa only [zero_add] using
    (HasSum.even_add_odd
      (f := fun k : ℕ ↦ scaledSineCoefficient c k * x ^ k) he ho)

/-- The scaled sine series converges to `sin (c * x)` at every real input. -/
theorem globallyConvergentPowerSeries_scaledSine (c : ℝ) :
    GloballyConvergentPowerSeries (fun x ↦ Real.sin (c * x))
      (scaledSineCoefficient c) := by
  intro x
  exact scaledSineCoefficient_hasSum c x

/-- Taking absolute values of the scaled sine coefficients replaces sine by
hyperbolic sine. -/
theorem scaledSineCoefficient_abs_hasSum (c x : ℝ) :
    HasSum (fun k : ℕ ↦ |scaledSineCoefficient c k| * x ^ k)
      (Real.sinh (|c| * x)) := by
  have he : HasSum
      (fun m : ℕ ↦ |scaledSineCoefficient c (2 * m)| * x ^ (2 * m)) 0 := by
    simp [scaledSineCoefficient_even]
  have ho : HasSum
      (fun m : ℕ ↦ |scaledSineCoefficient c (2 * m + 1)| * x ^ (2 * m + 1))
      (Real.sinh (|c| * x)) := by
    have hfun :
        (fun m : ℕ ↦ |scaledSineCoefficient c (2 * m + 1)| * x ^ (2 * m + 1)) =
          (fun m : ℕ ↦ (|c| * x) ^ (2 * m + 1) /
            Nat.factorial (2 * m + 1)) := by
      funext m
      rw [scaledSineCoefficient_odd, abs_div, abs_mul, abs_pow, abs_neg,
        abs_one, one_pow, one_mul, abs_pow]
      have hfac : |(Nat.factorial (2 * m + 1) : ℝ)| =
          (Nat.factorial (2 * m + 1) : ℝ) :=
        abs_of_nonneg (Nat.cast_nonneg _)
      rw [hfac, mul_pow]
      ring
    rw [hfun]
    exact Real.hasSum_sinh (|c| * x)
  simpa only [zero_add] using
    (HasSum.even_add_odd
      (f := fun k : ℕ ↦ |scaledSineCoefficient c k| * x ^ k) he ho)

/-- The Krivine scaling constant is normalized so that its absolute-coefficient
sine series has value one at one. -/
theorem sinh_log_one_add_sqrt_two :
    Real.sinh (Real.log (1 + Real.sqrt 2)) = 1 := by
  rw [Real.sinh_log (by positivity)]
  have hinv : (1 + Real.sqrt 2)⁻¹ = Real.sqrt 2 - 1 := by
    have h := congrArg Inv.inv Real.inv_sqrt_two_sub_one
    have hne : Real.sqrt 2 - 1 ≠ 0 :=
      ne_of_gt (sub_pos.mpr Real.one_lt_sqrt_two)
    simpa [hne, add_comm] using h.symm
  rw [hinv]
  ring

end NumStability.HDP.Tensor
