/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# LeVeque Chapter 1, heterogeneous material cell averages

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 8 (raw PDF page 30).
-/

open MeasureTheory

namespace NumStability

/-- A concrete heterogeneous two-cell realization of the source contract.
For the single spatial material field `x ↦ x`, the positive cells `[0, 1]`
and `[1, 2]` receive their genuine normalized Bochner volume averages `1/2`
and `3/2`.  The local-congruence clause states explicitly that changing a
field outside a cell cannot change that cell's assigned average. -/
theorem leveque01_heterogeneousMaterialCellAverage_nonvacuity :
    ∃ (cellLeft cellRight assignedCellProperty : Bool → ℝ),
      cellLeft false = 0 ∧ cellRight false = 1 ∧
      cellLeft true = 1 ∧ cellRight true = 2 ∧
      (∀ cell,
        IsOneDimensionalCellAverage (fun x : ℝ => x)
          (cellLeft cell) (cellRight cell) (assignedCellProperty cell)) ∧
      (∀ (field₁ field₂ : ℝ → ℝ) cell,
        Set.EqOn field₁ field₂ (Set.uIcc (cellLeft cell) (cellRight cell)) →
          oneDimensionalCellAverage field₁ (cellLeft cell) (cellRight cell) =
            oneDimensionalCellAverage field₂ (cellLeft cell) (cellRight cell)) ∧
      assignedCellProperty false = (1 : ℝ) / 2 ∧
      assignedCellProperty true = (3 : ℝ) / 2 ∧
      assignedCellProperty false ≠ assignedCellProperty true := by
  refine ⟨(fun cell => if cell then 1 else 0),
    fun cell => if cell then 2 else 1,
    fun cell => if cell then (3 : ℝ) / 2 else (1 : ℝ) / 2,
    rfl, rfl, rfl, rfl, ?_, ?_, rfl, rfl, ?_⟩
  · intro cell
    cases cell
    · change IsOneDimensionalCellAverage (fun x : ℝ => x) 0 1 ((1 : ℝ) / 2)
      refine ⟨by norm_num, intervalIntegral.intervalIntegrable_id, ?_⟩
      (norm_num [oneDimensionalCellAverage]; rfl)
    · change IsOneDimensionalCellAverage (fun x : ℝ => x) 1 2 ((3 : ℝ) / 2)
      refine ⟨by norm_num, intervalIntegral.intervalIntegrable_id, ?_⟩
      (norm_num [oneDimensionalCellAverage]; rfl)
  · intro field₁ field₂ cell hlocal
    unfold oneDimensionalCellAverage
    rw [intervalIntegral.integral_congr hlocal]
  · norm_num

/-- LeVeque's heterogeneous finite-volume assignment with the averaging rule
chosen by the physical model.  The rule is not forced to be arithmetic: its
operational laws require only cell locality and reproduction of constants on
positive finite-volume cells.  Thus arithmetic, harmonic, weighted, tensor,
or other problem-specific rules can be supplied by the model.  Requiring two
model-selected averages to differ makes the resulting heterogeneous material
assignment substantive. -/
theorem leveque01_heterogeneousMaterialCellAverage_sourceContract
    {Model Cell Point Parameter : Type*} [MeasurableSpace Point]
    (grid : FiniteVolumeCellPartition Cell Point)
    (volumeMeasure : Measure Point)
    (averagingRule : CellMaterialAveragingRule
      Model Cell Point Parameter grid.cellRegion)
    (model : Model)
    (materialParameters : Point → Parameter)
    (hpositive : ∀ cell, volumeMeasure (grid.cellRegion cell) ≠ 0)
    (hfinite : ∀ cell, volumeMeasure (grid.cellRegion cell) ≠ ⊤)
    (hdifferentCellAverages : ∃ cell₁ cell₂,
      averagingRule.averageParameter model volumeMeasure cell₁
          materialParameters ≠
        averagingRule.averageParameter model volumeMeasure cell₂
          materialParameters) :
    ∃ assignedCellProperties : Cell →
        CellAveragedMaterialProperty Parameter,
      (∀ cell,
        (assignedCellProperties cell).averagedParameter =
          averagingRule.averageParameter model volumeMeasure cell
            materialParameters) ∧
      (∀ cell alternativeParameters,
        Set.EqOn materialParameters alternativeParameters
            (grid.cellRegion cell) →
          (assignedCellProperties cell).averagedParameter =
            averagingRule.averageParameter model volumeMeasure cell
              alternativeParameters) ∧
      (∀ cell parameter,
        averagingRule.averageParameter model volumeMeasure cell
            (fun _ => parameter) = parameter) ∧
      ∃ cell₁ cell₂,
        assignedCellProperties cell₁ ≠ assignedCellProperties cell₂ := by
  let assignedCellProperties : Cell →
      CellAveragedMaterialProperty Parameter :=
    fun cell => ⟨averagingRule.averageParameter model volumeMeasure cell
      materialParameters⟩
  refine ⟨assignedCellProperties, ?_, ?_, ?_, ?_⟩
  · intro cell
    rfl
  · intro cell alternativeParameters hlocal
    exact averagingRule.local_congr model volumeMeasure cell
      materialParameters alternativeParameters hlocal
  · intro cell parameter
    exact averagingRule.preserves_constants model volumeMeasure cell
      parameter (hpositive cell) (hfinite cell)
  · rcases hdifferentCellAverages with ⟨cell₁, cell₂, havg⟩
    refine ⟨cell₁, cell₂, ?_⟩
    intro hproperty
    apply havg
    simpa [assignedCellProperties] using
      congrArg CellAveragedMaterialProperty.averagedParameter hproperty

/-- A heterogeneous material-parameter field is assigned to a cell by the
same nondegenerate Bochner cell average used for finite-volume states. -/
theorem leveque01_heterogeneousMaterialCellAverage
    {Parameter : Type*} [NormedAddCommGroup Parameter]
    [NormedSpace ℝ Parameter]
    (materialParameter : ℝ → Parameter) {left right : ℝ}
    (hcell : left < right)
    (hintegrable : IntervalIntegrable materialParameter volume left right) :
    IsOneDimensionalCellAverage materialParameter left right
      (oneDimensionalCellAverage materialParameter left right) :=
  oneDimensionalCellAverage_isCellAverage
    materialParameter hcell hintegrable

end NumStability
