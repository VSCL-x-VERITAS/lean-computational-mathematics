import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalanceTemporalDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.LinearProduction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Examples.LocalMaterialInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/- Exact native meaning of the ordinary real measure used by the density alternative.
This supplement establishes instance/measure facts, not source scope or acceptance. -/
open MeasureTheory

namespace NumStability.ProspectiveSourceAlternatives.NativeRealMeasure

theorem selectedInstance :
    Real.measureSpace = measureSpaceOfInnerProductSpace (E := ℝ) := rfl

theorem selectedVolume :
    (volume : Measure ℝ) = (stdOrthonormalBasis ℝ ℝ).toBasis.addHaar := rfl

theorem stieltjesIdentity :
    @MeasureTheory.MeasureSpace.volume ℝ Real.measureSpace =
      StieltjesFunction.id.measure := Real.volume_eq_stieltjes_id

theorem unitInterval :
    (@MeasureTheory.MeasureSpace.volume ℝ Real.measureSpace) (Set.Ioc 0 1) = 1 := by
  simp

theorem selectedBorel : Real.measureSpace.toMeasurableSpace = borel ℝ := rfl

#check selectedInstance
#check selectedVolume
#check stieltjesIdentity
#check unitInterval
#check selectedBorel
#print axioms selectedInstance
#print axioms selectedVolume
#print axioms stieltjesIdentity
#print axioms unitInterval
#print axioms selectedBorel

end NumStability.ProspectiveSourceAlternatives.NativeRealMeasure

set_option pp.all true in
#print Real.measureSpace
set_option pp.all true in
#print measureSpaceOfInnerProductSpace
set_option pp.all true in
#print MeasureTheory.MeasureSpace.volume
set_option pp.all true in
#print Real.measurableSpace
set_option pp.all true in
#print Real.borelSpace
set_option pp.all true in
#check (volume : Measure ℝ)
set_option pp.all true in
#print NumStability.IsRectangleBalanceLawSolution
#print Module.Basis.addHaar
#check Module.Basis.addHaar_def
#print MeasureTheory.Measure.addHaarMeasure
#check MeasureTheory.Measure.addHaarMeasure_self
#check Module.Basis.addHaar_self
#print StieltjesFunction.id
#check StieltjesFunction.measure_Ioc
#check Real.volume_eq_stieltjes_id
#check Real.volume_Ioc
#check Real.volume_real_Ioc_of_le
#print axioms Real.volume_eq_stieltjes_id
#print axioms Real.volume_Ioc
#print axioms NumStability.IsRectangleBalanceLawSolution.hasDerivAt_mass_ae
