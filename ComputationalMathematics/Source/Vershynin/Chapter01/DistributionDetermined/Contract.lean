import ComputationalMathematics.HDP.Scalar.Preliminaries
/-! Source-facing contract for uniqueness of a real law from its CDF. -/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Original Chapter 1 forwarding alias for CDF determination. -/
theorem hdp_01_hthm_hcdf_hdetermines_hlaw
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν] :
    (∀ t : ℝ, μ (Set.Iic t) = ν (Set.Iic t)) ↔ μ = ν :=
  NumStability.HDP.Scalar.Preliminaries.cdfDeterminesLaw

/-- Two real probability laws agree exactly when their cumulative distribution
functions agree at every threshold. -/
theorem hdp_01_hclaim_hdistribution_hdetermined_spec
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν] :
    (∀ t : ℝ, μ (Set.Iic t) = ν (Set.Iic t)) ↔ μ = ν :=
  NumStability.HDP.Scalar.Preliminaries.cdfDeterminesLaw

end NumStability.HDP.Contract
