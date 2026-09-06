import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Chapter 1 convergence-in-distribution contract

Stable source-facing alias for the convergence-in-distribution definition used
in Chapter 1.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Chapter 1's weak-convergence definition for real random variables. -/
noncomputable def hdp_01_hdef_hconvergence_hin_hdistribution
    {Ω ι : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (l : Filter ι) (Z : Ω → ℝ)
    (hX : ∀ i, AEMeasurable (X i) μ) (hZ : AEMeasurable Z μ) : Prop :=
  NumStability.HDP.Scalar.LimitTheorems.convergenceInDistribution μ X l Z hX hZ

end NumStability.HDP.Contract
