import ComputationalMathematics.HDP.Kernel.PositiveSemidefinite
import ComputationalMathematics.HDP.Tensor.AnalyticFeature
import Mathlib.Analysis.SpecialFunctions.Exponential

/-!
# Gaussian kernels

The Gaussian radial-basis kernel is realized by rescaling the nonnegative
power-series feature map for the exponential dot-product kernel.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Kernel

/-- Coefficients of `x ↦ exp (c * x)`. -/
def exponentialCoefficient (c : ℝ) (k : ℕ) : ℝ :=
  c ^ k / (k.factorial : ℝ)

theorem exponentialCoefficient_nonneg (c : ℝ) (hc : 0 ≤ c) (k : ℕ) :
    0 ≤ exponentialCoefficient c k := by
  exact div_nonneg (pow_nonneg hc k) (Nat.cast_nonneg _)

theorem globallyConvergentPowerSeries_exp_mul (c : ℝ) :
    NumStability.HDP.Tensor.GloballyConvergentPowerSeries
      (fun x : ℝ ↦ Real.exp (c * x)) (exponentialCoefficient c) := by
  intro x
  rw [Real.exp_eq_exp_ℝ]
  convert NormedSpace.expSeries_div_hasSum_exp (c * x) using 1
  ext k
  simp only [exponentialCoefficient]
  ring

/-- The exponential dot-product feature map. -/
def exponentialDotFeature {n : ℕ} (c : ℝ) (hc : 0 ≤ c) (u : Fin n → ℝ) :
    NumStability.HDP.Tensor.PowerSeriesFeatureSpace n :=
  NumStability.HDP.Tensor.powerSeriesFeature
    (fun x : ℝ ↦ Real.exp (c * x)) (exponentialCoefficient c)
    (exponentialCoefficient_nonneg c hc)
    (globallyConvergentPowerSeries_exp_mul c) u

theorem exponentialDotFeature_inner {n : ℕ} (c : ℝ) (hc : 0 ≤ c)
    (u v : Fin n → ℝ) :
    ⟪exponentialDotFeature c hc u, exponentialDotFeature c hc v⟫_ℝ =
      Real.exp (c * ∑ i, u i * v i) := by
  exact NumStability.HDP.Tensor.powerSeriesFeature_inner
    (fun x : ℝ ↦ Real.exp (c * x)) (exponentialCoefficient c)
    (exponentialCoefficient_nonneg c hc)
    (globallyConvergentPowerSeries_exp_mul c) u v

/-- The Gaussian radial-basis feature map with bandwidth `σ`. -/
def gaussianFeature {n : ℕ} (σ : ℝ) (hσ : 0 < σ) (u : Fin n → ℝ) :
    NumStability.HDP.Tensor.PowerSeriesFeatureSpace n :=
  Real.exp (-(∑ i, u i ^ 2) / (2 * σ ^ 2)) •
    exponentialDotFeature (1 / σ ^ 2) (by positivity) u

theorem gaussianFeature_inner {n : ℕ} (σ : ℝ) (hσ : 0 < σ)
    (u v : Fin n → ℝ) :
    ⟪gaussianFeature σ hσ u, gaussianFeature σ hσ v⟫_ℝ =
      Real.exp (-(∑ i, (u i - v i) ^ 2) / (2 * σ ^ 2)) := by
  simp only [gaussianFeature, real_inner_smul_left, real_inner_smul_right,
    exponentialDotFeature_inner]
  rw [← Real.exp_add, ← Real.exp_add]
  congr 1
  have hσ2 : σ ^ 2 ≠ 0 := pow_ne_zero 2 hσ.ne'
  have hsum : (∑ i, (u i - v i) ^ 2) =
      (∑ i, u i ^ 2) + (∑ i, v i ^ 2) - 2 * ∑ i, u i * v i := by
    rw [Finset.sum_congr rfl (fun i _ ↦ sub_sq (u i) (v i))]
    rw [Finset.sum_add_distrib, Finset.sum_sub_distrib]
    simp_rw [mul_assoc]
    rw [← Finset.mul_sum]
    ring
  rw [hsum]
  field_simp [hσ2]
  ring

/-- The Gaussian radial-basis kernel is positive semidefinite. -/
theorem gaussianKernel_isPositiveSemidefinite {n : ℕ} (σ : ℝ) (hσ : 0 < σ) :
    IsPositiveSemidefinite
      (fun u v : Fin n → ℝ ↦
        Real.exp (-(∑ i, (u i - v i) ^ 2) / (2 * σ ^ 2))) := by
  apply IsRealFeatureMap.isPositiveSemidefinite (Φ := gaussianFeature σ hσ)
  intro u v
  exact gaussianFeature_inner σ hσ u v

end NumStability.HDP.Kernel
