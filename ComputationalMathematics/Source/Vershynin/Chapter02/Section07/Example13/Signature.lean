import Mathlib.MeasureTheory.Measure.Typeclasses.Probability
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import ComputationalMathematics.HDP.Scalar.SubExponential

/-! Proof-free type signature for Example 2.7.13. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open scoped ENNReal

def hdp_02_hexample_h2_d7_d13__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ},
    Measurable X →
    NumStability.HDP.Scalar.SubExponential.orliczGauge
        NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction μ X =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ∧
    (NumStability.HDP.Scalar.SubExponential.orliczMember
          NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction μ X ↔
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < (⊤ : ENNReal))

end NumStability.HDP.Contract
