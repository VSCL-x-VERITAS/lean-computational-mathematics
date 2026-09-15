import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Frozen contract signature for Exercise 2.7.10

This file is intentionally proof-free.  It records the source's centering
inequality for the exact `ψ₁` gauge with one absolute constant.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d7_d10__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : Ω → ℝ},
      Measurable X →
        NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X < ∞ →
        NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ
            (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal C *
            NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X

end NumStability.HDP.Contract
