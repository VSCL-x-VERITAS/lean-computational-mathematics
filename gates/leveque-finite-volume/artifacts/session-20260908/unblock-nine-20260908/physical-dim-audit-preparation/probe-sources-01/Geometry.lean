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

/- Actual physical partition, measures, all-subinterval reference balance, normal flux hyperbolicity and Cartesian cells/faces/normalization. -/

#print NumStability.FiniteVolumeCellPartition
#print axioms NumStability.FiniteVolumeCellPartition

#print NumStability.cellVolumeAverage
#print axioms NumStability.cellVolumeAverage

#print NumStability.FiniteCoordinate.PhysicalData
#print axioms NumStability.FiniteCoordinate.PhysicalData

#print NumStability.FiniteCoordinate.PhysicalData.cellVolume
#print axioms NumStability.FiniteCoordinate.PhysicalData.cellVolume

#print NumStability.FiniteCoordinate.PhysicalData.cellMean
#print axioms NumStability.FiniteCoordinate.PhysicalData.cellMean

#print NumStability.FiniteCoordinate.PhysicalData.faceFlux
#print axioms NumStability.FiniteCoordinate.PhysicalData.faceFlux

#print NumStability.FiniteCoordinate.PhysicalData.ReferenceOn
#print axioms NumStability.FiniteCoordinate.PhysicalData.ReferenceOn

#print NumStability.IsHyperbolicFluxAt
#print axioms NumStability.IsHyperbolicFluxAt

#print NumStability.IsHyperbolicFluxOn
#print axioms NumStability.IsHyperbolicFluxOn

#print NumStability.FiniteCartesian.CartesianIdentification
#print axioms NumStability.FiniteCartesian.CartesianIdentification

#print NumStability.FiniteCartesian.cells
#print axioms NumStability.FiniteCartesian.cells

#print NumStability.FiniteCartesian.faceMeasure
#print axioms NumStability.FiniteCartesian.faceMeasure

#print NumStability.FiniteCartesian.data
#print axioms NumStability.FiniteCartesian.data

#print NumStability.OneDimensionalFiniteVolumeGrid
#print axioms NumStability.OneDimensionalFiniteVolumeGrid

#print NumStability.OneDimensionalFiniteVolumeGrid.cellVolume
#print axioms NumStability.OneDimensionalFiniteVolumeGrid.cellVolume

#print NumStability.CartesianGrid.cellBox
#print axioms NumStability.CartesianGrid.cellBox

#print NumStability.CartesianGrid.cellVolume
#print axioms NumStability.CartesianGrid.cellVolume

#print NumStability.CartesianGrid.faceArea
#print axioms NumStability.CartesianGrid.faceArea

#print NumStability.CartesianGrid.tangentialFaceBox
#print axioms NumStability.CartesianGrid.tangentialFaceBox

#print NumStability.CartesianGrid.facePoint
#print axioms NumStability.CartesianGrid.facePoint

#check @NumStability.isHyperbolicFluxAt_iff_independent_real_eigenvectors
#print axioms NumStability.isHyperbolicFluxAt_iff_independent_real_eigenvectors

#check @NumStability.isHyperbolicFluxOn_iff_independent_real_eigenvectors
#print axioms NumStability.isHyperbolicFluxOn_iff_independent_real_eigenvectors

#check @NumStability.FiniteCartesian.CartesianIdentification.cellVolume_eq
#print axioms NumStability.FiniteCartesian.CartesianIdentification.cellVolume_eq

#check @NumStability.FiniteCartesian.CartesianIdentification.cellMean_eq
#print axioms NumStability.FiniteCartesian.CartesianIdentification.cellMean_eq

#check @NumStability.FiniteCartesian.CartesianIdentification.faceFlux_lift
#print axioms NumStability.FiniteCartesian.CartesianIdentification.faceFlux_lift

#check @NumStability.FiniteCartesian.CartesianIdentification.rectangle_balance_lift
#print axioms NumStability.FiniteCartesian.CartesianIdentification.rectangle_balance_lift

#check @NumStability.FiniteCartesian.data_face_measure
#print axioms NumStability.FiniteCartesian.data_face_measure

#check @NumStability.FiniteCartesian.data_normal_flux
#print axioms NumStability.FiniteCartesian.data_normal_flux

#check @NumStability.CartesianGrid.cellBox_volume
#print axioms NumStability.CartesianGrid.cellBox_volume

#check @NumStability.CartesianGrid.tangentialFaceBox_volume
#print axioms NumStability.CartesianGrid.tangentialFaceBox_volume

#check @MeasureTheory.volume_pi
#print axioms MeasureTheory.volume_pi

#check @MeasureTheory.Measure.pi_pi
#print axioms MeasureTheory.Measure.pi_pi

#check @Real.volume_Ico
#print axioms Real.volume_Ico

#check @Real.volume_pi_Ico_toReal
#print axioms Real.volume_pi_Ico_toReal

#check @MeasureTheory.Measure.map_apply_of_aemeasurable
#print axioms MeasureTheory.Measure.map_apply_of_aemeasurable

#check @MeasureTheory.integral_map
#print axioms MeasureTheory.integral_map
