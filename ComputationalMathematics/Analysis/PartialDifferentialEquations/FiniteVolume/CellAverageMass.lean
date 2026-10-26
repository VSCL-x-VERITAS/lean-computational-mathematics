/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Physical mass from exact and approximate cell averages

Positive, possibly nonuniform consecutive cells reconstruct the Bochner
integral from exact averages. Supplied norm errors propagate with the
actual cell widths. These identities apply to complete real normed spaces.
-/

namespace NumStability
open MeasureTheory intervalIntegral
open scoped BigOperators
theorem cellAverage_massProjection
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (edge : ℕ → ℝ) (field : ℝ → E) (N : ℕ)
    (hcell : ∀ k < N, edge k < edge (k+1))
    (hint : ∀ k < N, IntervalIntegrable field volume (edge k) (edge (k+1))) :
    (∑ k ∈ Finset.range N, (edge (k+1)-edge k) •
      oneDimensionalCellAverage field (edge k) (edge (k+1))) =
      ∫ x in edge 0..edge N, field x := by
  calc
    _ = ∑ k ∈ Finset.range N, ∫ x in edge k..edge (k+1), field x := by
      apply Finset.sum_congr rfl
      intro k hk
      exact cellWidth_smul_oneDimensionalCellAverage field (hcell k (Finset.mem_range.mp hk))
    _ = _ := sum_integral_adjacent_intervals hint

theorem cellAverage_massError
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (edge : ℕ → ℝ) (field : ℝ → E) (values : ℕ → E) (error : ℕ → ℝ) (N : ℕ)
    (hcell : ∀ k < N, edge k < edge (k+1))
    (hint : ∀ k < N, IntervalIntegrable field volume (edge k) (edge (k+1)))
    (herror : ∀ k < N, ‖values k-oneDimensionalCellAverage field (edge k) (edge (k+1))‖ ≤ error k) :
    ‖(∑ k ∈ Finset.range N, (edge (k+1)-edge k) • values k)-
      ∫ x in edge 0..edge N, field x‖ ≤
      ∑ k ∈ Finset.range N, (edge (k+1)-edge k)*error k := by
  rw [← cellAverage_massProjection edge field N hcell hint,
    ← Finset.sum_sub_distrib]
  have heq : (∑ k ∈ Finset.range N,
      ((edge (k+1)-edge k) • values k - (edge (k+1)-edge k) •
      oneDimensionalCellAverage field (edge k) (edge (k+1)))) =
      ∑ k ∈ Finset.range N, (edge (k+1)-edge k) •
      (values k-oneDimensionalCellAverage field (edge k) (edge (k+1))) := by
    apply Finset.sum_congr rfl
    intro k _
    exact (smul_sub _ _ _).symm
  rw [heq]
  apply (norm_sum_le _ _).trans
  apply Finset.sum_le_sum
  intro k hk
  rw [norm_smul,Real.norm_eq_abs,abs_of_pos (sub_pos.mpr (hcell k (Finset.mem_range.mp hk)))]
  exact mul_le_mul_of_nonneg_left (herror k (Finset.mem_range.mp hk))
    (sub_nonneg.mpr (hcell k (Finset.mem_range.mp hk)).le)

end NumStability
