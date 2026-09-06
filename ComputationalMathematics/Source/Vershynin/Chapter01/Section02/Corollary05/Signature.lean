import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Frozen proof-free signature for Corollary 1.2.5. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_01_hcor_h1_d2_d5__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hInt : Integrable X μ)
    (hSqInt : Integrable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) μ)
    {t : ℝ} (ht : 0 < t),
    μ.real {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} ≤
      NumStability.HDP.Scalar.Preliminaries.variance μ X / t ^ 2

end NumStability.HDP.Contract
