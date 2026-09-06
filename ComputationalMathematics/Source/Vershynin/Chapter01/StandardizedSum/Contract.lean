import ComputationalMathematics.HDP.Scalar.LimitTheorems
import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# Contract: HDP Chapter 1 normalized CLT sum

This source-facing leaf records the normalized sum displayed in Theorem 1.3.2
and the algebraic equivalence of its two forms under explicit positive-variance
and moment identities.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open scoped BigOperators

/--
The second displayed formula for the normalized sum in Theorem 1.3.2:
`Z_N = (σ * √N)⁻¹ ∑_{i < N} (X_i - m)`.
-/
noncomputable def hdp_01_hdef_hzn
    {Ω : Type*} (X : ℕ → Ω → ℝ) (m σ : ℝ) (N : ℕ) : Ω → ℝ :=
  fun ω => (σ * Real.sqrt (N : ℝ))⁻¹ *
    ∑ i ∈ Finset.range N, (X i ω - m)

/-- Measurability of the normalized sum, used by its distributional wrapper. -/
theorem hdp_01_hdef_hzn_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : ℕ → Ω → ℝ) (m σ : ℝ) (N : ℕ)
    (hX : ∀ i, AEMeasurable (X i) μ) :
    AEMeasurable (hdp_01_hdef_hzn X m σ N) μ := by
  unfold hdp_01_hdef_hzn
  apply AEMeasurable.const_mul
  exact (Finset.range N).aemeasurable_fun_sum fun i _ ↦
    (hX i).sub aemeasurable_const

/--
The two displayed formulas for `Z_N` agree when the partial sum has mean
`N m`, variance `N σ²`, and `N, σ` are positive.
-/
theorem hdp_01_hdef_hzn_eq_source_normalization
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : ℕ → Ω → ℝ) (m σ : ℝ) (N : ℕ)
    (hN : 0 < N) (hσ : 0 < σ)
    (hMean :
      NumStability.HDP.Scalar.Preliminaries.expectation μ
          (fun ω => ∑ i ∈ Finset.range N, X i ω) =
        (N : ℝ) * m)
    (hVar :
      NumStability.HDP.Scalar.Preliminaries.variance μ
          (fun ω => ∑ i ∈ Finset.range N, X i ω) =
        (N : ℝ) * σ ^ 2) :
    (fun ω =>
      ((∑ i ∈ Finset.range N, X i ω) -
          NumStability.HDP.Scalar.Preliminaries.expectation μ
            (fun ω => ∑ i ∈ Finset.range N, X i ω)) /
        Real.sqrt
          (NumStability.HDP.Scalar.Preliminaries.variance μ
            (fun ω => ∑ i ∈ Finset.range N, X i ω))) =
      hdp_01_hdef_hzn X m σ N := by
  have hNreal : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hsqrt :
      Real.sqrt ((N : ℝ) * σ ^ 2) =
        σ * Real.sqrt (N : ℝ) := by
    rw [Real.sqrt_mul hNreal.le, Real.sqrt_sq_eq_abs, abs_of_pos hσ, mul_comm]
  funext ω
  rw [hMean, hVar, hsqrt, div_eq_inv_mul]
  congr 1
  rw [Finset.sum_sub_distrib]
  simp [nsmul_eq_mul]

end NumStability.HDP.Contract
