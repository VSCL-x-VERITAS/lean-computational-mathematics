/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage

/-!
# LeVeque Chapter 1, material assignment by normalized cell-volume integration

Printed page 8 (raw PDF page 30) permits cellwise material assignment by
appropriate averaging over cell volume. The coordinator selects normalized
integration for this target; the source does not single it out from other
model-dependent material averages. Equal averages of heterogeneous fields are
included, and no physical adequacy theorem for every material model is claimed.
-/

open MeasureTheory

namespace NumStability

/-- Every cellwise integrable material field has a unique normalized assignment
on the supplied finite positive measured cells. The actual assigned values are
local and the operator reproduces constants. Different cells may receive equal
or different values, without an additional heterogeneity hypothesis. -/
theorem leveque01_materialCellVolumeAveraging
    {Cell Point Parameter : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup Parameter] [NormedSpace ℝ Parameter] [CompleteSpace Parameter]
    (grid : FiniteVolumeCellPartition Cell Point) (physicalVolume : Measure Point)
    (materialParameter : Point → Parameter)
    (hpositive : ∀ cell, physicalVolume (grid.cellRegion cell) ≠ 0)
    (hfinite : ∀ cell, physicalVolume (grid.cellRegion cell) ≠ ⊤)
    (hintegrable : ∀ cell, IntegrableOn materialParameter (grid.cellRegion cell) physicalVolume) :
    ∃ assigned : Cell → Parameter,
      (∀ cell, IsCellVolumeAverage physicalVolume (grid.cellRegion cell)
        materialParameter (assigned cell)) ∧
      (∀ other : Cell → Parameter,
        (∀ cell, IsCellVolumeAverage physicalVolume (grid.cellRegion cell)
          materialParameter (other cell)) → other = assigned) ∧
      (∀ cell alternativeParameter,
        Set.EqOn materialParameter alternativeParameter (grid.cellRegion cell) →
          assigned cell = cellVolumeAverage physicalVolume (grid.cellRegion cell)
            alternativeParameter) ∧
      (∀ cell (parameter : Parameter),
        cellVolumeAverage physicalVolume (grid.cellRegion cell) (fun _ => parameter) = parameter) := by
  obtain ⟨assigned, hassigned, hunique⟩ := existsUnique_cellVolumeAssignment
    grid physicalVolume materialParameter hpositive hfinite hintegrable
  refine ⟨assigned, hassigned, hunique, ?_, ?_⟩
  · intro cell alternativeParameter hlocal
    rw [(hassigned cell).2.2.2]
    exact cellVolumeAverage_congr physicalVolume (grid.measurable_cell cell) hlocal
  · intro cell parameter
    exact cellVolumeAverage_const physicalVolume _ (hpositive cell) (hfinite cell) parameter

end NumStability
