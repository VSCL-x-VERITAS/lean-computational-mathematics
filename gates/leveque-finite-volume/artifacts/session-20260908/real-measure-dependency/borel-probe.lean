import ComputationalMathematics.Source.LeVeque.Chapter01.Equation03TransportSolution
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

open MeasureTheory

#print Real.measurableSpace
#print Real.borelSpace

set_option pp.all true in
#check @Real.volume_eq_stieltjes_id

set_option pp.all true in
#check @Real.volume_Ioc

namespace RealMeasureDependency

/-- The actual selected real measure space carries the Borel sigma algebra. -/
theorem selectedBorel :
    Real.measureSpace.toMeasurableSpace = borel ℝ := rfl

#check selectedBorel
#print axioms selectedBorel

end RealMeasureDependency
