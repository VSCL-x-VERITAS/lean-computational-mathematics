import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Frozen contract signature for the fair-coin count moments

This proof-free signature records the two identities printed at the start of
Section 2.1.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

def hdp_02_hbody_h2_d1_hsn_hmoments__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool},
    0 < Fintype.card ι →
      (∀ i, Measurable (B i)) →
      iIndepFun B μ →
      (∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) →
      (∫ ω, ∑ i, bernoulliIndicator (B i ω) ∂μ) =
          (Fintype.card ι : ℝ) / 2 ∧
        Var[fun ω ↦ ∑ i, bernoulliIndicator (B i ω); μ] =
          (Fintype.card ι : ℝ) / 4

end NumStability.HDP.Contract
