import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Proposition02.Signature

/-! Source-facing contract for Proposition 3.3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Proposition 3.3.2, printed page 50: multiplying a standard normal random
vector by a fixed orthogonal matrix preserves its standard normal law. -/
theorem hdp_03_prop_3_3_2 : hdp_03_prop_3_3_2__contract_type := by
  intro n Ω _ μ X U hX
  exact
    NumStability.HDP.Vector.Gaussian.isStandardNormal_mulVec_orthogonalGroup U hX

set_option linter.style.nameCheck false in
theorem hdp_03_prop_3_3_2__contract : hdp_03_prop_3_3_2__contract_type :=
  hdp_03_prop_3_3_2

end NumStability.HDP.Contract
