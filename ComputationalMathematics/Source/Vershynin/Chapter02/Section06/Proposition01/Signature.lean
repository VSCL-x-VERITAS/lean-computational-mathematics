import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for the finite independent sub-Gaussian sum

This file is intentionally proof-free.  The semantic theorem and stable alias
are checked against this exact proposition by the contract wrapper.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

def hdp_02_hprop_h2_d6_d1__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2),
    ∃ C : ℝ, 1 ≤ C ∧
      NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
          (fun ω => ∑ i, X i ω) .linearMGF
          (Real.sqrt (∑ i, K i ^ 2)) ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => ∑ i, X i ω) ≤
        ENNReal.ofReal (C * Real.sqrt (∑ i, K i ^ 2))

end NumStability.HDP.Contract
