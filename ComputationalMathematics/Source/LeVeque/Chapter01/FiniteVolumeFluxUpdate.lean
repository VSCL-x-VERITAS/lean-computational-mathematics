/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance

/-!
# LeVeque Chapter 1, finite-volume flux update

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27).  Cell averages are modified over a positive
time interval using interface fluxes computed locally from the available
neighboring approximate cell averages.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

/-- LeVeque's Chapter 1 finite-volume update on an abstract mesh.

The old states are normalized integrals on measurable, positive, finite-volume
cells.  Each numerical interface flux receives only the two neighboring cell
averages.  It is required to lie within a positive tolerance of the physical
conservation-law flux at that interface; exact equality is not assumed.  The
positive time interval and measured cell volumes determine the cell-total
balance.  Summing over any finite cell collection cancels every internal
interface and leaves its oriented boundary flux, without fixing an integer,
half-line, or uniform-grid convention. -/
theorem leveque01_finiteVolumeFluxUpdate_sourceContract
    {Cell Interface Point E : Type*}
    [MeasurableSpace Point] [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (μ : Measure Point) (conservedField : Point → E)
    (physicalConservationFlux : E → E)
    (localNumericalFlux : E → E → E)
    (timeStart timeEnd fluxTolerance : ℝ)
    (hTimeInterval : timeStart < timeEnd)
    (hFluxTolerance : 0 < fluxTolerance)
    (hPositiveCellVolume : ∀ cell, μ (mesh.cellRegion cell) ≠ 0)
    (hFiniteCellVolume : ∀ cell, μ (mesh.cellRegion cell) ≠ ⊤)
    (hIntegrable : ∀ cell,
      IntegrableOn conservedField (mesh.cellRegion cell) μ)
    (hFluxApproximation : ∀ interface,
      dist
          (neighboringCellNumericalFlux mesh localNumericalFlux
            (finiteVolumeCellAverages mesh μ conservedField) interface)
          (conservationLawInterfaceFlux mesh conservedField
            physicalConservationFlux interface) <
        fluxTolerance) :
    0 < timeEnd - timeStart ∧
      0 < fluxTolerance ∧
      (∀ cell,
        IsCellVolumeAverage μ (mesh.cellRegion cell) conservedField
          (finiteVolumeCellAverages mesh μ conservedField cell)) ∧
      (∀ interface,
        neighboringCellNumericalFlux mesh localNumericalFlux
            (finiteVolumeCellAverages mesh μ conservedField) interface =
          localNumericalFlux
            (finiteVolumeCellAverages mesh μ conservedField
              (mesh.leftCell interface))
            (finiteVolumeCellAverages mesh μ conservedField
              (mesh.rightCell interface)) ∧
        dist
            (neighboringCellNumericalFlux mesh localNumericalFlux
              (finiteVolumeCellAverages mesh μ conservedField) interface)
            (conservationLawInterfaceFlux mesh conservedField
              physicalConservationFlux interface) <
          fluxTolerance) ∧
      ∃ updatedCellAverages : Cell → E,
        (∀ cell,
          (μ (mesh.cellRegion cell)).toReal • updatedCellAverages cell =
            (μ (mesh.cellRegion cell)).toReal •
                finiteVolumeCellAverages mesh μ conservedField cell -
              (timeEnd - timeStart) •
                finiteVolumeNetOutwardFlux mesh
                  (neighboringCellNumericalFlux mesh localNumericalFlux
                    (finiteVolumeCellAverages mesh μ conservedField)) cell) ∧
        ∀ cells : Finset Cell,
          ∑ cell ∈ cells,
              (μ (mesh.cellRegion cell)).toReal • updatedCellAverages cell =
            (∑ cell ∈ cells,
              (μ (mesh.cellRegion cell)).toReal •
                finiteVolumeCellAverages mesh μ conservedField cell) -
              (timeEnd - timeStart) •
                finiteVolumeBoundaryFlux mesh
                  (neighboringCellNumericalFlux mesh localNumericalFlux
                    (finiteVolumeCellAverages mesh μ conservedField)) cells := by
  let cellAverages : Cell → E :=
    finiteVolumeCellAverages mesh μ conservedField
  let numericalInterfaceFlux : Interface → E :=
    neighboringCellNumericalFlux mesh localNumericalFlux cellAverages
  let timeStep : ℝ := timeEnd - timeStart
  let cellVolume : Cell → ℝ :=
    fun cell => (μ (mesh.cellRegion cell)).toReal
  let updatedCellAverages : Cell → E := fun cell =>
    finiteVolumeCellAverageUpdate timeStep (cellVolume cell)
      (cellAverages cell)
      (finiteVolumeNetOutwardFlux mesh numericalInterfaceFlux cell)
  have hCellVolume : ∀ cell, cellVolume cell ≠ 0 := by
    intro cell
    exact ne_of_gt
      (ENNReal.toReal_pos
        (hPositiveCellVolume cell) (hFiniteCellVolume cell))
  have hCellBalance : ∀ cell,
      cellVolume cell • updatedCellAverages cell =
        cellVolume cell • cellAverages cell -
          timeStep • finiteVolumeNetOutwardFlux
            mesh numericalInterfaceFlux cell := by
    intro cell
    exact cellVolume_smul_finiteVolumeCellAverageUpdate
      timeStep (cellVolume cell) (cellAverages cell)
        (finiteVolumeNetOutwardFlux mesh numericalInterfaceFlux cell)
        (hCellVolume cell)
  refine ⟨sub_pos.mpr hTimeInterval, hFluxTolerance, ?_, ?_,
    updatedCellAverages, ?_, ?_⟩
  · intro cell
    exact cellVolumeAverage_isCellVolumeAverage μ (mesh.cellRegion cell)
      conservedField (hPositiveCellVolume cell) (hFiniteCellVolume cell)
        (hIntegrable cell)
  · intro interface
    exact ⟨rfl, hFluxApproximation interface⟩
  · exact hCellBalance
  · intro cells
    exact sum_finiteVolumeCellTotalBalance mesh cellVolume timeStep
      cellAverages updatedCellAverages numericalInterfaceFlux hCellBalance cells

/-! ## Compatibility interface

The following declarations retain the earlier uniform natural-indexed
convenience API.  The source contract above deliberately does not depend on
this specialization.
-/

/-- Compatibility data for the natural-indexed flux-difference API. -/
structure Leveque01FiniteVolumeFluxUpdateData (E : Type*) where
  /-- The old cell-average state indexed by natural-numbered cells. -/
  cellAverages : ℕ → E
  /-- The physical conservation-law flux at each natural-numbered edge. -/
  physicalEdgeFlux : ℕ → E
  /-- Compute an edge flux from the complete natural-indexed cell state. -/
  numericalFluxFromCellAverages : (ℕ → E) → ℕ → E
  /-- The relation certifying that a numerical edge flux approximates its
  physical counterpart. -/
  isPhysicalFluxApproximation : E → E → Prop
  /-- The positive scaling applied to the numerical flux difference. -/
  fluxScale : ℝ
  /-- The cell-average state after the flux-difference update. -/
  updatedCellAverages : ℕ → E

/-- Compatibility predicate for the earlier natural-indexed specialization. -/
def IsLeveque01FiniteVolumeFluxUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (data : Leveque01FiniteVolumeFluxUpdateData E) : Prop :=
  0 < data.fluxScale ∧
    (∀ edge,
      data.isPhysicalFluxApproximation
        (data.numericalFluxFromCellAverages data.cellAverages edge)
        (data.physicalEdgeFlux edge)) ∧
    ∀ i,
      data.updatedCellAverages i =
        conservativeFluxDifferenceUpdate data.fluxScale data.cellAverages
          (data.numericalFluxFromCellAverages data.cellAverages) i

/-- Expanded characterization of the compatibility predicate. -/
theorem leveque01_finiteVolumeFluxUpdate_characterization
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (data : Leveque01FiniteVolumeFluxUpdateData E) :
    IsLeveque01FiniteVolumeFluxUpdate data ↔
      0 < data.fluxScale ∧
        (∀ edge,
          data.isPhysicalFluxApproximation
            (data.numericalFluxFromCellAverages data.cellAverages edge)
            (data.physicalEdgeFlux edge)) ∧
        ∀ i,
          data.updatedCellAverages i =
            conservativeFluxDifferenceUpdate data.fluxScale data.cellAverages
              (data.numericalFluxFromCellAverages data.cellAverages) i :=
  Iff.rfl

/-- A uniform natural-indexed finite-volume step retained for compatibility. -/
noncomputable def leveque01_finiteVolumeFluxUpdate {m : ℕ}
    (timeStepOverCellWidth : ℝ)
    (numericalFlux : (ℕ → (Fin m → ℝ)) → ℕ → (Fin m → ℝ))
    (cellAverages : ℕ → (Fin m → ℝ)) :
    ℕ → (Fin m → ℝ) :=
  fun i => conservativeFluxDifferenceUpdate
    timeStepOverCellWidth cellAverages (numericalFlux cellAverages) i

/-- The compatibility update is the old average minus its scaled flux
difference. -/
theorem leveque01_finiteVolumeFluxUpdate_spec {m : ℕ}
    (timeStepOverCellWidth : ℝ)
    (numericalFlux : (ℕ → (Fin m → ℝ)) → ℕ → (Fin m → ℝ))
    (cellAverages : ℕ → (Fin m → ℝ)) (i : ℕ) :
    leveque01_finiteVolumeFluxUpdate
        timeStepOverCellWidth numericalFlux cellAverages i =
      cellAverages i - timeStepOverCellWidth •
        (numericalFlux cellAverages (i + 1) -
          numericalFlux cellAverages i) :=
  rfl

/-- Interior fluxes cancel over every initial block in the compatibility
specialization. -/
theorem leveque01_finiteVolumeFluxUpdate_finiteConservation {m : ℕ}
    (timeStepOverCellWidth : ℝ)
    (numericalFlux : (ℕ → (Fin m → ℝ)) → ℕ → (Fin m → ℝ))
    (cellAverages : ℕ → (Fin m → ℝ)) (cellCount : ℕ) :
    ∑ i ∈ Finset.range cellCount,
        leveque01_finiteVolumeFluxUpdate
          timeStepOverCellWidth numericalFlux cellAverages i =
      (∑ i ∈ Finset.range cellCount, cellAverages i) -
        timeStepOverCellWidth •
          (numericalFlux cellAverages cellCount -
            numericalFlux cellAverages 0) :=
  sum_conservativeFluxDifferenceUpdate
    timeStepOverCellWidth cellAverages (numericalFlux cellAverages) cellCount

/-- Equal boundary fluxes preserve the total in the compatibility
specialization. -/
theorem leveque01_finiteVolumeFluxUpdate_preservesTotal
    {m : ℕ}
    (timeStepOverCellWidth : ℝ)
    (numericalFlux : (ℕ → (Fin m → ℝ)) → ℕ → (Fin m → ℝ))
    (cellAverages : ℕ → (Fin m → ℝ)) (cellCount : ℕ)
    (hboundary : numericalFlux cellAverages cellCount =
      numericalFlux cellAverages 0) :
    ∑ i ∈ Finset.range cellCount,
        leveque01_finiteVolumeFluxUpdate
          timeStepOverCellWidth numericalFlux cellAverages i =
      ∑ i ∈ Finset.range cellCount, cellAverages i :=
  sum_conservativeFluxDifferenceUpdate_of_boundaryFlux_eq
    timeStepOverCellWidth cellAverages (numericalFlux cellAverages)
      cellCount hboundary

end NumStability
