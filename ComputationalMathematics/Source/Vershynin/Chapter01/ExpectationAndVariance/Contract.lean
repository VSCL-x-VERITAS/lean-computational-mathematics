import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
Cross-split stable API for `HDP-01-DEF-EXPECTATION-VARIANCE`.

The semantic producer owns the Bochner-integral definitions and centered
variable lemma; this leaf forwards the integrable probability-space model.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing expectation/variance data for an integrable variable. -/
noncomputable def hdp_01_hdef_hexpectation_hvariance
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Integrable X μ) :
    NumStability.HDP.Scalar.Preliminaries.ExpectationVarianceModelData μ X hX :=
  NumStability.HDP.Scalar.Preliminaries.expectationVarianceModel μ X hX

end NumStability.HDP.Contract
