import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.NormalIsotropic.Signature

/-! Source-facing contract for standard-normal isotropy in Section 3.3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.2, printed page 50: the standard normal distribution is isotropic. -/
theorem hdp_03_body_3_3_normal_isotropic :
    hdp_03_body_3_3_normal_isotropic__contract_type := by
  intro n Ω _ μ _ X hX
  exact NumStability.HDP.Vector.Gaussian.isIsotropic_of_isStandardNormal hX

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.3.2 isotropy signature. -/
theorem hdp_03_body_3_3_normal_isotropic__contract :
    hdp_03_body_3_3_normal_isotropic__contract_type :=
  hdp_03_body_3_3_normal_isotropic

end NumStability.HDP.Contract
