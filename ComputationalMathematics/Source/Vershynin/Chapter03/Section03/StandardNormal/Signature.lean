import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen contract signature for the standard multivariate normal definition in Section 3.3.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_standard_normal_def__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : Fin n → Ω → ℝ),
      (NumStability.HDP.Vector.Gaussian.IsStandardNormal μ X ↔
        HasLaw (fun ω i => X i ω) (NumStability.standardGaussianVectorMeasure n) μ) ∧
      (NumStability.HDP.Vector.Gaussian.IsStandardNormal μ X ↔
        iIndepFun X μ ∧ ∀ i, HasLaw (X i) (gaussianReal 0 1) μ)

end NumStability.HDP.Contract
