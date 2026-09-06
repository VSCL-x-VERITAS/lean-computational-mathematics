import ComputationalMathematics.HDP.Scalar.Preliminaries
/-! Stable Chapter 1 contract for the indicator expectation in Lemma 1.2.1's proof. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- The expectation of the strict superlevel indicator is its event probability. -/
theorem hdp_01_hlem_h1_d2_d1_hindicator_hexpectation_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) (t : ℝ) :
    expectation μ (indicatorFunction {ω | t < X ω}) =
      μ.real {ω | t < X ω} := by
  exact indicatorExpectation μ {ω | t < X ω}
    (measurableSet_lt measurable_const hX)

end NumStability.HDP.Contract
