import ComputationalMathematics.Source.Vershynin.Chapter03.Equation29.Signature

/-! Display (3.29): a globally convergent real power series with nonnegative
coefficients represents its function by the corresponding infinite sum. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_29 : hdp_03_eq_3_29__contract_type := by
  intro f a _ h x
  exact h.eq_tsum x

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_29__contract : hdp_03_eq_3_29__contract_type :=
  hdp_03_eq_3_29

end NumStability.HDP.Contract
