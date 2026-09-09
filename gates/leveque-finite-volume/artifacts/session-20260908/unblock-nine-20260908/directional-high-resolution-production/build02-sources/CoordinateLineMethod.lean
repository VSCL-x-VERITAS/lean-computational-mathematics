/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod

/-!
Actual finite-cell line coordinates, supplied ghost values, physical law linkage and equality with the selected line operator.
-/

namespace NumStability.FiniteCoordinate
open DirectionalLine
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- Actual line coordinates of finite cells, with explicit supplied ghost
values where the finite physical array has no cell. A lookup can neither
broadcast an unrelated cell nor read a different coordinate line. -/
structure LineCoordinates (D Cell Face Line : Type*) where
  cellLine : D → Cell → Line
  cellIndex : D → Cell → ℤ
  faceLine : D → Face → Line
  faceIndex : D → Face → ℤ
  lookup : D → Line → ℤ → Option Cell
  lookup_cell : ∀ d cell, lookup d (cellLine d cell) (cellIndex d cell) = some cell
  lookup_sound : ∀ d line j cell, lookup d line j = some cell →
    cellLine d cell = line ∧ cellIndex d cell = j
  ghost : D → Line → ℤ → (Fin m → ℝ)

def LineCoordinates.extract (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current : Cell → State) (j : ℤ) : State :=
  match coord.lookup d line j with
  | some cell => current cell
  | none => coord.ghost d line j

theorem LineCoordinates.extract_cell (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (current : Cell → State) (cell : Cell) :
    coord.extract d (coord.cellLine d cell) current (coord.cellIndex d cell) = current cell := by
  simp [LineCoordinates.extract, coord.lookup_cell]

theorem LineCoordinates.extract_local (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current other : Cell → State)
    (h : ∀ cell, coord.cellLine d cell = line → current cell = other cell) :
    coord.extract d line current = coord.extract d line other := by
  funext j
  simp only [LineCoordinates.extract]
  split
  next cell he => exact h cell (coord.lookup_sound d line j cell he).1
  next => rfl

/-- The same physical law, measured areas/volumes and actual coordinate maps
underlie the selected one-dimensional family. No total solver or exact
equal-state numerical flux is required. -/
structure LineRealization (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (family : D → Line → LineFamily m) where
  level : D → Line → ℕ
  duration : D → ℝ
  duration_eq : ∀ d line, duration d = (family d line).dt (level d line)
  area : D → Line → ℝ
  area_pos : ∀ d line, 0 < area d line
  left_line : ∀ d cell, coord.faceLine d (data.leftFace d cell) = coord.cellLine d cell
  right_line : ∀ d cell, coord.faceLine d (data.rightFace d cell) = coord.cellLine d cell
  left_index : ∀ d cell, coord.faceIndex d (data.leftFace d cell) = coord.cellIndex d cell
  right_index : ∀ d cell, coord.faceIndex d (data.rightFace d cell) = coord.cellIndex d cell + 1
  active_cell : ∀ d cell, coord.cellIndex d cell ∈
    Finset.Ico ((family d (coord.cellLine d cell)).activeStart (level d (coord.cellLine d cell)))
      ((family d (coord.cellLine d cell)).activeStart (level d (coord.cellLine d cell)) +
        (family d (coord.cellLine d cell)).activeCount (level d (coord.cellLine d cell)))
  volume_eq : ∀ d cell, data.cellVolume cell = area d (coord.cellLine d cell) *
    ((family d (coord.cellLine d cell)).grid (level d (coord.cellLine d cell))).cellVolume
      (coord.cellIndex d cell)
  physical_flux : ∀ d face state,
    Integrable (fun point => data.normalFlux d face point state) (data.faceMeasure d face) ∧
    (∫ point, data.normalFlux d face point state ∂data.faceMeasure d face) =
      area d (coord.faceLine d face) • (family d (coord.faceLine d face)).flux
        (((family d (coord.faceLine d face)).grid (level d (coord.faceLine d face))).cellLeft
          (coord.faceIndex d face)) state
  states_eq : ∀ d line, (family d line).states = data.admissibleStates d

noncomputable def LineRealization.rule
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family)
    (d : D) (_dt : ℝ) (current : Cell → State) (face : Face) : State :=
  realization.area d (coord.faceLine d face) •
    (family d (coord.faceLine d face)).numericalFlux
      (realization.level d (coord.faceLine d face))
      (coord.extract d (coord.faceLine d face) current) (coord.faceIndex d face)

def LineRealization.Admitted
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family) (d : D) (current : Cell → State) : Prop :=
  ∀ cell, (family d (coord.cellLine d cell)).admitted
    (realization.level d (coord.cellLine d cell)) (coord.extract d (coord.cellLine d cell) current)

/-- The executed finite-cell update is exactly the selected one-dimensional
operator on the extracted current line, including its supplied ghost data. -/
theorem LineRealization.advance_eq
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family) (d : D) (current : Cell → State) (cell : Cell) :
    advance data realization.rule d (realization.duration d) current cell =
      (family d (coord.cellLine d cell)).advance (realization.level d (coord.cellLine d cell))
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) := by
  have hactual := advance_mass_balance data realization.rule d (realization.duration d) current cell
  have hline := cellVolume_smul_finiteVolumeCellAverageUpdate
    ((family d (coord.cellLine d cell)).dt (realization.level d (coord.cellLine d cell)))
    (((family d (coord.cellLine d cell)).grid (realization.level d (coord.cellLine d cell))).cellVolume
      (coord.cellIndex d cell))
    ((coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell))
    ((family d (coord.cellLine d cell)).numericalFlux (realization.level d (coord.cellLine d cell))
      (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell + 1) -
     (family d (coord.cellLine d cell)).numericalFlux (realization.level d (coord.cellLine d cell))
      (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell))
    ((((family d (coord.cellLine d cell)).grid (realization.level d (coord.cellLine d cell))).cellVolume_pos
      (coord.cellIndex d cell)).ne')
  have harea := congrArg (fun value => realization.area d (coord.cellLine d cell) • value) hline
  have hm : data.cellVolume cell • advance data realization.rule d (realization.duration d) current cell =
      data.cellVolume cell • (family d (coord.cellLine d cell)).advance
        (realization.level d (coord.cellLine d cell))
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) := by
    rw [hactual]
    simpa only [LineRealization.rule, realization.left_line, realization.right_line,
      realization.left_index, realization.right_index, realization.volume_eq d cell,
      realization.duration_eq d (coord.cellLine d cell), LineFamily.advance,
      riemannFiniteVolumeUpdate, finiteVolumeCellAverageUpdate, smul_sub, smul_smul, mul_comm,
      mul_div_assoc, mul_assoc,
      coord.extract_cell d current cell] using harea.symm
  have hc := congrArg (fun value => (data.cellVolume cell)⁻¹ • value) hm
  simpa only [smul_smul, inv_mul_cancel₀ (data.cellVolume_pos cell).ne', one_smul] using hc


end NumStability.FiniteCoordinate
