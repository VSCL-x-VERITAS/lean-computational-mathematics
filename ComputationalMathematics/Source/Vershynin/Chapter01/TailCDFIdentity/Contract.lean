import ComputationalMathematics.HDP.Scalar.Preliminaries
/-! Source-facing contract for the Chapter 1 strict-tail/CDF identity. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- On a probability space, the strict upper tail is one minus the inclusive
CDF at the same threshold. -/
theorem hdp_01_heq_htail_hcdf_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : AEMeasurable X μ) (t : ℝ) :
    upperTail μ X t = 1 - cdf μ X t :=
  upperTail_eq_one_sub_cdf hX t

end NumStability.HDP.Contract
