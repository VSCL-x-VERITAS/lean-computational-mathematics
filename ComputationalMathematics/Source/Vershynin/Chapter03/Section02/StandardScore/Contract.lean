import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.StandardScore.Signature

/-! Source-facing contract for scalar standardization in Section 3.2.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2.2, printed page 46: a positive-variance real random variable
can be translated and dilated to have zero mean and unit variance. -/
theorem hdp_03_body_3_2_standard_score :
    hdp_03_body_3_2_standard_score__contract_type := by
  intro Ω _ μ _ X hX hVar
  exact ⟨rfl,
    NumStability.HDP.Scalar.Standardization.integral_standardScore hX,
    NumStability.HDP.Scalar.Standardization.variance_standardScore hX hVar⟩

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2.2 standard-score signature. -/
theorem hdp_03_body_3_2_standard_score__contract :
    hdp_03_body_3_2_standard_score__contract_type :=
  hdp_03_body_3_2_standard_score

end NumStability.HDP.Contract
