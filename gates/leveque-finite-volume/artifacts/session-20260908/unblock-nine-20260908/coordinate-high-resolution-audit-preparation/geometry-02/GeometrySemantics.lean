import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import Mathlib.MeasureTheory.Integral.Pi

set_option pp.maxSteps 1000000
set_option pp.deepTerms true
set_option pp.universes false
set_option pp.proofs false

#print NumStability.OneDimensionalFiniteVolumeGrid
#print NumStability.OneDimensionalFiniteVolumeGrid.cellVolume
#print NumStability.CartesianGrid.cellBox
#print NumStability.CartesianGrid.cellVolume
#print NumStability.CartesianGrid.faceArea
#print NumStability.CartesianGrid.tangentialFaceBox
#print NumStability.CartesianGrid.facePoint
#print NumStability.cellVolumeAverage
#print NumStability.oneDimensionalCellAverage
#check @MeasureTheory.volume_pi
#check @MeasureTheory.Measure.pi_pi
#check @Real.volume_Ico
#check @Real.volume_pi_Ico_toReal
#check @NumStability.CartesianGrid.cellBox_volume
#check @NumStability.CartesianGrid.tangentialFaceBox_volume
#check @MeasureTheory.Measure.map_apply_of_aemeasurable
#check @MeasureTheory.integral_map
#print axioms MeasureTheory.volume_pi
#print axioms MeasureTheory.Measure.pi_pi
#print axioms Real.volume_Ico
#print axioms Real.volume_pi_Ico_toReal
#print axioms NumStability.CartesianGrid.cellBox_volume
#print axioms NumStability.CartesianGrid.tangentialFaceBox_volume
#print axioms MeasureTheory.Measure.map_apply_of_aemeasurable
#print axioms MeasureTheory.integral_map
