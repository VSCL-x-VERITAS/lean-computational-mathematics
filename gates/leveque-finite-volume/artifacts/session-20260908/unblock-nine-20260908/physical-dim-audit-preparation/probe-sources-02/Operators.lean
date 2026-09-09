import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.ZeroFluxCartesianRefinement
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries
import Mathlib.MeasureTheory.Integral.Pi
set_option pp.proofs false
set_option pp.fullNames true
set_option pp.deepTerms true
set_option pp.maxSteps 10000000
set_option pp.universes false
set_option maxRecDepth 4096
set_option maxHeartbeats 1600000

/- Same numerical flux, time-dependent admission, lookup/ghost extraction, capacity update, once-edge variation and sequential error recurrence. -/

#print NumStability.FiniteCoordinate.LineCoordinates
#print axioms NumStability.FiniteCoordinate.LineCoordinates

#print NumStability.FiniteCoordinate.LineCoordinates.extract
#print axioms NumStability.FiniteCoordinate.LineCoordinates.extract

#print NumStability.FiniteCoordinate.LineCoordinates.withGhost
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost

#print NumStability.FiniteCoordinate.PhysicalLine.Incidence
#print axioms NumStability.FiniteCoordinate.PhysicalLine.Incidence

#print NumStability.FiniteCoordinate.PhysicalLine.capacity
#print axioms NumStability.FiniteCoordinate.PhysicalLine.capacity

#print NumStability.FiniteCoordinate.PhysicalLine.faceRule
#print axioms NumStability.FiniteCoordinate.PhysicalLine.faceRule

#print NumStability.FiniteCoordinate.PhysicalLine.lineAdvance
#print axioms NumStability.FiniteCoordinate.PhysicalLine.lineAdvance

#print NumStability.CapacityCoordinate.Method
#print axioms NumStability.CapacityCoordinate.Method

#print NumStability.CapacityCoordinate.Method.rule
#print axioms NumStability.CapacityCoordinate.Method.rule

#print NumStability.CapacityCoordinate.Method.Admitted
#print axioms NumStability.CapacityCoordinate.Method.Admitted

#print NumStability.CapacityCoordinate.Method.StableAt
#print axioms NumStability.CapacityCoordinate.Method.StableAt

#print NumStability.CapacityCoordinate.Method.withGhost
#print axioms NumStability.CapacityCoordinate.Method.withGhost

#print NumStability.CapacityCoordinate.Sweep.step
#print axioms NumStability.CapacityCoordinate.Sweep.step

#print NumStability.CapacityCoordinate.Sweep.run
#print axioms NumStability.CapacityCoordinate.Sweep.run

#print NumStability.FiniteCoordinate.advance
#print axioms NumStability.FiniteCoordinate.advance

#print NumStability.finiteVolumeCellAverageUpdate
#print axioms NumStability.finiteVolumeCellAverageUpdate

#print NumStability.orderedOperatorSweep
#print axioms NumStability.orderedOperatorSweep

#print NumStability.FiniteCoordinate.netFluxDefect
#print axioms NumStability.FiniteCoordinate.netFluxDefect

#print NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation
#print axioms NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation

#print NumStability.SequentialError.execution
#print axioms NumStability.SequentialError.execution

#print NumStability.SequentialError.errorBudget
#print axioms NumStability.SequentialError.errorBudget

#print NumStability.FiniteVolumeCellPartition.mesh
#print axioms NumStability.FiniteVolumeCellPartition.mesh

#check @NumStability.FiniteCoordinate.PhysicalLine.capacity_cell
#print axioms NumStability.FiniteCoordinate.PhysicalLine.capacity_cell

#check @NumStability.FiniteCoordinate.PhysicalLine.projection_cell
#print axioms NumStability.FiniteCoordinate.PhysicalLine.projection_cell

#check @NumStability.CapacityCoordinate.Method.advance_withGhost_eq
#print axioms NumStability.CapacityCoordinate.Method.advance_withGhost_eq

#check @NumStability.CapacityCoordinate.Method.coordinate_stability_withGhost
#print axioms NumStability.CapacityCoordinate.Method.coordinate_stability_withGhost

#check @NumStability.CapacityCoordinate.Sweep.run_physical_error
#print axioms NumStability.CapacityCoordinate.Sweep.run_physical_error

#check @NumStability.FiniteCoordinate.advance_error_le_net
#print axioms NumStability.FiniteCoordinate.advance_error_le_net
