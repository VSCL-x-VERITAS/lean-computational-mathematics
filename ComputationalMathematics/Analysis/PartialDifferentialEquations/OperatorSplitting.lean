/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.List.Basic
import Mathlib.Data.Real.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Coordinate-direction finite-volume splitting

This file gives source-independent data for an ordered fractional-step sweep.
The grid carries an actual finite-volume partition whose cells are coordinate
boxes in either physical or logical coordinates. A directional solver acts
on cell averages, and execution records the intermediate state before every
in-turn solve.
-/

namespace NumStability

universe u v

/-- A finite-volume state assigns one cell-average value to every cell. -/
abbrev FiniteVolumeCellState (Cell Value : Type*) := Cell → Value

/-- A finite, nonempty, exhaustive family of coordinate directions together
with a chosen sweep order. The order is data: this structure imposes no
distinguished first direction. -/
structure CoordinateDirectionFamily (Direction : Type*) where
  /-- The exhaustive, duplicate-free coordinate directions in sweep order. -/
  directions : List Direction
  directions_nonempty : directions ≠ []
  directions_nodup : directions.Nodup
  directions_exhaustive : ∀ direction, direction ∈ directions

/-- Coordinate data witnessing the two grid geometries used by dimensional
splitting. In the rectangular case the physical point space itself is the
Cartesian coordinate space. In the logically rectangular case an arbitrary
physical point space is related to that Cartesian space by an invertible
logical-coordinate chart. -/
inductive CoordinateGridGeometry (Point Direction : Type u) where
  | rectangular (physicalPointSpace : Point = (Direction → ℝ))
  | logicallyRectangular (logicalCoordinates : Point ≃ (Direction → ℝ))

/-- The physical or logical coordinate chart carried by a coordinate grid. -/
def CoordinateGridGeometry.coordinates
    {Point Direction : Type u} :
    CoordinateGridGeometry Point Direction → Point ≃ (Direction → ℝ)
  | .rectangular physicalPointSpace => Equiv.cast physicalPointSpace
  | .logicallyRectangular logicalCoordinates => logicalCoordinates

/-- The coordinate box with the supplied lower and upper faces. Half-open
boxes permit adjacent finite-volume cells to be disjoint as sets. -/
def coordinateCellBox
    {Point Direction : Type u}
    (geometry : CoordinateGridGeometry Point Direction)
    (directions : List Direction)
    (lowerFace upperFace : Direction → ℝ) : Set Point :=
  { point | ∀ direction ∈ directions,
      lowerFace direction ≤ geometry.coordinates point direction ∧
        geometry.coordinates point direction < upperFace direction }

/-- A rectangular or logically rectangular finite-volume grid.

Besides a coordinate chart, the structure records a measurable disjoint cell
partition, positive coordinate widths, and the fact that each cell really is
a box in those coordinates. Thus the geometry constructors are not merely
labels. -/
structure CoordinateFiniteVolumeGrid
    (Cell : Type v) (Point Direction : Type u) [MeasurableSpace Point] where
  /-- The measurable finite-volume partition underlying the coordinate grid. -/
  partition : FiniteVolumeCellPartition Cell Point
  /-- The coordinate directions together with their chosen sweep order. -/
  coordinateDirections : CoordinateDirectionFamily Direction
  /-- The rectangular or logically rectangular coordinate chart. -/
  geometry : CoordinateGridGeometry Point Direction
  /-- The lower coordinate face of each cell in each direction. -/
  lowerFace : Cell → Direction → ℝ
  /-- The upper coordinate face of each cell in each direction. -/
  upperFace : Cell → Direction → ℝ
  positive_coordinate_width : ∀ cell direction,
    lowerFace cell direction < upperFace cell direction
  cellRegion_eq_coordinateBox : ∀ cell,
    partition.cellRegion cell =
      coordinateCellBox geometry coordinateDirections.directions
        (lowerFace cell) (upperFace cell)

/-- One one-dimensional high-resolution finite-volume solve, represented by
its action on cell averages at a requested fraction of a full step.

Constant-state preservation is the source-independent consistency law used
here; no flux formula, limiter, adjacency convention, or accuracy order is
chosen. -/
structure OneDimensionalHighResolutionFiniteVolumeSolve
    (Cell Value : Type*) where
  /-- Advance cell averages through the requested fraction of a full step. -/
  advanceCellAverages :
    ℝ → FiniteVolumeCellState Cell Value → FiniteVolumeCellState Cell Value
  preserves_constant_states : ∀ fraction value,
    advanceCellAverages fraction (fun _ => value) = fun _ => value

/-- An admissible fractional solve scheduled in one coordinate direction. -/
structure CoordinateFractionalStep
    (Direction Cell Value : Type*) where
  /-- The coordinate direction advanced by this fractional step. -/
  direction : Direction
  /-- The positive fraction of a full time step to advance. -/
  timeFraction : ℝ
  positive_timeFraction : 0 < timeFraction
  timeFraction_le_one : timeFraction ≤ 1
  /-- The one-dimensional solver applied in the selected direction. -/
  oneDimensionalSolve :
    OneDimensionalHighResolutionFiniteVolumeSolve Cell Value

/-- Apply a fractional step to a finite-volume cell-average state. The
scheduled fraction is an input to the directional solver, rather than inert
metadata. -/
def CoordinateFractionalStep.advance
    {Direction Cell Value : Type*}
    (step : CoordinateFractionalStep Direction Cell Value)
    (state : FiniteVolumeCellState Cell Value) :
    FiniteVolumeCellState Cell Value :=
  step.oneDimensionalSolve.advanceCellAverages step.timeFraction state

/-- A one-dimensional high-resolution finite-volume solver and admissible
fraction chosen for every coordinate direction. -/
structure CoordinateHighResolutionMethod
    (Direction Cell Value : Type*) where
  /-- Select the one-dimensional solver used for each coordinate direction. -/
  solveDirection :
    Direction → OneDimensionalHighResolutionFiniteVolumeSolve Cell Value
  /-- Select the fraction of a full step taken in each direction. -/
  timeFraction : Direction → ℝ
  positive_timeFraction : ∀ direction, 0 < timeFraction direction
  timeFraction_le_one : ∀ direction, timeFraction direction ≤ 1

/-- Package the method data for one direction as a scheduled fractional step. -/
def CoordinateHighResolutionMethod.fractionalStep
    {Direction Cell Value : Type*}
    (method : CoordinateHighResolutionMethod Direction Cell Value)
    (direction : Direction) : CoordinateFractionalStep Direction Cell Value :=
  { direction := direction
    timeFraction := method.timeFraction direction
    positive_timeFraction := method.positive_timeFraction direction
    timeFraction_le_one := method.timeFraction_le_one direction
    oneDimensionalSolve := method.solveDirection direction }

/-- Schedule every coordinate direction once, in the order selected by the
direction family. -/
def coordinateFractionalSchedule
    {Direction Cell Value : Type*}
    (directions : CoordinateDirectionFamily Direction)
    (method : CoordinateHighResolutionMethod Direction Cell Value) :
    List (CoordinateFractionalStep Direction Cell Value) :=
  directions.directions.map method.fractionalStep

/-- Apply update operators from left to right to an initial state. -/
def orderedOperatorSweep {State : Type*}
    (operators : List (State → State)) (state : State) : State :=
  operators.foldl (fun current step => step current) state

/-- Apply coordinate-direction fractional steps sequentially in their listed
order. -/
def coordinateFractionalSweep
    {Direction Cell Value : Type*} :
    List (CoordinateFractionalStep Direction Cell Value) →
      FiniteVolumeCellState Cell Value → FiniteVolumeCellState Cell Value
  | [], state => state
  | step :: steps, state =>
      coordinateFractionalSweep steps (step.advance state)

/-- The state trace produced while applying coordinate-direction fractional
steps in turn. It contains the initial state and one state after each step. -/
def coordinateFractionalTrace
    {Direction Cell Value : Type*} :
    List (CoordinateFractionalStep Direction Cell Value) →
      FiniteVolumeCellState Cell Value →
        List (FiniteVolumeCellState Cell Value)
  | [], state => [state]
  | step :: steps, state =>
      state :: coordinateFractionalTrace steps (step.advance state)

/-- `CoordinateSweepExecution steps initial final trace` states operationally
that the listed steps are executed in turn, with `trace` recording the state
before the first solve and after each solve. -/
inductive CoordinateSweepExecution
    {Direction Cell Value : Type*} :
    List (CoordinateFractionalStep Direction Cell Value) →
      FiniteVolumeCellState Cell Value →
        FiniteVolumeCellState Cell Value →
          List (FiniteVolumeCellState Cell Value) → Prop where
  | nil (state) : CoordinateSweepExecution [] state state [state]
  | cons (step) (steps) (initial final tailTrace)
      (tailExecution : CoordinateSweepExecution steps
        (step.advance initial) final tailTrace) :
      CoordinateSweepExecution (step :: steps) initial final
        (initial :: tailTrace)

/-- The recursive sweep and trace give a certified in-turn execution. -/
theorem coordinateFractionalSweep_executes
    {Direction Cell Value : Type*}
    (steps : List (CoordinateFractionalStep Direction Cell Value))
    (state : FiniteVolumeCellState Cell Value) :
    CoordinateSweepExecution steps state
      (coordinateFractionalSweep steps state)
      (coordinateFractionalTrace steps state) := by
  induction steps generalizing state with
  | nil => exact .nil state
  | cons step steps ih =>
      exact .cons step steps state
        (coordinateFractionalSweep steps (step.advance state))
        (coordinateFractionalTrace steps (step.advance state))
        (ih (state := step.advance state))

/-- An in-turn trace has exactly one more state than scheduled solves. -/
@[simp] theorem coordinateFractionalTrace_length
    {Direction Cell Value : Type*}
    (steps : List (CoordinateFractionalStep Direction Cell Value))
    (state : FiniteVolumeCellState Cell Value) :
    (coordinateFractionalTrace steps state).length = steps.length + 1 := by
  induction steps generalizing state with
  | nil => rfl
  | cons step steps ih =>
      simp only [coordinateFractionalTrace, List.length_cons]
      rw [ih (state := step.advance state)]

@[simp] theorem orderedOperatorSweep_nil {State : Type*} (state : State) :
    orderedOperatorSweep ([] : List (State → State)) state = state :=
  rfl

/-- A two-direction sweep first applies the first operator and then the
second. -/
@[simp] theorem orderedOperatorSweep_two
    {State : Type*} (first second : State → State) (state : State) :
    orderedOperatorSweep [first, second] state = second (first state) :=
  rfl

end NumStability
