import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen contract signature for standard-normal isotropy in Section 3.3.2. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_normal_isotropic__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ),
      NumStability.HDP.Vector.Gaussian.IsStandardNormal μ X →
        NumStability.HDP.Vector.Isotropy.IsIsotropic μ X

end NumStability.HDP.Contract
