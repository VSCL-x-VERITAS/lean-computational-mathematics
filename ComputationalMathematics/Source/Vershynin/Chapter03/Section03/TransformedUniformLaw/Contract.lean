import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.TransformedUniformLaw.Signature

/-! Source-facing contract for linear transport of a uniform convex-body law in Section 3.3.5. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.5, printed page 55: an invertible linear image of a random
vector uniform on `K` is uniform on the corresponding linearly transformed
copy of `K`. -/
theorem hdp_03_body_3_3_transformed_uniform_law :
    hdp_03_body_3_3_transformed_uniform_law__contract_type := by
  intro n Ω _ μ X K A hX hA
  exact NumStability.HDP.Convex.HasLaw.matrix_mulVec_uniformConvexBodyMeasure hX.2 A hA

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_transformed_uniform_law__contract :
    hdp_03_body_3_3_transformed_uniform_law__contract_type :=
  hdp_03_body_3_3_transformed_uniform_law

end NumStability.HDP.Contract
