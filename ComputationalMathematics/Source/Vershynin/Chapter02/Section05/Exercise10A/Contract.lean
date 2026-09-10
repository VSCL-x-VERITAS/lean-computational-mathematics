import ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise10A.Signature

/-! Stable source-facing wrapper for Exercise 2.5.10, first claim. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubGaussian

/-- Exercise 2.5.10, first claim: a countable (possibly dependent) family of
sub-Gaussian variables has a logarithmically weighted integrable maximum. -/
theorem hdp_02_hex_h2_d5_d10a :
    hdp_02_hex_h2_d5_d10a__contract_type := by
  refine ⟨logWeightedMaxConstant, logWeightedMaxConstant_pos, ?_⟩
  intro Ω _ μ _ X hX hFinite
  exact expectation_logWeightedAbsSupReal_le_sequencePsiTwoGauge hX hFinite

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d5_d10a__contract :
    hdp_02_hex_h2_d5_d10a__contract_type :=
  hdp_02_hex_h2_d5_d10a

end NumStability.HDP.Contract
