import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.IsotropicConvexBody.Signature

/-! Source-facing contract for the isotropic convex-body definition in Section 3.3.5. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.5, printed page 55: a convex body is called isotropic when its
normalized-volume coordinate law is centered and isotropic. -/
theorem hdp_03_body_3_3_isotropic_body_def :
    hdp_03_body_3_3_isotropic_body_def__contract_type := by
  intro n K
  exact NumStability.HDP.Convex.isIsotropicConvexBody_iff

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_isotropic_body_def__contract :
    hdp_03_body_3_3_isotropic_body_def__contract_type :=
  hdp_03_body_3_3_isotropic_body_def

end NumStability.HDP.Contract
