import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.Average
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
Scratch normalized-volume alternative only. No assertion about which material
averaging convention the selected source intends is made here.
-/

open MeasureTheory

namespace NumStability.HeterogeneousVolumeDraft

variable {Point E Cell : Type*} [MeasurableSpace Point]
  [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Bridge to the existing Mathlib average; no new averaging operator. -/
theorem cellVolumeAverage_eq_setAverage (μ : Measure Point)
    (region : Set Point) (field : Point → E) :
    cellVolumeAverage μ region field = ⨍ point in region, field point ∂μ := by
  rw [MeasureTheory.setAverage_eq]
  rfl

/-- Equality almost everywhere inside a cell suffices for locality. -/
theorem cellVolumeAverage_congr_ae (μ : Measure Point) (region : Set Point)
    {field other : Point → E} (h : field =ᵐ[μ.restrict region] other) :
    cellVolumeAverage μ region field = cellVolumeAverage μ region other := by
  simp only [cellVolumeAverage_eq_setAverage]
  exact MeasureTheory.average_congr h

/-- Changing a field outside the cell has no effect. -/
theorem cellVolumeAverage_congr (μ : Measure Point) {region : Set Point}
    (hs : MeasurableSet region) {field other : Point → E}
    (h : Set.EqOn field other region) :
    cellVolumeAverage μ region field = cellVolumeAverage μ region other := by
  simp only [cellVolumeAverage_eq_setAverage]
  exact MeasureTheory.setAverage_congr_fun hs (Filter.Eventually.of_forall h)

/-- Finite positive volume gives exact reproduction of constants. -/
theorem cellVolumeAverage_const [CompleteSpace E] (μ : Measure Point) (region : Set Point)
    (hpositive : μ region ≠ 0) (hfinite : μ region ≠ ⊤) (value : E) :
    cellVolumeAverage μ region (fun _ => value) = value := by
  rw [cellVolumeAverage_eq_setAverage]
  exact MeasureTheory.setAverage_const hpositive hfinite value

/-- An integrable field has a unique normalized assignment on the supplied
measurable cells. Different cells may have equal or different values. -/
theorem existsUnique_cellVolumeAssignment
    (grid : FiniteVolumeCellPartition Cell Point) (μ : Measure Point)
    (field : Point → E)
    (hpositive : ∀ cell, μ (grid.cellRegion cell) ≠ 0)
    (hfinite : ∀ cell, μ (grid.cellRegion cell) ≠ ⊤)
    (hintegrable : ∀ cell, IntegrableOn field (grid.cellRegion cell) μ) :
    ∃! assigned : Cell → E,
      ∀ cell, IsCellVolumeAverage μ (grid.cellRegion cell) field (assigned cell) := by
  refine ⟨fun cell => cellVolumeAverage μ (grid.cellRegion cell) field, ?_, ?_⟩
  · intro cell
    exact cellVolumeAverage_isCellVolumeAverage μ _ field
      (hpositive cell) (hfinite cell) (hintegrable cell)
  · intro assigned hassigned
    funext cell
    exact (hassigned cell).2.2.2

/-- Concrete normalized-volume assignment, locality and constant preservation.
There is no premise requiring heterogeneity or different resulting averages. -/
theorem cellVolumeAssignment_contract [CompleteSpace E]
    (grid : FiniteVolumeCellPartition Cell Point) (μ : Measure Point)
    (field : Point → E)
    (hpositive : ∀ cell, μ (grid.cellRegion cell) ≠ 0)
    (hfinite : ∀ cell, μ (grid.cellRegion cell) ≠ ⊤)
    (hintegrable : ∀ cell, IntegrableOn field (grid.cellRegion cell) μ) :
    ∃ assigned : Cell → E,
      (∀ cell, IsCellVolumeAverage μ (grid.cellRegion cell) field (assigned cell)) ∧
      (∀ cell other, Set.EqOn field other (grid.cellRegion cell) →
        assigned cell = cellVolumeAverage μ (grid.cellRegion cell) other) ∧
      (∀ cell (value : E), cellVolumeAverage μ (grid.cellRegion cell)
        (fun _ => value) = value) := by
  refine ⟨fun cell => cellVolumeAverage μ (grid.cellRegion cell) field, ?_, ?_, ?_⟩
  · intro cell
    exact cellVolumeAverage_isCellVolumeAverage μ _ field
      (hpositive cell) (hfinite cell) (hintegrable cell)
  · intro cell other h
    exact cellVolumeAverage_congr μ (grid.measurable_cell cell) h
  · intro cell value
    exact cellVolumeAverage_const μ _ (hpositive cell) (hfinite cell) value

/-- The existing multidimensional volume operator agrees with the existing
interval operator on a positively oriented real interval. -/
theorem cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
    (field : ℝ → E) {left right : ℝ} (h : left < right) :
    cellVolumeAverage volume (Set.Ioc left right) field =
      oneDimensionalCellAverage field left right := by
  rw [cellVolumeAverage, Real.volume_Ioc, ENNReal.toReal_ofReal (sub_nonneg.mpr h.le),
    ← intervalIntegral.integral_of_le h.le]
  rfl

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

end NumStability.HeterogeneousVolumeDraft
