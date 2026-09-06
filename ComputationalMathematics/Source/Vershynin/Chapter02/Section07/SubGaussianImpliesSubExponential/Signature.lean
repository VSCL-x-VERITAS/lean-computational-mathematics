import ComputationalMathematics.HDP.Scalar.SubGaussianToSubExponential

/-! Frozen contract for the Section 2.7 sub-gaussian-to-sub-exponential claim. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

def hdp_02_hbody_h2_d7_hsg_himplies_hse__contract_type : Prop :=
  ∀ {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
    (∃ i : SubGaussian.SubGaussianPropertyKind,
      i ≠ .linearMGF ∧ ∃ K : Real, 0 < K ∧
        SubGaussian.SubGaussianProperty mu X i K) ->
      ∃ K : Real, 0 < K ∧
        SubExponential.SubExponentialProperty mu X .moment K

end NumStability.HDP.Contract
