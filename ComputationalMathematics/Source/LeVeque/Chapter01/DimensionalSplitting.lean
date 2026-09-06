/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting

/-!
# LeVeque Chapter 1, dimensional splitting

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 6 (raw PDF page 28).
-/

namespace NumStability

universe u

/-- LeVeque's dimensional-splitting construction on a rectangular or
logically rectangular finite-volume grid.

The finite exhaustive direction list selects an arbitrary sweep order. The
one-dimensional high-resolution method supplies a positive fraction no larger
than one and a cell-average solve for every direction. The conclusion
constructs the resulting nonempty schedule, proves every coordinate direction
occurs with exactly its method data, and exposes the full in-turn execution
trace. No direction order, numerical fraction, flux formula, or neighboring
qualitative claim is fixed. -/
theorem leveque01_dimensionalSplitting_sourceContract
    {Cell Value : Type*} {Point Direction : Type u} [MeasurableSpace Point]
    (grid : CoordinateFiniteVolumeGrid Cell Point Direction)
    (method : CoordinateHighResolutionMethod Direction Cell Value)
    (initialState : FiniteVolumeCellState Cell Value) :
    ∃ schedule finalState trace,
      schedule =
        coordinateFractionalSchedule grid.coordinateDirections method ∧
      schedule ≠ [] ∧
      (∀ direction,
        ∃ step ∈ schedule,
          step.direction = direction ∧
          step.timeFraction = method.timeFraction direction ∧
          step.oneDimensionalSolve = method.solveDirection direction) ∧
      CoordinateSweepExecution schedule initialState finalState trace ∧
      trace.length = schedule.length + 1 := by
  let schedule :=
    coordinateFractionalSchedule grid.coordinateDirections method
  let finalState := coordinateFractionalSweep schedule initialState
  let trace := coordinateFractionalTrace schedule initialState
  refine ⟨schedule, finalState, trace, rfl, ?_, ?_, ?_, ?_⟩
  · intro hschedule
    have hdirections : grid.coordinateDirections.directions = [] := by
      simpa [schedule, coordinateFractionalSchedule] using hschedule
    exact grid.coordinateDirections.directions_nonempty hdirections
  · intro direction
    refine ⟨method.fractionalStep direction, ?_, rfl, rfl, rfl⟩
    exact List.mem_map.mpr
      ⟨direction, grid.coordinateDirections.directions_exhaustive direction,
        rfl⟩
  · exact coordinateFractionalSweep_executes schedule initialState
  · exact coordinateFractionalTrace_length schedule initialState

/-- The operational contract is nonvacuous: an admissible two-direction
schedule produces a three-state certified execution trace. The choice of
directions and half-step fractions is only an example, not part of the general
source contract. -/
theorem leveque01_dimensionalSplitting_nonvacuity :
    ∃ directions : CoordinateDirectionFamily Bool,
      ∃ method : CoordinateHighResolutionMethod Bool Bool ℝ,
        ∃ finalState trace,
          CoordinateSweepExecution
            (coordinateFractionalSchedule directions method)
            (fun cell => if cell then 1 else 0)
            finalState trace ∧
          trace.length = 3 := by
  let directions : CoordinateDirectionFamily Bool :=
    { directions := [false, true]
      directions_nonempty := by simp
      directions_nodup := by simp
      directions_exhaustive := by intro direction; cases direction <;> simp }
  let identitySolve : OneDimensionalHighResolutionFiniteVolumeSolve Bool ℝ :=
    { advanceCellAverages := fun _ state => state
      preserves_constant_states := by intros; rfl }
  let method : CoordinateHighResolutionMethod Bool Bool ℝ :=
    { solveDirection := fun _ => identitySolve
      timeFraction := fun _ => (1 : ℝ) / 2
      positive_timeFraction := by intro; norm_num
      timeFraction_le_one := by intro; norm_num }
  let initialState : FiniteVolumeCellState Bool ℝ :=
    fun cell => if cell then 1 else 0
  let schedule := coordinateFractionalSchedule directions method
  let finalState := coordinateFractionalSweep schedule initialState
  let trace := coordinateFractionalTrace schedule initialState
  refine ⟨directions, method, finalState, trace, ?_, ?_⟩
  · exact coordinateFractionalSweep_executes schedule initialState
  · change (coordinateFractionalTrace schedule initialState).length = 3
    rw [coordinateFractionalTrace_length]
    simp [schedule, directions, coordinateFractionalSchedule]

/-- The legacy two-operator lemma remains available as the simplest concrete
calculation of left-to-right operator composition. -/
theorem leveque01_dimensionalSplitting
    {State : Type*} (xDirectionSolve yDirectionSolve : State → State)
    (state : State) :
    orderedOperatorSweep [xDirectionSolve, yDirectionSolve] state =
      yDirectionSolve (xDirectionSolve state) :=
  orderedOperatorSweep_two xDirectionSolve yDirectionSolve state

end NumStability
