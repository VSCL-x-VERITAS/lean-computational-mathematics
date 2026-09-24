import ComputationalMathematics.HDP.Tensor.AnalyticFeature
import Mathlib.Data.Sign.Basic

/-!
# Signed analytic tensor-power features

Splitting coefficient magnitudes and signs between two feature maps realizes
globally convergent real power series with arbitrary real coefficients.
-/

noncomputable section

open scoped BigOperators InnerProductSpace ENNReal

namespace NumStability.HDP.Tensor

theorem GloballyConvergentPowerSeries.summable_abs_coeff_mul_pow_of_nonneg
    {f : ℝ → ℝ} {a : ℕ → ℝ} (hseries : GloballyConvergentPowerSeries f a)
    {x : ℝ} (hx : 0 ≤ x) :
    Summable (fun k : ℕ ↦ |a k| * x ^ k) := by
  have hs := (hseries.summable x).norm
  simpa [Real.norm_eq_abs, abs_mul, abs_pow, abs_of_nonneg hx] using hs

/-- The sign-adjusted degree-`k` block used in the right feature map. -/
def signedPowerSeriesFeatureBlock {n : ℕ} (c : ℝ) (u : Fin n → ℝ) (k : ℕ) :
    EuclideanSpace ℝ (Fin k → Fin n) :=
  (SignType.sign c : ℝ) • powerSeriesFeatureBlock |c| u k

theorem signedPowerSeriesFeatureBlock_cross_inner {n : ℕ} (c : ℝ)
    (u v : Fin n → ℝ) (k : ℕ) :
    ⟪powerSeriesFeatureBlock |c| u k,
      signedPowerSeriesFeatureBlock c v k⟫_ℝ =
      c * (∑ i, u i * v i) ^ k := by
  rw [signedPowerSeriesFeatureBlock, real_inner_smul_right,
    powerSeriesFeatureBlock_inner |c| (abs_nonneg c) u v k]
  rw [← mul_assoc, sign_mul_abs]

theorem signedPowerSeriesFeatureBlock_norm {n : ℕ} (c : ℝ)
    (u : Fin n → ℝ) (k : ℕ) :
    ‖signedPowerSeriesFeatureBlock c u k‖ =
      ‖powerSeriesFeatureBlock |c| u k‖ := by
  rcases lt_trichotomy c 0 with hc | rfl | hc
  · rw [signedPowerSeriesFeatureBlock, sign_neg hc]
    simp
  · have hz : powerSeriesFeatureBlock (0 : ℝ) u k = 0 := by
      ext i
      simp [powerSeriesFeatureBlock]
    simp [signedPowerSeriesFeatureBlock, hz]
  · rw [signedPowerSeriesFeatureBlock, sign_pos hc]
    simp

/-- The left feature map, using the square roots of coefficient magnitudes. -/
def absolutePowerSeriesFeature {n : ℕ} (f : ℝ → ℝ) (a : ℕ → ℝ)
    (hseries : GloballyConvergentPowerSeries f a) (u : Fin n → ℝ) :
    PowerSeriesFeatureSpace n := by
  refine ⟨fun k ↦ powerSeriesFeatureBlock |a k| u k, ?_⟩
  apply memℓp_gen
  have hx : 0 ≤ ∑ i, u i * u i :=
    Finset.sum_nonneg fun i _ ↦ mul_self_nonneg (u i)
  have hs := hseries.summable_abs_coeff_mul_pow_of_nonneg hx
  apply hs.congr
  intro k
  norm_num
  rw [← real_inner_self_eq_norm_sq,
    powerSeriesFeatureBlock_inner |a k| (abs_nonneg (a k)) u u k]

/-- The right feature map, with coefficient signs included blockwise. -/
def signedPowerSeriesFeature {n : ℕ} (f : ℝ → ℝ) (a : ℕ → ℝ)
    (hseries : GloballyConvergentPowerSeries f a) (u : Fin n → ℝ) :
    PowerSeriesFeatureSpace n := by
  refine ⟨fun k ↦ signedPowerSeriesFeatureBlock (a k) u k, ?_⟩
  apply memℓp_gen
  have hx : 0 ≤ ∑ i, u i * u i :=
    Finset.sum_nonneg fun i _ ↦ mul_self_nonneg (u i)
  have hs := hseries.summable_abs_coeff_mul_pow_of_nonneg hx
  apply hs.congr
  intro k
  norm_num
  rw [signedPowerSeriesFeatureBlock_norm,
    ← real_inner_self_eq_norm_sq,
    powerSeriesFeatureBlock_inner |a k| (abs_nonneg (a k)) u u k]

/-- Arbitrary globally convergent real power series are cross-inner-product
kernels after splitting coefficient signs between two feature maps. -/
theorem signedPowerSeriesFeature_inner {n : ℕ} (f : ℝ → ℝ) (a : ℕ → ℝ)
    (hseries : GloballyConvergentPowerSeries f a) (u v : Fin n → ℝ) :
    ⟪absolutePowerSeriesFeature f a hseries u,
      signedPowerSeriesFeature f a hseries v⟫_ℝ =
      f (∑ i, u i * v i) := by
  rw [lp.inner_eq_tsum]
  change (∑' k, ⟪powerSeriesFeatureBlock |a k| u k,
    signedPowerSeriesFeatureBlock (a k) v k⟫_ℝ) = _
  rw [tsum_congr (fun k ↦ signedPowerSeriesFeatureBlock_cross_inner (a k) u v k)]
  exact (hseries.eq_tsum (∑ i, u i * v i)).symm

/-- Both signed feature maps have squared norm equal to the absolute-coefficient
power series evaluated at the squared Euclidean norm. -/
theorem absolute_signed_powerSeriesFeature_norm_sq {n : ℕ}
    (f : ℝ → ℝ) (a : ℕ → ℝ) (hseries : GloballyConvergentPowerSeries f a)
    (u : Fin n → ℝ) :
    ‖absolutePowerSeriesFeature f a hseries u‖ ^ 2 =
        ∑' k, |a k| * (∑ i, u i * u i) ^ k ∧
      ‖signedPowerSeriesFeature f a hseries u‖ ^ 2 =
        ∑' k, |a k| * (∑ i, u i * u i) ^ k := by
  constructor
  · rw [← real_inner_self_eq_norm_sq, lp.inner_eq_tsum]
    change (∑' k, ⟪powerSeriesFeatureBlock |a k| u k,
      powerSeriesFeatureBlock |a k| u k⟫_ℝ) = _
    exact tsum_congr (fun k ↦
      powerSeriesFeatureBlock_inner |a k| (abs_nonneg (a k)) u u k)
  · rw [← real_inner_self_eq_norm_sq, lp.inner_eq_tsum]
    apply tsum_congr
    intro k
    change ⟪signedPowerSeriesFeatureBlock (a k) u k,
      signedPowerSeriesFeatureBlock (a k) u k⟫_ℝ = _
    rw [real_inner_self_eq_norm_sq, signedPowerSeriesFeatureBlock_norm,
      ← real_inner_self_eq_norm_sq,
      powerSeriesFeatureBlock_inner |a k| (abs_nonneg (a k)) u u k]

end NumStability.HDP.Tensor
