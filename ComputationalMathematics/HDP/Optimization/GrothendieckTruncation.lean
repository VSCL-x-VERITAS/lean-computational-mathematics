import Mathlib.Data.Matrix.Basic
import Mathlib.MeasureTheory.Function.L2Space

/-!
# Finite bilinear sums in `L²`

This module records the integral-to-`L²`-inner-product identity used in the
truncation proof of Grothendieck's inequality.  The statement is independent
of the Gaussian construction: every finite bilinear sum of real `L²`
functions has the same identity.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Optimization

private theorem inner_real_eq_mul (x y : ℝ) : ⟪x, y⟫_ℝ = x * y := by
  have hone : ⟪(1 : ℝ), (1 : ℝ)⟫_ℝ = 1 := by
    rw [real_inner_self_eq_norm_sq]
    norm_num
  calc
    ⟪x, y⟫_ℝ = ⟪x • (1 : ℝ), y • (1 : ℝ)⟫_ℝ := by simp
    _ = x * y := by
      rw [real_inner_smul_left, real_inner_smul_right, hone]
      ring

/-- Integration carries a finite bilinear sum of real `L²` functions to the
same finite sum of their `L²` inner products. -/
theorem integral_bilinear_sum_eq_sum_l2_inner
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (U : Fin m → Lp ℝ 2 μ) (V : Fin n → Lp ℝ 2 μ) :
    (∫ ω, ∑ i, ∑ j, A i j * U i ω * V j ω ∂μ) =
      ∑ i, ∑ j, A i j * ⟪U i, V j⟫_ℝ := by
  rw [integral_finset_sum]
  · apply Finset.sum_congr rfl
    intro i _
    rw [integral_finset_sum]
    · apply Finset.sum_congr rfl
      intro j _
      have hinter :
          (∫ ω, U i ω * V j ω ∂μ) = ⟪U i, V j⟫_ℝ := by
        rw [MeasureTheory.L2.inner_def]
        apply MeasureTheory.integral_congr_ae
        filter_upwards [] with ω
        rw [inner_real_eq_mul]
      rw [show (fun ω => A i j * U i ω * V j ω) =
          (fun ω => A i j * (U i ω * V j ω)) by funext ω; ring,
        MeasureTheory.integral_const_mul, hinter]
    · intro j _
      have h := MeasureTheory.L2.integrable_inner (𝕜 := ℝ) (U i) (V j)
      have hmul : Integrable (fun ω => U i ω * V j ω) μ := by
        simpa only [inner_real_eq_mul] using h
      simpa only [mul_assoc] using hmul.const_mul (A i j)
  · intro i _
    exact integrable_finset_sum _ fun j _ => by
      have h := MeasureTheory.L2.integrable_inner (𝕜 := ℝ) (U i) (V j)
      have hmul : Integrable (fun ω => U i ω * V j ω) μ := by
        simpa only [inner_real_eq_mul] using h
      simpa only [mul_assoc] using hmul.const_mul (A i j)

end NumStability.HDP.Optimization
