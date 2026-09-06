import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Frozen proof-free signature for the normalization identity inside (2.2). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

def hdp_02_hbody_h2_d1_hzn_hidentity__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool},
    0 < Fintype.card ι →
      (∀ i, Measurable (B i)) →
      iIndepFun B μ →
      (∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) →
      {ω | ∑ i, bernoulliIndicator (B i ω) ≥
          (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} =
        {ω | (∑ i, bernoulliIndicator (B i ω) -
            (Fintype.card ι : ℝ) / 2) /
              Real.sqrt ((Fintype.card ι : ℝ) / 4) ≥
            Real.sqrt ((Fintype.card ι : ℝ) / 4)}

end NumStability.HDP.Contract
