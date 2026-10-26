/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates

/-!
# Cell-average error relative to the center of a Lipschitz profile
-/

open MeasureTheory

namespace NumStability

/-- Normalized averaging preserves a constant on every nondegenerate interval. -/
theorem oneDimensionalCellAverage_const
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (value : E) (left right : ℝ) (hinterval : left ≠ right) :
    oneDimensionalCellAverage (fun _ : ℝ => value) left right = value := by
  simp [oneDimensionalCellAverage, intervalIntegral.integral_const,
    smul_smul, sub_ne_zero.mpr hinterval.symm]

/-- A uniform absolute-value bound is preserved by normalized averaging. -/
theorem abs_oneDimensionalCellAverage_le_of_bound
    (f : ℝ → ℝ) (bound left right : ℝ) (hinterval : left < right)
    (hf : IntervalIntegrable f volume left right) (hbound : ∀ x, |f x| ≤ bound) :
    |oneDimensionalCellAverage f left right| ≤ bound := by
  have h := norm_oneDimensionalCellAverage_sub_le (f := f) (g := fun _ : ℝ => (0 : ℝ))
    hinterval hf intervalIntegrable_const
    (fun x _ => by simpa only [sub_zero, Real.norm_eq_abs] using hbound x)
  simpa [oneDimensionalCellAverage, Real.norm_eq_abs] using h

/-- A Lipschitz profile differs from its centered interval average by at
most its Lipschitz constant times half the interval width. -/
theorem oneDimensionalCellAverage_sub_center_le_of_lipschitz
    (f : ℝ → ℝ) (L center width : ℝ) (hL : 0 ≤ L) (hwidth : 0 < width)
    (hf : Continuous f) (hLip : ∀ x y, |f x - f y| ≤ L * |x - y|) :
    |oneDimensionalCellAverage f (center - width / 2) (center + width / 2) - f center| ≤
      L * (width / 2) := by
  have hinterval : center - width / 2 < center + width / 2 := by linarith
  have hconstant : oneDimensionalCellAverage (fun _ : ℝ => f center)
      (center - width / 2) (center + width / 2) = f center := by
    exact oneDimensionalCellAverage_const _ _ _ (ne_of_lt hinterval)
  have h := norm_oneDimensionalCellAverage_sub_le (f := f) (g := fun _ => f center)
    hinterval (hf.intervalIntegrable _ _) intervalIntegrable_const
    (bound := L * (width / 2)) (fun x hx => by
      have hxlo : center - width / 2 ≤ x := by
        simpa only [min_eq_left hinterval.le] using hx.1.le
      have hxhi : x ≤ center + width / 2 := by
        simpa only [max_eq_right hinterval.le] using hx.2
      have hdist : |x - center| ≤ width / 2 := abs_le.mpr ⟨by linarith, by linarith⟩
      simpa only [Real.norm_eq_abs] using
        (hLip x center).trans (mul_le_mul_of_nonneg_left hdist hL))
  simpa only [hconstant, Real.norm_eq_abs] using h

end NumStability
