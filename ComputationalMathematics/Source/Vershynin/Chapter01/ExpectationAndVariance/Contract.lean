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

/-- The book's expectation and variance definitions for a real random
variable.  This literal contract deliberately does not impose a finiteness
convention that the selected source passage does not state. -/
theorem hdp_01_hdef_hexpectation_hvariance_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (_hX : Measurable X) :
    NumStability.HDP.Scalar.Preliminaries.expectation μ X =
        (∫ ω, X ω ∂μ) ∧
      NumStability.HDP.Scalar.Preliminaries.variance μ X =
        ∫ ω, (X ω - ∫ x, X x ∂μ) ^ 2 ∂μ := by
  constructor <;> rfl

end NumStability.HDP.Contract
