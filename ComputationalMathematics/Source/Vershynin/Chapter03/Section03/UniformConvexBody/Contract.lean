import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.UniformConvexBody.Signature

/-! Source-facing contract for the uniform convex-body law in Section 3.3.5. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.5, printed pages 54–55: `X ∼ Unif(K)` means that `K` is a
convex body and `X` has the probability law given by normalized volume on `K`. -/
theorem hdp_03_body_3_3_uniform_convex_law :
    hdp_03_body_3_3_uniform_convex_law__contract_type := by
  intro Ω _ n μ X K
  exact NumStability.HDP.Convex.hasUniformConvexBodyLaw_iff

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_uniform_convex_law__contract :
    hdp_03_body_3_3_uniform_convex_law__contract_type :=
  hdp_03_body_3_3_uniform_convex_law

end NumStability.HDP.Contract
