import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates

/-! The existing estimates import must continue to expose the five moved lookup names and 13 retained realization/execution names. Native execution is intentionally pending. -/

set_option pp.universes true
set_option pp.fullNames true
set_option pp.deepTerms true

#check NumStability.FiniteCoordinate.LineCoordinates
#print axioms NumStability.FiniteCoordinate.LineCoordinates

#check NumStability.FiniteCoordinate.LineCoordinates.extract
#print axioms NumStability.FiniteCoordinate.LineCoordinates.extract

#check NumStability.FiniteCoordinate.LineCoordinates.extract_cell
#print axioms NumStability.FiniteCoordinate.LineCoordinates.extract_cell

#check NumStability.FiniteCoordinate.LineCoordinates.extract_local
#print axioms NumStability.FiniteCoordinate.LineCoordinates.extract_local

#check NumStability.FiniteCoordinate.LineCoordinates.extract_error_le
#print axioms NumStability.FiniteCoordinate.LineCoordinates.extract_error_le

#check NumStability.FiniteCoordinate.LineRealization
#print axioms NumStability.FiniteCoordinate.LineRealization

#check NumStability.FiniteCoordinate.LineRealization.rule
#print axioms NumStability.FiniteCoordinate.LineRealization.rule

#check NumStability.FiniteCoordinate.LineRealization.Admitted
#print axioms NumStability.FiniteCoordinate.LineRealization.Admitted

#check NumStability.FiniteCoordinate.LineRealization.advance_eq
#print axioms NumStability.FiniteCoordinate.LineRealization.advance_eq

#check NumStability.FiniteCoordinate.LineRealization.coordinate_stability
#print axioms NumStability.FiniteCoordinate.LineRealization.coordinate_stability

#check NumStability.FiniteCoordinate.LineRealization.coordinate_local
#print axioms NumStability.FiniteCoordinate.LineRealization.coordinate_local

#check NumStability.FiniteCoordinate.LineRealization.smooth_accuracy
#print axioms NumStability.FiniteCoordinate.LineRealization.smooth_accuracy

#check NumStability.FiniteCoordinate.shared_face_cancels
#print axioms NumStability.FiniteCoordinate.shared_face_cancels

#check NumStability.FiniteCoordinate.coordinateStep
#print axioms NumStability.FiniteCoordinate.coordinateStep

#check NumStability.FiniteCoordinate.coordinateExecution
#print axioms NumStability.FiniteCoordinate.coordinateExecution

#check NumStability.FiniteCoordinate.coordinateExecution_succ
#print axioms NumStability.FiniteCoordinate.coordinateExecution_succ

#check NumStability.FiniteCoordinate.coordinateExecution_ordered
#print axioms NumStability.FiniteCoordinate.coordinateExecution_ordered

#check NumStability.FiniteCoordinate.coordinateExecution_physical_error
#print axioms NumStability.FiniteCoordinate.coordinateExecution_physical_error

