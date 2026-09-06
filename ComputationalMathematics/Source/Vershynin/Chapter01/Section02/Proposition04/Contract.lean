import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Stable Chapter 1 forwarding declaration for Markov's inequality. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

theorem hdp_01_hprop_h1_d2_d4
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ᵐ ω ∂μ, 0 ≤ X ω) (hInt : Integrable X μ)
    {t : ℝ} (ht : 0 < t) :
    (μ.real (X ⁻¹' Set.Ici t) ≤
    NumStability.HDP.Scalar.Preliminaries.expectation μ X / t) ∧
      (μ (X ⁻¹' Set.Ici t) ≤
        (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t) :=
  NumStability.HDP.Scalar.Preliminaries.markovInequality hX hNonneg hInt ht

end NumStability.HDP.Contract
