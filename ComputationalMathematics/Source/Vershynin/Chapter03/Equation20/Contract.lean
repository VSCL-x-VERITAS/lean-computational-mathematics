import ComputationalMathematics.Source.Vershynin.Chapter03.Equation20.Signature

/-! Display (3.20): quadratic optimization over finite sign vectors. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_20 : hdp_03_eq_3_20__contract_type := by
  intro n A _
  obtain ⟨x, hx⟩ := NumStability.HDP.Optimization.exists_signQuadraticValue_eq_maximum A
  exact ⟨x, hx, NumStability.HDP.Optimization.signQuadraticValue_le_maximum A⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_20__contract : hdp_03_eq_3_20__contract_type :=
  hdp_03_eq_3_20

end NumStability.HDP.Contract
