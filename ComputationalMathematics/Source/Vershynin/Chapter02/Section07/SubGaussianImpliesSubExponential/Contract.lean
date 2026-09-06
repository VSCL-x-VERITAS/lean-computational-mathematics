import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.SubGaussianImpliesSubExponential.Signature

/-! Stable Chapter 2 source contract for the Section 2.7 implication. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

/-- Section 2.7: every variable satisfying one of the four noncentered
sub-gaussian properties is sub-exponential. -/
theorem hdp_02_hbody_h2_d7_hsg_himplies_hse_exact :
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
      (∃ i : SubGaussian.SubGaussianPropertyKind,
        i ≠ .linearMGF ∧ ∃ K : Real, 0 < K ∧
          SubGaussian.SubGaussianProperty mu X i K) ->
        ∃ K : Real, 0 < K ∧
          SubExponential.SubExponentialProperty mu X .moment K :=
  SubGaussian.property_to_subExponentialMoment

theorem hdp_02_hbody_h2_d7_hsg_himplies_hse__contract :
    hdp_02_hbody_h2_d7_hsg_himplies_hse__contract_type :=
  hdp_02_hbody_h2_d7_hsg_himplies_hse_exact

end NumStability.HDP.Contract
