import ComputationalMathematics.Source.LeVeque.Chapter01.Equation03TransportSolution
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

open MeasureTheory

set_option pp.all true in
#print Real.measureSpace

set_option pp.all true in
#print measureSpaceOfInnerProductSpace

set_option pp.all true in
#print MeasureTheory.MeasureSpace.volume

set_option pp.all true in
#check (volume : Measure ℝ)

#print Module.Basis.addHaar
#check Module.Basis.addHaar_def
#print MeasureTheory.Measure.addHaarMeasure
#check MeasureTheory.Measure.addHaarMeasure_self
#check Module.Basis.addHaar_self
#print StieltjesFunction.id
#check StieltjesFunction.measure_Ioc
#check Real.volume_eq_stieltjes_id
#check Real.volume_Icc
#check Real.volume_Ioc
#check Real.volume_real_Icc_of_le
#check Real.volume_real_Ioc_of_le

namespace RealMeasureDependency

/-- This equation exposes the selected instance, rather than re-running a search
as a purported description of its meaning. -/
theorem selectedInstance :
    Real.measureSpace = measureSpaceOfInnerProductSpace (E := ℝ) := rfl

/-- The default real volume is the orthonormal-basis normalized additive Haar measure. -/
theorem selectedVolume :
    (volume : Measure ℝ) = (stdOrthonormalBasis ℝ ℝ).toBasis.addHaar := rfl

/-- Existing equality specialized to the explicitly named real instance. -/
theorem stieltjesIdentity :
    @MeasureTheory.MeasureSpace.volume ℝ Real.measureSpace =
      StieltjesFunction.id.measure := Real.volume_eq_stieltjes_id

/-- Unit normalization by direct use of the existing interval formula. -/
theorem unitInterval :
    (@MeasureTheory.MeasureSpace.volume ℝ Real.measureSpace) (Set.Ioc 0 1) = 1 := by
  simpa using (Real.volume_Ioc (a := 0) (b := 1))

#check selectedInstance
#check selectedVolume
#check stieltjesIdentity
#check unitInterval

end RealMeasureDependency

#print axioms Real.measureSpace
#print axioms measureSpaceOfInnerProductSpace
#print axioms Module.Basis.addHaar_def
#print axioms MeasureTheory.Measure.addHaarMeasure_self
#print axioms Module.Basis.addHaar_self
#print axioms StieltjesFunction.measure_Ioc
#print axioms Real.volume_eq_stieltjes_id
#print axioms Real.volume_Icc
#print axioms Real.volume_Ioc
#print axioms Real.volume_real_Icc_of_le
#print axioms Real.volume_real_Ioc_of_le
#print axioms RealMeasureDependency.selectedInstance
#print axioms RealMeasureDependency.selectedVolume
#print axioms RealMeasureDependency.stieltjesIdentity
#print axioms RealMeasureDependency.unitInterval
