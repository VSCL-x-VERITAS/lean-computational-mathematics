import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Equation (2.20)

This file is intentionally proof-free.  The stable source alias is checked
against this exact triangle-inequality proposition by the contract wrapper.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_heq_h2_d20__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ},
    NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X →
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (fun ω => X ω - ∫ x, X x ∂μ) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X +
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun _ : Ω => ∫ x, X x ∂μ)

end NumStability.HDP.Contract
