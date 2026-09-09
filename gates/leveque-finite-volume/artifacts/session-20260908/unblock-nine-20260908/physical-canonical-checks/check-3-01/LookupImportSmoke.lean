import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates

/-! Only the minimal new lookup owner is imported, exposing five moved and five ghost declarations. Native execution is intentionally pending. -/

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

#check NumStability.FiniteCoordinate.LineCoordinates.withGhost
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost

#check NumStability.FiniteCoordinate.LineCoordinates.withGhost_maps
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost_maps

#check NumStability.FiniteCoordinate.LineCoordinates.withGhost_self
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost_self

#check NumStability.FiniteCoordinate.LineCoordinates.withGhost_withGhost
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost_withGhost

#check NumStability.FiniteCoordinate.LineCoordinates.extract_withGhost_error_le_max
#print axioms NumStability.FiniteCoordinate.LineCoordinates.extract_withGhost_error_le_max

