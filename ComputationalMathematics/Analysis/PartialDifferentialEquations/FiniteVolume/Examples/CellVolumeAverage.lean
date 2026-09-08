/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# Equal and different averages of heterogeneous fields

Quadratic and linear fields on adjacent unit intervals show that
within-cell variation does not force distinct normalized averages.
-/

open MeasureTheory

namespace NumStability.CellVolumeAverageExamples

/-- Two adjacent, disjoint, finite-volume real cells for the example below. -/
def symmetricCells : FiniteVolumeCellPartition Bool ℝ where
  domain := Set.Ioc (-1) 0 ∪ Set.Ioc 0 1
  cellRegion := fun cell => if cell then Set.Ioc 0 1 else Set.Ioc (-1) 0
  cells_nonempty := inferInstance
  measurable_cell := by intro cell; cases cell <;> exact measurableSet_Ioc
  disjoint_cells := by
    intro a b hab
    cases a <;> cases b
    · exact (hab rfl).elim
    · apply Set.disjoint_left.mpr
      intro x hx hy
      exact (not_lt_of_ge hx.2) hy.1
    · apply Set.disjoint_left.mpr
      intro x hx hy
      exact (not_lt_of_ge hy.2) hx.1
    · exact (hab rfl).elim
  covers_domain := by
    intro x
    simp only [Bool.exists_bool, Bool.false_eq_true, ↓reduceIte]
    rfl

theorem symmetricCells_volume (cell : Bool) :
    volume (symmetricCells.cellRegion cell) = 1 := by
  cases cell <;> norm_num [symmetricCells, Real.volume_Ioc] <;> rfl

theorem quadratic_integrable_on_cell (cell : Bool) :
    IntegrableOn (fun x : ℝ => x ^ 2) (symmetricCells.cellRegion cell) volume := by
  cases cell <;>
    exact (intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num)).mp
      ((continuous_pow 2).intervalIntegrable _ _)

theorem quadratic_cell_average (cell : Bool) :
    cellVolumeAverage volume (symmetricCells.cellRegion cell) (fun x : ℝ => x ^ 2) =
      (1 / 3 : ℝ) := by
  cases cell <;> change cellVolumeAverage volume (Set.Ioc _ _) _ = _
  all_goals
    rw [cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ (by norm_num)]
    norm_num [oneDimensionalCellAverage, integral_pow]
    rfl

/-- The scalar field varies inside each cell, although both averages are 1/3. -/
theorem quadratic_heterogeneous_each_cell (cell : Bool) :
    ∃ x ∈ symmetricCells.cellRegion cell, ∃ y ∈ symmetricCells.cellRegion cell,
      (x ^ 2 : ℝ) ≠ y ^ 2 := by
  cases cell
  · refine ⟨-1 / 2, ?_, 0, ?_, ?_⟩ <;> norm_num [symmetricCells]
  · refine ⟨1 / 2, ?_, 1, ?_, ?_⟩ <;> norm_num [symmetricCells]

/-- Nonvacuity and a counterexample to requiring distinct cell averages. -/
theorem heterogeneous_equal_average_nonvacuity :
    (∀ cell, volume (symmetricCells.cellRegion cell) = 1) ∧
    (∀ cell, IsCellVolumeAverage volume (symmetricCells.cellRegion cell)
      (fun x : ℝ => x ^ 2) (1 / 3 : ℝ)) ∧
    (∀ cell, ∃ x ∈ symmetricCells.cellRegion cell, ∃ y ∈ symmetricCells.cellRegion cell,
      (x ^ 2 : ℝ) ≠ y ^ 2) ∧
    ¬ ∃ a b, cellVolumeAverage volume (symmetricCells.cellRegion a) (fun x : ℝ => x ^ 2) ≠
      cellVolumeAverage volume (symmetricCells.cellRegion b) (fun x : ℝ => x ^ 2) := by
  refine ⟨symmetricCells_volume, ?_, quadratic_heterogeneous_each_cell, ?_⟩
  · intro cell
    refine ⟨?_, ?_, quadratic_integrable_on_cell cell, (quadratic_cell_average cell).symm⟩
    · rw [symmetricCells_volume]; norm_num
    · rw [symmetricCells_volume]; norm_num
  · simp only [quadratic_cell_average, ne_eq, not_true_eq_false, exists_const, not_false_eq_true]

/-- The same cells also admit distinct averages for another integrable field. -/
theorem linear_cell_average (cell : Bool) :
    cellVolumeAverage volume (symmetricCells.cellRegion cell) (fun x : ℝ => x) =
      if cell then (1 / 2 : ℝ) else (-1 / 2 : ℝ) := by
  cases cell <;> change cellVolumeAverage volume (Set.Ioc _ _) _ = _
  all_goals
    rw [cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ (by norm_num)]
    norm_num [oneDimensionalCellAverage, integral_id]
    rfl

theorem heterogeneous_different_average_nonvacuity :
    (∀ cell, IsCellVolumeAverage volume (symmetricCells.cellRegion cell)
      (fun x : ℝ => x) (if cell then (1 / 2 : ℝ) else (-1 / 2 : ℝ))) ∧
    cellVolumeAverage volume (symmetricCells.cellRegion false) (fun x : ℝ => x) ≠
      cellVolumeAverage volume (symmetricCells.cellRegion true) (fun x : ℝ => x) := by
  constructor
  · intro cell
    refine ⟨?_, ?_, ?_, (linear_cell_average cell).symm⟩
    · rw [symmetricCells_volume]; norm_num
    · rw [symmetricCells_volume]; norm_num
    · cases cell <;>
        exact (intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num)).mp
          (continuous_id.intervalIntegrable _ _)
  · norm_num [linear_cell_average]

end NumStability.CellVolumeAverageExamples
