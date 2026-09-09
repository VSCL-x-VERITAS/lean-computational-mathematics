import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod

/-! Artifact-only foundation: ordered lines with actual measured capacities.
No regularity, quality, source-acceptance, or integrated-hyperbolicity claim. -/

namespace PhysicalCapacityBridge
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

structure Incidence (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) : Prop where
  left_line : ∀ d cell, coord.faceLine d (data.leftFace d cell) = coord.cellLine d cell
  right_line : ∀ d cell, coord.faceLine d (data.rightFace d cell) = coord.cellLine d cell
  left_index : ∀ d cell, coord.faceIndex d (data.leftFace d cell) = coord.cellIndex d cell
  right_index : ∀ d cell, coord.faceIndex d (data.rightFace d cell) = coord.cellIndex d cell + 1

noncomputable def capacity (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line) (j : ℤ) : ℝ :=
  match coord.lookup d line j with
  | some cell => data.cellVolume cell
  | none => 1

theorem capacity_pos (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line) (j : ℤ) :
    0 < capacity data coord d line j := by
  unfold capacity
  split
  next cell => exact data.cellVolume_pos cell
  next => norm_num

theorem capacity_cell (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (cell : Cell) :
    capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) = data.cellVolume cell := by
  simp [capacity, coord.lookup_cell]

/-- These are the supplied already-integrated numerical face fluxes. -/
def faceRule (coord : LineCoordinates (m := m) D Cell Face Line)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current : Cell → State) (face : Face) : State :=
  numericalFlux d (coord.faceLine d face) dt
    (coord.extract d (coord.faceLine d face) current) (coord.faceIndex d face)

noncomputable def lineAdvance (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (line : Line) (dt : ℝ) (values : ℤ → State) (j : ℤ) : State :=
  finiteVolumeCellAverageUpdate dt (capacity data coord d line j) (values j)
    (numericalFlux d line dt values (j + 1) - numericalFlux d line dt values j)

/-- This equality is unconditional in the positive physical capacities and
supplied numerical flux: no common-area factorization is assumed. -/
theorem advance_eq (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (incidence : Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    advance data (faceRule coord numericalFlux) d dt current cell =
      lineAdvance data coord numericalFlux d (coord.cellLine d cell) dt
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) := by
  simp only [advance, faceRule, lineAdvance, incidence.left_line, incidence.right_line,
    incidence.left_index, incidence.right_index, capacity_cell, coord.extract_cell]

/-- The projected line entry uses exactly the same measured physical mean. -/
theorem projection_cell (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (q : Point → ℝ → State)
    (d : D) (t : ℝ) (cell : Cell) :
    coord.extract d (coord.cellLine d cell) (fun c => data.cellMean q c t)
      (coord.cellIndex d cell) =
        cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t) := by
  rw [coord.extract_cell]
  rfl

theorem advance_line_local (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (incidence : Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current other : Cell → State) (cell : Cell)
    (h : ∀ c, coord.cellLine d c = coord.cellLine d cell → current c = other c) :
    advance data (faceRule coord numericalFlux) d dt current cell =
      advance data (faceRule coord numericalFlux) d dt other cell := by
  rw [advance_eq data coord incidence, advance_eq data coord incidence,
    coord.extract_local d (coord.cellLine d cell) current other h]

theorem weighted_mass_balance [Fintype Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current : Cell → State) :
    (∑ cell, data.cellVolume cell • advance data (faceRule coord numericalFlux) d dt current cell) =
      (∑ cell, data.cellVolume cell • current cell) - dt •
        ∑ cell, (faceRule coord numericalFlux d dt current (data.rightFace d cell) -
          faceRule coord numericalFlux d dt current (data.leftFace d cell)) :=
  finite_mass_balance data (faceRule coord numericalFlux) d dt current

#print axioms capacity_pos
#print axioms capacity_cell
#print axioms advance_eq
#print axioms projection_cell
#print axioms advance_line_local
#print axioms weighted_mass_balance
end PhysicalCapacityBridge
