import ComputationalMathematics.HDP.Scalar.SubGaussianMaxima

/-!
# Frozen contract signature for Exercise 2.5.10, first claim

The infinite maximum is represented as a countable supremum, and the source's
`K = max_i ‖X_i‖_{ψ₂}` is represented by the supremum of the exact gauges.
The explicit finiteness assumption makes the displayed expectation meaningful.
No independence hypothesis is imposed.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubGaussian

def hdp_02_hex_h2_d5_d10a__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (Ω : Type*) [MeasurableSpace Ω]
      (μ : Measure Ω) [IsProbabilityMeasure μ]
      (X : ℕ → Ω → ℝ),
      (∀ i, Measurable (X i)) →
      sequencePsiTwoGauge μ X < (⊤ : ENNReal) →
      (∀ᵐ ω ∂μ, logWeightedAbsSup X ω < (⊤ : ENNReal)) ∧
        Integrable (logWeightedAbsSupReal X) μ ∧
        NumStability.HDP.Scalar.Preliminaries.expectation μ
            (logWeightedAbsSupReal X) ≤
          C * (sequencePsiTwoGauge μ X).toReal

end NumStability.HDP.Contract
