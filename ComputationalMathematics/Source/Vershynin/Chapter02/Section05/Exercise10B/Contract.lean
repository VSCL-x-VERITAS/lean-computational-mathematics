import ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise10B.Signature

/-! Stable source-facing wrapper for Exercise 2.5.10, second claim. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubGaussian

/-- Exercise 2.5.10, second claim: the expected maximum of the first `N`
members of a possibly dependent sub-Gaussian sequence is bounded by its common
scale times `sqrt (log N)`. -/
theorem hdp_02_hex_h2_d5_d10b :
    hdp_02_hex_h2_d5_d10b__contract_type := by
  refine ⟨finiteMaxLogConstant, finiteMaxLogConstant_pos, ?_⟩
  intro Ω _ μ _ X N hX hFinite hN
  exact expectation_prefixAbsSupReal_le_sequencePsiTwoGauge_sqrt_log
    hX hFinite hN

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d5_d10b__contract :
    hdp_02_hex_h2_d5_d10b__contract_type :=
  hdp_02_hex_h2_d5_d10b

end NumStability.HDP.Contract
