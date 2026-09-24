import ComputationalMathematics.HDP.Vector.Bernoulli

/-! Frozen contract signature for symmetric Bernoulli isotropy in Section 3.3.1. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_bernoulli_isotropic__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ),
      NumStability.HDP.Vector.Bernoulli.IsSymmetricBernoulli μ X →
        NumStability.HDP.Vector.Isotropy.IsIsotropic μ X

end NumStability.HDP.Contract
