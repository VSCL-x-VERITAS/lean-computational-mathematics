import ComputationalMathematics.HDP.Scalar.SubGaussianMaxima

/-!
# Frozen contract signature for Exercise 2.5.10, second claim

The source indices `1, …, N` are represented by `Fin N` inside
`prefixAbsSupReal`, and `K = max_i ‖X_i‖_{ψ₂}` remains the supremum of the
exact gauges of the full countable sequence. No independence hypothesis is
imposed.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubGaussian

def hdp_02_hex_h2_d5_d10b__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (Ω : Type*) [MeasurableSpace Ω]
      (μ : Measure Ω) [IsProbabilityMeasure μ]
      (X : ℕ → Ω → ℝ) (N : ℕ),
      (∀ i, Measurable (X i)) →
      sequencePsiTwoGauge μ X < (⊤ : ENNReal) →
      2 ≤ N →
      Integrable (prefixAbsSupReal X N) μ ∧
        NumStability.HDP.Scalar.Preliminaries.expectation μ
            (prefixAbsSupReal X N) ≤
          C * (sequencePsiTwoGauge μ X).toReal *
            Real.sqrt (Real.log (N : ℝ))

end NumStability.HDP.Contract
