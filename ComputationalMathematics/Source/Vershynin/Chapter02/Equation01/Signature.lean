import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Frozen proof-free signature for Equation (2.1). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

def hdp_02_heq_h2_d1__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool},
    0 < Fintype.card ι →
      (∀ i, Measurable (B i)) →
      iIndepFun B μ →
      (∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) →
      μ.real {ω | ∑ i, bernoulliIndicator (B i ω) ≥
          (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} ≤
        μ.real {ω | |∑ i, bernoulliIndicator (B i ω) -
          (Fintype.card ι : ℝ) / 2| ≥
            (Fintype.card ι : ℝ) / 4} ∧
      μ.real {ω | |∑ i, bernoulliIndicator (B i ω) -
          (Fintype.card ι : ℝ) / 2| ≥
            (Fintype.card ι : ℝ) / 4} ≤
        4 / (Fintype.card ι : ℝ)

end NumStability.HDP.Contract
