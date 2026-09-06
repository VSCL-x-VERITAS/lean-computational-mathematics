import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Stable Chapter 1 forwarding module for Lemma 1.2.1 (the layer-cake identity).

The semantic producer is `layerCakeExpectation`; this leaf exposes the single
source-facing alias for the numbered row. A second, byte-identical alias
(`hdp_01_hlem_h1_d2_d1`) previously stood alongside the one below with the same
statement and the same proof term; it had no consumer anywhere in the
repository and was removed as a duplicate semantic wrapper, leaving one
canonical producer and one source-facing wrapper.
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

/-- The historical layer-cake theorem retained from main. -/
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
