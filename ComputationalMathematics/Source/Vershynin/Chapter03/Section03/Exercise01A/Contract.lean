import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise01A.Signature

/-! Source-facing contract for the isotropy assertion in Exercise 3.3.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.3.1, printed page 49: a random vector uniformly distributed
on the Euclidean sphere of radius `√n` is isotropic. -/
theorem hdp_03_ex_3_3_1a : hdp_03_ex_3_3_1a__contract_type := by
  intro n Ω _ μ X hn hX
  exact NumStability.HDP.Vector.Spherical.isIsotropic_of_hasSphericalLaw hn hX

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_1a__contract : hdp_03_ex_3_3_1a__contract_type :=
  hdp_03_ex_3_3_1a

end NumStability.HDP.Contract
