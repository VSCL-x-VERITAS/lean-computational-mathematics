import ComputationalMathematics.HDP.Tensor.SinePowerSeries
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.SpecialFunctions.Log.Deriv

/-!
# Krivine sine-kernel features

The signed analytic feature construction is specialized to the normalized sine
series used in Vershynin's Lemma 3.7.7.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Tensor

/-- The scale `log (1 + sqrt 2)` whose hyperbolic sine is one. -/
def krivineScale : ℝ := Real.log (1 + Real.sqrt 2)

/-- Vershynin's constant `2 / π * log (1 + sqrt 2)`. -/
def krivineBeta : ℝ := 2 / Real.pi * krivineScale

theorem krivineScale_pos : 0 < krivineScale := by
  rw [krivineScale]
  exact Real.log_pos (by
    nlinarith [Real.sqrt_pos.2 (show (0 : ℝ) < 2 by norm_num)])

theorem krivineScale_lt_pi_div_two : krivineScale < Real.pi / 2 := by
  have hsqrt_nonneg : 0 ≤ Real.sqrt 2 := Real.sqrt_nonneg 2
  have hsqrt_sq : (Real.sqrt 2) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have hsqrt_lt : Real.sqrt 2 < (3 : ℝ) / 2 := by nlinarith
  have hlog : Real.log (1 + Real.sqrt 2) < (1 + Real.sqrt 2) - 1 :=
    Real.log_lt_sub_one_of_pos (by positivity) (by
      nlinarith [Real.sqrt_pos.2 (show (0 : ℝ) < 2 by norm_num)])
  rw [krivineScale]
  nlinarith [Real.pi_gt_three]

theorem krivineBeta_mul_pi_div_two :
    krivineBeta * Real.pi / 2 = krivineScale := by
  rw [krivineBeta]
  field_simp [Real.pi_ne_zero]

/-- An explicit rational lower bound for `log (1 + sqrt 2)`.  Four terms of
the odd-power expansion of `artanh (sqrt 2 - 1)` already suffice for the
numerical Krivine bound used in Theorem 3.5.6. -/
theorem krivineScale_gt_31416_div_35660 :
    (31416 / 35660 : ℝ) < krivineScale := by
  let x : ℝ := Real.sqrt 2 - 1
  let q : ℝ := 2071 / 5000
  have hsqrt_sq : (Real.sqrt 2) ^ 2 = (2 : ℝ) := Real.sq_sqrt (by norm_num)
  have hsqrt_nonneg : 0 ≤ Real.sqrt 2 := Real.sqrt_nonneg 2
  have hq_le_x : q ≤ x := by
    dsimp [q, x]
    nlinarith
  have hx_nonneg : 0 ≤ x := by
    dsimp [x]
    linarith [Real.one_lt_sqrt_two]
  have hx_lt_one : x < 1 := by
    dsimp [x]
    linarith [Real.sqrt_two_lt_three_halves]
  have hseries := Real.sum_range_le_log_div hx_nonneg hx_lt_one 4
  have hratio : (1 + x) / (1 - x) = 1 + Real.sqrt 2 := by
    dsimp [x]
    have hden : 2 - Real.sqrt 2 ≠ 0 := by
      linarith [Real.sqrt_two_lt_three_halves]
    rw [show 1 + (Real.sqrt 2 - 1) = Real.sqrt 2 by ring,
      show 1 - (Real.sqrt 2 - 1) = 2 - Real.sqrt 2 by ring]
    apply (div_eq_iff hden).2
    nlinarith
  rw [hratio] at hseries
  have hq_nonneg : 0 ≤ q := by norm_num [q]
  have hsum_lower :
      (∑ i ∈ Finset.range 4, q ^ (2 * i + 1) / (2 * i + 1)) ≤
        ∑ i ∈ Finset.range 4, x ^ (2 * i + 1) / (2 * i + 1) := by
    apply Finset.sum_le_sum
    intro i hi
    have hpow : q ^ (2 * i + 1) ≤ x ^ (2 * i + 1) := by
      exact pow_le_pow_left₀ hq_nonneg hq_le_x _
    exact div_le_div_of_nonneg_right hpow (by positivity)
  rw [krivineScale]
  have hnumeric :
      (31416 / 35660 : ℝ) <
        2 * (∑ i ∈ Finset.range 4, q ^ (2 * i + 1) / (2 * i + 1)) := by
    norm_num [q, Finset.sum_range_succ]
  nlinarith

/-- Krivine's explicit real constant is strictly smaller than `1.783`. -/
theorem inv_krivineBeta_lt_1783_div_1000 :
    krivineBeta⁻¹ < (1783 / 1000 : ℝ) := by
  have hs : (31416 / 35660 : ℝ) < krivineScale :=
    krivineScale_gt_31416_div_35660
  have hpi : Real.pi < (31416 / 10000 : ℝ) := by
    convert Real.pi_lt_d4 using 1; norm_num
  have hbeta_pos : 0 < krivineBeta := by
    rw [krivineBeta]
    positivity
  rw [inv_eq_one_div]
  apply (div_lt_iff₀ hbeta_pos).2
  rw [krivineBeta]
  have hmain : Real.pi < (1783 / 1000 : ℝ) * 2 * krivineScale := by
    nlinarith
  calc
    (1 : ℝ) < ((1783 / 1000 : ℝ) * 2 * krivineScale) / Real.pi :=
      (lt_div_iff₀ Real.pi_pos).2 (by simpa using hmain)
    _ = (1783 / 1000 : ℝ) * (2 / Real.pi * krivineScale) := by field_simp

/-- The magnitude-weighted feature map for the normalized sine series. -/
def krivineLeftFeature {n : ℕ} (u : Fin n → ℝ) : PowerSeriesFeatureSpace n :=
  absolutePowerSeriesFeature (fun x ↦ Real.sin (krivineScale * x))
    (scaledSineCoefficient krivineScale)
    (globallyConvergentPowerSeries_scaledSine krivineScale) u

/-- The sign-adjusted feature map for the normalized sine series. -/
def krivineRightFeature {n : ℕ} (u : Fin n → ℝ) : PowerSeriesFeatureSpace n :=
  signedPowerSeriesFeature (fun x ↦ Real.sin (krivineScale * x))
    (scaledSineCoefficient krivineScale)
    (globallyConvergentPowerSeries_scaledSine krivineScale) u

theorem krivineFeature_inner {n : ℕ} (u v : Fin n → ℝ) :
    ⟪krivineLeftFeature u, krivineRightFeature v⟫_ℝ =
      Real.sin (krivineScale * ∑ i, u i * v i) := by
  exact signedPowerSeriesFeature_inner
    (fun x ↦ Real.sin (krivineScale * x))
    (scaledSineCoefficient krivineScale)
    (globallyConvergentPowerSeries_scaledSine krivineScale) u v

theorem krivineFeature_norm_sq {n : ℕ} (u : Fin n → ℝ)
    (hu : ∑ i, u i * u i = 1) :
    ‖krivineLeftFeature u‖ ^ 2 = 1 ∧ ‖krivineRightFeature u‖ ^ 2 = 1 := by
  have hnorm := absolute_signed_powerSeriesFeature_norm_sq
    (fun x ↦ Real.sin (krivineScale * x))
    (scaledSineCoefficient krivineScale)
    (globallyConvergentPowerSeries_scaledSine krivineScale) u
  rw [hu] at hnorm
  simp only [one_pow, mul_one] at hnorm
  have hsum : (∑' k, |scaledSineCoefficient krivineScale k|) = 1 := by
    calc
      (∑' k, |scaledSineCoefficient krivineScale k|) =
          Real.sinh (|krivineScale| * 1) := by
        simpa using (scaledSineCoefficient_abs_hasSum krivineScale 1).tsum_eq
      _ = 1 := by
        rw [abs_of_pos krivineScale_pos, mul_one, krivineScale]
        exact sinh_log_one_add_sqrt_two
  simpa [krivineLeftFeature, krivineRightFeature, hsum] using hnorm

theorem krivineFeature_norm {n : ℕ} (u : Fin n → ℝ)
    (hu : ∑ i, u i * u i = 1) :
    ‖krivineLeftFeature u‖ = 1 ∧ ‖krivineRightFeature u‖ = 1 := by
  rcases krivineFeature_norm_sq u hu with ⟨hleft, hright⟩
  constructor <;> nlinarith [norm_nonneg (krivineLeftFeature u),
    norm_nonneg (krivineRightFeature u)]

/-- On Euclidean unit vectors the normalized signed features satisfy the
arcsine identity in Lemma 3.7.7. -/
theorem krivineFeature_arcsin {n : ℕ} (u v : Fin n → ℝ)
    (hu : ∑ i, u i * u i = 1) (hv : ∑ i, v i * v i = 1) :
    2 / Real.pi * Real.arcsin
      ⟪krivineLeftFeature u, krivineRightFeature v⟫_ℝ =
      krivineBeta * (∑ i, u i * v i) := by
  let u' : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 u
  let v' : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 v
  have hu_norm : ‖u'‖ = 1 := by
    have hu_sq : ‖u'‖ ^ 2 = 1 := by
      rw [← real_inner_self_eq_norm_sq]
      change (∑ i, u i * u i) = 1
      exact hu
    nlinarith [norm_nonneg u']
  have hv_norm : ‖v'‖ = 1 := by
    have hv_sq : ‖v'‖ ^ 2 = 1 := by
      rw [← real_inner_self_eq_norm_sq]
      change (∑ i, v i * v i) = 1
      exact hv
    nlinarith [norm_nonneg v']
  have hdot : -(1 : ℝ) ≤ ∑ i, u i * v i ∧ ∑ i, u i * v i ≤ 1 := by
    have hinner := real_inner_mem_Icc_of_norm_eq_one hu_norm hv_norm
    change -(1 : ℝ) ≤ ∑ i, v i * u i ∧ ∑ i, v i * u i ≤ 1 at hinner
    simpa [mul_comm] using hinner
  rw [krivineFeature_inner, Real.arcsin_sin]
  · rw [krivineBeta]
    ring
  · nlinarith [krivineScale_pos, krivineScale_lt_pi_div_two]
  · nlinarith [krivineScale_pos, krivineScale_lt_pi_div_two]

end NumStability.HDP.Tensor
