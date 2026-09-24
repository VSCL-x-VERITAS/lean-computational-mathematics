import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.StandardNormal.Signature

/-! Source-facing contract for the standard multivariate normal definition in Section 3.3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.2, printed page 50: a standard normal vector has independent
standard-normal coordinates, equivalently the product standard-Gaussian law. -/
theorem hdp_03_body_3_3_standard_normal_def :
    hdp_03_body_3_3_standard_normal_def__contract_type := by
  intro n Ω _ μ _ X
  exact ⟨Iff.rfl,
    NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw⟩

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.3.2 definition signature. -/
theorem hdp_03_body_3_3_standard_normal_def__contract :
    hdp_03_body_3_3_standard_normal_def__contract_type :=
  hdp_03_body_3_3_standard_normal_def

end NumStability.HDP.Contract
