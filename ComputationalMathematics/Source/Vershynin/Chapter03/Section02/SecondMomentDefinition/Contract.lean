import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.SecondMomentDefinition.Signature

/-! Source-facing contract for the second-moment matrix definition in Section 3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2, printed page 45: the second-moment matrix is `E[XXᵀ]`. -/
theorem hdp_03_body_3_2_second_moment_def :
    hdp_03_body_3_2_second_moment_def__contract_type := by
  intro n Ω _ μ _ X _
  rfl

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2 second-moment signature. -/
theorem hdp_03_body_3_2_second_moment_def__contract :
    hdp_03_body_3_2_second_moment_def__contract_type :=
  hdp_03_body_3_2_second_moment_def

end NumStability.HDP.Contract
