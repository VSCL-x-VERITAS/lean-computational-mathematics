import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.SphericalLaw.Signature

/-! Source-facing contract for the spherical distribution in Section 3.3.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.1, printed page 50: a spherical random vector in `ℝⁿ` is
uniformly distributed on the Euclidean sphere centered at the origin with
radius `√n`. -/
theorem hdp_03_body_3_3_spherical_law :
    hdp_03_body_3_3_spherical_law__contract_type := by
  intro n Ω _ μ X _
  exact NumStability.HDP.Vector.Spherical.hasSphericalLaw_iff

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_spherical_law__contract :
    hdp_03_body_3_3_spherical_law__contract_type :=
  hdp_03_body_3_3_spherical_law

end NumStability.HDP.Contract
