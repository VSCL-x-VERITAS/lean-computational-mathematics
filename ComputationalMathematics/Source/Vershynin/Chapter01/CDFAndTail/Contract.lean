import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# Chapter 1 CDF and tail contract

Stable source-facing aliases for the distribution, cumulative distribution,
and upper-tail definitions used in Chapter 1.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Chapter 1's distribution, CDF, and upper-tail interface. -/
noncomputable def hdp_01_hdef_hcdf_htail
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    NumStability.HDP.Scalar.Preliminaries.CDFTailModelData μ X :=
  NumStability.HDP.Scalar.Preliminaries.cdfTailModel μ X

end NumStability.HDP.Contract
