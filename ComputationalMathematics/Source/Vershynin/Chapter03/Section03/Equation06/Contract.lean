import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Equation06.Signature

/-! Source-facing contract for Equation (3.6). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Equation (3.6), printed page 51: for a standard Gaussian vector `X`,
the expectation of `⟨X,u⟩ ⟨X,v⟩` is `⟨u,v⟩`. -/
theorem hdp_03_eq_3_6 : hdp_03_eq_3_6__contract_type := by
  intro n Ω _ μ _ X u v hX
  exact
    NumStability.HDP.Vector.Gaussian.integral_linearMarginal_mul_linearMarginal_of_isStandardNormal
      hX u v

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_6__contract : hdp_03_eq_3_6__contract_type :=
  hdp_03_eq_3_6

end NumStability.HDP.Contract
