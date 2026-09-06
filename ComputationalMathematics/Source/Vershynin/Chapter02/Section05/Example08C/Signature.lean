import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Example 2.5.8(c). -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

def hdp_02_hexample_h2_d5_d8c__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {B : ℝ}
    (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ B),
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
      ENNReal.ofReal (B / Real.sqrt (Real.log 2))

end NumStability.HDP.Contract
