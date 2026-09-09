/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds

/-!
All-subinterval physical reference balance and the resulting local finite-volume error estimate.
-/

open MeasureTheory
open scoped BigOperators
namespace NumStability.FiniteCoordinate
variable {D Cell Face Point FacePoint : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
/-- Every subinterval has an actual physical integral balance. All regularity
and trace premises are restricted to active cells and their incident faces. -/
def PhysicalData.ReferenceOn (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (s t : ℝ) : Prop :=
  (∀ cell, ∀ τ ∈ Set.uIcc s t, IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure) ∧
  (∀ cell, ∀ τ ∈ Set.uIcc s t,
    Integrable (fun point => data.normalFlux d (data.leftFace d cell) point
      (q (data.facePoint d (data.leftFace d cell) point) τ)) (data.faceMeasure d (data.leftFace d cell)) ∧
    Integrable (fun point => data.normalFlux d (data.rightFace d cell) point
      (q (data.facePoint d (data.rightFace d cell) point) τ)) (data.faceMeasure d (data.rightFace d cell))) ∧
  (∀ x ∈ data.cells.domain, ∀ τ ∈ Set.uIcc s t, q x τ ∈ data.admissibleStates d) ∧
  ∀ u ∈ Set.uIcc s t, ∀ v ∈ Set.uIcc s t,
    (∀ cell, IntervalIntegrable (data.faceFlux d q (data.leftFace d cell)) volume u v ∧
      IntervalIntegrable (data.faceFlux d q (data.rightFace d cell)) volume u v) ∧
    ∀ cell, data.cellVolume cell • (data.cellMean q cell v - data.cellMean q cell u) =
      ∫ τ in u..v, data.faceFlux d q (data.leftFace d cell) τ - data.faceFlux d q (data.rightFace d cell) τ

/-- An auxiliary local estimate uses independent physical averages and flux
histories; it is not the high-resolution class or a stand-in for that class. -/
theorem advance_error_le (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound leftBound rightBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hleft : ‖rule d (t - s) current (data.leftFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t‖ ≤ leftBound)
    (hright : ‖rule d (t - s) current (data.rightFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t‖ ≤ rightBound) :
    ‖advance data rule d (t - s) current cell - data.cellMean q cell t‖ ≤
      oldBound + (t - s) / data.cellVolume cell * (leftBound + rightBound) := by
  have href' := href.2.2.2 s Set.left_mem_uIcc t Set.right_mem_uIcc
  have hb := href'.2 cell
  rw [intervalIntegral.integral_sub (href'.1 cell).1 (href'.1 cell).2] at hb
  rw [smul_sub] at hb
  rw [← cellWidth_smul_oneDimensionalCellAverage _ hst,
    ← cellWidth_smul_oneDimensionalCellAverage _ hst] at hb
  have he : data.cellVolume cell • (advance data rule d (t - s) current cell - data.cellMean q cell t) =
      data.cellVolume cell • (current cell - data.cellMean q cell s) +
      (t - s) • ((rule d (t - s) current (data.leftFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t) -
        (rule d (t - s) current (data.rightFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t)) := by
    rw [smul_sub, advance_mass_balance, eq_add_of_sub_eq hb]
    module
  exact norm_le_of_weighted_error_balance (data.cellVolume_pos cell) (sub_nonneg.mpr hst.le)
    he hold hleft hright

end NumStability.FiniteCoordinate
