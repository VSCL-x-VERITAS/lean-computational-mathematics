/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Algebra.BigOperators.Module
import Mathlib.Tactic.Module

/-!
# Local numerical fluxes on finite-volume cell partitions

Source-independent infrastructure for conservative finite-volume updates on an
abstract finite collection of cells and oriented interfaces.  Cell states are
genuine normalized volume averages.  An interface flux is computed only from
the averages in the two cells incident to that interface.  No integer or
half-line indexing convention is built in.

The boundary-flux identity below works for every finite collection of cells.
An interface whose two cells are both inside the collection cancels, while an
interface crossing its boundary contributes with the orientation of that
interface.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

/-- A finite-volume partition equipped with oriented interfaces between
distinct cells.  `interfacePoint` identifies where the corresponding physical
conservation-law flux is evaluated; it is required to lie in the modeled
domain. -/
structure FiniteVolumeInterfaceMesh
    (Cell Interface Point : Type*) [MeasurableSpace Point]
    [TopologicalSpace Point]
    extends FiniteVolumeCellPartition Cell Point where
  interfaces_nonempty : Nonempty Interface
  /-- The cell designated as the left side of each oriented interface. -/
  leftCell : Interface → Cell
  /-- The cell designated as the right side of each oriented interface. -/
  rightCell : Interface → Cell
  leftCell_ne_rightCell : ∀ interface,
    leftCell interface ≠ rightCell interface
  /-- The physical point at which each interface is located. -/
  interfacePoint : Interface → Point
  interfacePoint_mem_domain : ∀ interface,
    interfacePoint interface ∈ domain
  interfacePoint_mem_leftCellClosure : ∀ interface,
    interfacePoint interface ∈ closure (cellRegion (leftCell interface))
  interfacePoint_mem_rightCellClosure : ∀ interface,
    interfacePoint interface ∈ closure (cellRegion (rightCell interface))

/-- The normalized integral of a conserved field on each cell of a
finite-volume mesh. -/
noncomputable def finiteVolumeCellAverages
    {Cell Interface Point E : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (μ : Measure Point) (conservedField : Point → E) : Cell → E :=
  fun cell => cellVolumeAverage μ (mesh.cellRegion cell) conservedField

/-- A local interface flux uses precisely the approximate averages in the
oriented left and right cells of that interface. -/
def neighboringCellNumericalFlux
    {Cell Interface Point State Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (localNumericalFlux : State → State → Flux)
    (cellAverages : Cell → State) : Interface → Flux :=
  fun interface => localNumericalFlux
    (cellAverages (mesh.leftCell interface))
    (cellAverages (mesh.rightCell interface))

/-- The correct physical interface flux obtained by applying the flux of a
conservation law to the conserved field at the interface point. -/
def conservationLawInterfaceFlux
    {Cell Interface Point State Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (conservedField : Point → State)
    (physicalConservationFlux : State → Flux) : Interface → Flux :=
  fun interface =>
    physicalConservationFlux (conservedField (mesh.interfacePoint interface))

/-- Net outward numerical flux from one cell.  An oriented interface is
outgoing from its left cell and incoming to its right cell. -/
def finiteVolumeNetOutwardFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cell : Cell) : Flux :=
  ∑ interface : Interface,
    ((if mesh.leftCell interface = cell then interfaceFlux interface else 0) -
      (if mesh.rightCell interface = cell then interfaceFlux interface else 0))

/-- Oriented flux through the boundary of a finite collection of cells.
Interfaces internal to the collection occur once with each sign and hence
cancel. -/
def finiteVolumeBoundaryFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cells : Finset Cell) : Flux :=
  ∑ interface : Interface,
    ((if mesh.leftCell interface ∈ cells then interfaceFlux interface else 0) -
      (if mesh.rightCell interface ∈ cells then interfaceFlux interface else 0))

/-- Summing cellwise net outward flux over any finite cell collection leaves
exactly its oriented boundary flux. -/
theorem sum_finiteVolumeNetOutwardFlux_eq_boundaryFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cells : Finset Cell) :
    ∑ cell ∈ cells, finiteVolumeNetOutwardFlux mesh interfaceFlux cell =
      finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
  classical
  simp only [finiteVolumeNetOutwardFlux, finiteVolumeBoundaryFlux,
    Finset.sum_sub_distrib]
  have hleft :
      (∑ cell ∈ cells, ∑ interface : Interface,
          if mesh.leftCell interface = cell then interfaceFlux interface else 0) =
        ∑ interface : Interface,
          if mesh.leftCell interface ∈ cells then interfaceFlux interface else 0 := by
    calc
      _ = ∑ interface : Interface, ∑ cell ∈ cells,
          if mesh.leftCell interface = cell then interfaceFlux interface else 0 :=
        Finset.sum_comm
      _ = _ := by simp [eq_comm]
  have hright :
      (∑ cell ∈ cells, ∑ interface : Interface,
          if mesh.rightCell interface = cell then interfaceFlux interface else 0) =
        ∑ interface : Interface,
          if mesh.rightCell interface ∈ cells then interfaceFlux interface else 0 := by
    calc
      _ = ∑ interface : Interface, ∑ cell ∈ cells,
          if mesh.rightCell interface = cell then interfaceFlux interface else 0 :=
        Finset.sum_comm
      _ = _ := by simp [eq_comm]
  rw [hleft, hright]

/-- Update one cell average over a time interval from its net outward flux.
The cell volume is an explicit argument so geometry-specific volume choices
remain outside this source-independent operation. -/
noncomputable def finiteVolumeCellAverageUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStep cellVolume : ℝ) (oldAverage netOutwardFlux : E) : E :=
  oldAverage - (timeStep / cellVolume) • netOutwardFlux

/-- Multiplying the average update by a nonzero cell volume recovers the
integral conservative balance for the cell total. -/
theorem cellVolume_smul_finiteVolumeCellAverageUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStep cellVolume : ℝ) (oldAverage netOutwardFlux : E)
    (hcellVolume : cellVolume ≠ 0) :
    cellVolume • finiteVolumeCellAverageUpdate
        timeStep cellVolume oldAverage netOutwardFlux =
      cellVolume • oldAverage - timeStep • netOutwardFlux := by
  have hscale : cellVolume * (timeStep / cellVolume) = timeStep := by
    field_simp
  simp [finiteVolumeCellAverageUpdate, smul_sub, smul_smul, hscale]

/-- Cellwise conservative total balances sum to the corresponding boundary
balance on every finite cell collection. -/
theorem sum_finiteVolumeCellTotalBalance
    {Cell Interface Point E : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup E] [Module ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (cellVolume : Cell → ℝ) (timeStep : ℝ)
    (oldAverage updatedAverage : Cell → E)
    (interfaceFlux : Interface → E)
    (hbalance : ∀ cell,
      cellVolume cell • updatedAverage cell =
        cellVolume cell • oldAverage cell -
          timeStep • finiteVolumeNetOutwardFlux mesh interfaceFlux cell)
    (cells : Finset Cell) :
    ∑ cell ∈ cells, cellVolume cell • updatedAverage cell =
      (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep • finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
  calc
    ∑ cell ∈ cells, cellVolume cell • updatedAverage cell =
        ∑ cell ∈ cells,
          (cellVolume cell • oldAverage cell -
            timeStep • finiteVolumeNetOutwardFlux mesh interfaceFlux cell) := by
      apply Finset.sum_congr rfl
      intro cell hcell
      exact hbalance cell
    _ = (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep •
          (∑ cell ∈ cells,
            finiteVolumeNetOutwardFlux mesh interfaceFlux cell) := by
      simp [Finset.sum_sub_distrib, Finset.smul_sum]
    _ = (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep • finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
      rw [sum_finiteVolumeNetOutwardFlux_eq_boundaryFlux]

end NumStability
