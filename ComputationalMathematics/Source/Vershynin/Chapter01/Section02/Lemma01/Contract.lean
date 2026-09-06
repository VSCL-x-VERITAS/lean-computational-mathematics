import ComputationalMathematics.HDP.Scalar.Preliminaries
/-!
Stable Chapter 1 forwarding module for Lemma 1.2.1 (the layer-cake identity).

The semantic producer is `layerCakeExpectation`. The checkpoint source-facing wrapper and the compatibility alias exported by current main are both retained.
-/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- The complete nonnegative layer-cake identity: an always-defined extended
identity together with its finite real-expectation specialization. -/
theorem hdp_01_hlem_h1_d2_d1_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω) :
    ((∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < X ω}) ∧
      (∀ hInt : Integrable X μ,
        expectation μ X = ∫ t in Set.Ioi 0, μ.real {ω | t < X ω}) :=
  layerCakeExpectation hX hNonneg

/-- Compatibility alias retained from current main. -/
theorem hdp_01_hlem_h1_d2_d1
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω) :
    ((∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < X ω}) ∧
      (∀ hInt : Integrable X μ,
        NumStability.HDP.Scalar.Preliminaries.expectation μ X =
          ∫ t in Set.Ioi 0, μ.real {ω | t < X ω}) :=
  NumStability.HDP.Scalar.Preliminaries.layerCakeExpectation hX hNonneg

end NumStability.HDP.Contract
