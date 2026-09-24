import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.Definition01.Signature

/-! Source-facing contract for Definition 3.2.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Definition 3.2.1, printed page 46: a random vector is isotropic exactly
when its second-moment matrix is the identity. -/
theorem hdp_03_hdef_h3_d2_d1 :
    hdp_03_hdef_h3_d2_d1__contract_type := by
  intro n Ω _ μ _ X _
  rfl

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Definition 3.2.1 signature. -/
theorem hdp_03_hdef_h3_d2_d1__contract :
    hdp_03_hdef_h3_d2_d1__contract_type :=
  hdp_03_hdef_h3_d2_d1

end NumStability.HDP.Contract
