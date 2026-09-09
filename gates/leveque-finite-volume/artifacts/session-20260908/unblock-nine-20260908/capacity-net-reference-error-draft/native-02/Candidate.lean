import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError
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
  next cell _ => exact data.cellVolume_pos cell
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


namespace CapacityNetReferenceError
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The signed difference of the two actual numerical-minus-physical face errors.
Physical means are time averages of the same reference on the selected slab. -/
noncomputable def netFluxDefect (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) (s t : ℝ) (cell : Cell) : State :=
  (rule d (t - s) current (data.leftFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t) -
    (rule d (t - s) current (data.rightFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t)

/-- Extracted physical weighted error balance, before any triangle estimate.
The reference retains all its cell/face integrability, state, and subinterval premises. -/
theorem advance_error_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell) :
    data.cellVolume cell • (advance data rule d (t - s) current cell - data.cellMean q cell t) =
      data.cellVolume cell • (current cell - data.cellMean q cell s) +
        (t - s) • netFluxDefect data rule d current q s t cell := by
  have href' := href.2.2.2 s Set.left_mem_uIcc t Set.right_mem_uIcc
  have hb := href'.2 cell
  rw [intervalIntegral.integral_sub (href'.1 cell).1 (href'.1 cell).2] at hb
  rw [smul_sub] at hb
  rw [← cellWidth_smul_oneDimensionalCellAverage _ hst,
    ← cellWidth_smul_oneDimensionalCellAverage _ hst] at hb
  rw [smul_sub, advance_mass_balance, eq_add_of_sub_eq hb]
  unfold netFluxDefect
  module

/-- Only the norm of the NET face error is bounded. Separate face errors may
be large and cancel; no separate per-face asymptotic order is imposed. -/
theorem advance_error_le_net (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound netDefectBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hnet : ‖netFluxDefect data rule d current q s t cell‖ ≤ netDefectBound) :
    ‖advance data rule d (t - s) current cell - data.cellMean q cell t‖ ≤
      oldBound + (t - s) / data.cellVolume cell * netDefectBound := by
  have hb := advance_error_balance data rule d current q href hst cell
  simpa only [add_zero] using
    (norm_le_of_weighted_error_balance (rightError := (0 : State)) (rightBound := 0)
      (data.cellVolume_pos cell) (sub_nonneg.mpr hst.le)
      (by simpa only [sub_zero] using hb) hold hnet (by simp))

/-- The exact same measured projection, capacity and supplied line flux are
used in the physical balance and extracted active-cell line operator. -/
theorem capacity_line_error_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : PhysicalCapacityBridge.Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell) :
    PhysicalCapacityBridge.capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) •
      (PhysicalCapacityBridge.lineAdvance data coord numericalFlux d (coord.cellLine d cell) (t - s)
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) -
        coord.extract d (coord.cellLine d cell) (fun c => data.cellMean q c t) (coord.cellIndex d cell)) =
      data.cellVolume cell •
        (coord.extract d (coord.cellLine d cell) current (coord.cellIndex d cell) -
          cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x s)) +
        (t - s) • netFluxDefect data (PhysicalCapacityBridge.faceRule coord numericalFlux)
          d current q s t cell := by
  rw [PhysicalCapacityBridge.capacity_cell,
    ← PhysicalCapacityBridge.advance_eq data coord incidence,
    coord.extract_cell, coord.extract_cell]
  exact advance_error_balance data (PhysicalCapacityBridge.faceRule coord numericalFlux)
    d current q href hst cell

theorem capacity_line_error_le_net (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : PhysicalCapacityBridge.Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound netDefectBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hnet : ‖netFluxDefect data (PhysicalCapacityBridge.faceRule coord numericalFlux)
      d current q s t cell‖ ≤ netDefectBound) :
    ‖PhysicalCapacityBridge.lineAdvance data coord numericalFlux d (coord.cellLine d cell) (t - s)
      (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) -
        cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)‖ ≤
      oldBound + (t - s) /
        PhysicalCapacityBridge.capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) *
          netDefectBound := by
  rw [PhysicalCapacityBridge.capacity_cell, ← PhysicalCapacityBridge.advance_eq data coord incidence]
  exact advance_error_le_net data (PhysicalCapacityBridge.faceRule coord numericalFlux)
    d current q href hst cell oldBound netDefectBound hold hnet

/-- A scalar cell with zero exact density and zero physical faces can have
arbitrarily large common numerical bias. Its net defect is 2 and actual error is 1. -/
theorem scalar_nonzero_net_example (bias : ℝ) :
    IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume 0 2 ∧
    IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume 0 1 ∧
    (∀ a b s t : ℝ, (∫ x in a..b, (0 : ℝ)) - (∫ x in a..b, (0 : ℝ)) =
      ∫ τ in s..t, ((0 : ℝ) - 0)) ∧
    ((bias + 2 - 0) - (bias - 0) = 2) ∧
    (finiteVolumeCellAverageUpdate (1 : ℝ) 2 0 (bias - (bias + 2)) = 1) ∧
    (‖finiteVolumeCellAverageUpdate (1 : ℝ) 2 0 (bias - (bias + 2)) - 0‖ =
      (0 : ℝ) + 1 / 2 * 2) ∧
    (0 < ‖finiteVolumeCellAverageUpdate (1 : ℝ) 2 0 (bias - (bias + 2)) - 0‖) := by
  have hnet : bias - (bias + 2) = -2 := by ring
  refine ⟨by simp, by simp, by intros; simp, by ring, ?_, ?_, ?_⟩ <;>
    norm_num [hnet, finiteVolumeCellAverageUpdate]
  rfl

#check netFluxDefect
#print axioms netFluxDefect
#check advance_error_balance
#print axioms advance_error_balance
#check advance_error_le_net
#print axioms advance_error_le_net
#check capacity_line_error_balance
#print axioms capacity_line_error_balance
#check capacity_line_error_le_net
#print axioms capacity_line_error_le_net
#check scalar_nonzero_net_example
#print axioms scalar_nonzero_net_example
end CapacityNetReferenceError
