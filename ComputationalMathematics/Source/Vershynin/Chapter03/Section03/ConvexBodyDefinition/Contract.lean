import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.ConvexBodyDefinition.Signature

/-! Source-facing contract for the convex-body definition in Section 3.3.5. -/

namespace NumStability.HDP.Contract

/-- Section 3.3.5, printed page 54: a convex body in `ℝⁿ` is a bounded
convex set with nonempty interior. -/
theorem hdp_03_body_3_3_convex_body_def :
    hdp_03_body_3_3_convex_body_def__contract_type := by
  intro n K
  exact NumStability.HDP.Convex.isConvexBody_iff

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_convex_body_def__contract :
    hdp_03_body_3_3_convex_body_def__contract_type :=
  hdp_03_body_3_3_convex_body_def

end NumStability.HDP.Contract
