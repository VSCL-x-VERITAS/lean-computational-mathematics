import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Frozen proof-free signature for Lemma 1.2.1. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_01_hlem_h1_d2_d1__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω),
    ((∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < X ω}) ∧
      (∀ hInt : Integrable X μ,
        (∫ ω, X ω ∂μ) =
          ∫ t in Set.Ioi 0, μ.real {ω | t < X ω})

end NumStability.HDP.Contract
