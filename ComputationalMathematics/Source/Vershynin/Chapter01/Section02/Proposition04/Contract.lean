import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Stable Chapter 1 forwarding declaration for Markov's inequality. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

theorem hdp_01_hprop_h1_d2_d4
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ᵐ ω ∂μ, 0 ≤ X ω)
    {t : ℝ} (ht : 0 < t) :
    μ (X ⁻¹' Set.Ici t) ≤
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t :=
  NumStability.HDP.Scalar.Preliminaries.markovInequalityExtended hX hNonneg ht

end NumStability.HDP.Contract
