import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Exercise 5.1.13. -/

noncomputable section

open MeasureTheory
open Set
open scoped ENNReal

namespace NumStability.HDP.Contract

def hdp_05_hex_h5_d1_d13__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Z : Ω → ℝ} {m : ℝ},
    Measurable Z →
    ((1 / 2 : ℝ≥0∞) ≤ Measure.map Z μ (Iic m) ∧
      (1 / 2 : ℝ≥0∞) ≤ Measure.map Z μ (Ici m)) →
    {i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind} →
    {K : ℝ} → 0 < K →
    NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ Z i K →
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      ENNReal.ofReal c *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => Z ω - ∫ x, Z x ∂μ) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Z ω - m) ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Z ω - m) ≤
        ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => Z ω - ∫ x, Z x ∂μ)

end NumStability.HDP.Contract
