import ComputationalMathematics.HDP.Tensor.Finite
import ComputationalMathematics.HDP.Tensor.PowerSeries
import Mathlib.Analysis.InnerProductSpace.l2Space

/-!
# Analytic tensor-power features

The Hilbert direct sum of all finite tensor powers realizes globally convergent
power series with nonnegative coefficients as inner-product kernels.
-/

noncomputable section

open scoped BigOperators InnerProductSpace ENNReal

namespace NumStability.HDP.Tensor

/-- The Hilbert direct sum of all finite tensor-power coordinate spaces. -/
abbrev PowerSeriesFeatureSpace (n : ℕ) :=
  lp (fun k : ℕ ↦ EuclideanSpace ℝ (Fin k → Fin n)) 2

/-- One scaled tensor-power block in the analytic feature map. -/
def powerSeriesFeatureBlock {n : ℕ} (c : ℝ) (u : Fin n → ℝ) (k : ℕ) :
    EuclideanSpace ℝ (Fin k → Fin n) :=
  WithLp.toLp 2 (fun i ↦ Real.sqrt c * power u k i)

/-- The inner product of two nonnegatively scaled tensor-power blocks. -/
theorem powerSeriesFeatureBlock_inner {n : ℕ} (c : ℝ) (hc : 0 ≤ c)
    (u v : Fin n → ℝ) (k : ℕ) :
    ⟪powerSeriesFeatureBlock c u k, powerSeriesFeatureBlock c v k⟫_ℝ =
      c * (∑ i, u i * v i) ^ k := by
  simp only [PiLp.inner_apply, powerSeriesFeatureBlock]
  change (∑ x, (Real.sqrt c * power v k x) *
      (Real.sqrt c * power u k x)) = _
  have hterm (x : Fin k → Fin n) :
      (Real.sqrt c * power v k x) * (Real.sqrt c * power u k x) =
        (Real.sqrt c * Real.sqrt c) * (power u k x * power v k x) := by
    ring
  rw [Finset.sum_congr rfl (fun x _ ↦ hterm x), ← Finset.mul_sum,
    Real.mul_self_sqrt hc]
  change c * inner (power u k) (power v k) = _
  rw [inner_power_power]

/-- The square-summable feature vector whose degree-`k` block is
`sqrt (a k) * u^⊗k`. -/
def powerSeriesFeature {n : ℕ} (f : ℝ → ℝ) (a : ℕ → ℝ)
    (ha : ∀ k, 0 ≤ a k) (hseries : GloballyConvergentPowerSeries f a)
    (u : Fin n → ℝ) : PowerSeriesFeatureSpace n := by
  refine ⟨fun k ↦ powerSeriesFeatureBlock (a k) u k, ?_⟩
  apply memℓp_gen
  have hs := hseries.summable (∑ i, u i * u i)
  apply hs.congr
  intro k
  norm_num
  rw [← real_inner_self_eq_norm_sq,
    powerSeriesFeatureBlock_inner (a k) (ha k) u u k]

/-- A globally convergent power series with nonnegative coefficients is the
inner-product kernel of its weighted Hilbert sum of tensor powers. -/
theorem powerSeriesFeature_inner {n : ℕ} (f : ℝ → ℝ) (a : ℕ → ℝ)
    (ha : ∀ k, 0 ≤ a k) (hseries : GloballyConvergentPowerSeries f a)
    (u v : Fin n → ℝ) :
    ⟪powerSeriesFeature f a ha hseries u,
      powerSeriesFeature f a ha hseries v⟫_ℝ =
      f (∑ i, u i * v i) := by
  rw [lp.inner_eq_tsum]
  change (∑' k, ⟪powerSeriesFeatureBlock (a k) u k,
    powerSeriesFeatureBlock (a k) v k⟫_ℝ) = _
  rw [tsum_congr (fun k ↦ powerSeriesFeatureBlock_inner (a k) (ha k) u v k)]
  exact (hseries.eq_tsum (∑ i, u i * v i)).symm

end NumStability.HDP.Tensor
