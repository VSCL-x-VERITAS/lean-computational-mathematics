import ComputationalMathematics.HDP.Vector.SubGaussianFinite

/-! Frozen proof-free signature for the Section 3.4 finite-support example. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_4_finite_support_subgaussian__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : Fin n → Ω → ℝ},
    (∀ i, Measurable (X i)) →
    (∃ S : Set (Fin n → ℝ), S.Finite ∧
      ∀ᵐ ω ∂μ, (fun i ↦ X i ω) ∈ S) →
    NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ X

end NumStability.HDP.Contract
