import ComputationalMathematics.HDP.Scalar.SubGaussianToSubExponential
import ComputationalMathematics.HDP.Scalar.SubExponentialExamples

/-!
# Frozen contract for Example 2.7.8

The target records the example's four mathematical components: sub-Gaussian
variables, their squares, positive-rate exponential laws (including the three
displayed quantities), and Poisson laws.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

def hdp_02_hexample_h2_d7_d8__contract_type : Prop :=
  (∀ {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
      (∃ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        i ≠ .linearMGF ∧ ∃ K : ℝ, 0 < K ∧
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) →
        ∃ K : ℝ, 0 < K ∧
          NumStability.HDP.Scalar.SubExponential.SubExponentialProperty
            μ X .moment K) ∧
  (∀ {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} {X : Ω → ℝ}, Measurable X →
      (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
          μ (fun ω ↦ X ω ^ 2) < ∞ ↔
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞) ∧
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge
          μ (fun ω ↦ X ω ^ 2) =
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ^ 2) ∧
  (∀ lambda : ℝ, 0 < lambda →
      (∫ x : ℝ, x ∂ProbabilityTheory.expMeasure lambda) = 1 / lambda ∧
      Var[fun x : ℝ ↦ x; ProbabilityTheory.expMeasure lambda] =
        1 / lambda ^ 2 ∧
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge
          (ProbabilityTheory.expMeasure lambda) (fun x : ℝ ↦ x) =
        ENNReal.ofReal (2 / lambda)) ∧
  (∀ rate : ℝ≥0,
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge
          (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
          (fun x : ℝ ↦ x) < ∞)

end NumStability.HDP.Contract
