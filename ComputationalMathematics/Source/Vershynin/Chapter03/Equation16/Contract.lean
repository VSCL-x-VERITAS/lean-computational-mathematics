import ComputationalMathematics.Source.Vershynin.Chapter03.Equation16.Signature

/-! Display (3.16): expectation of a finite bilinear sum is the corresponding
sum of real `L²` inner products. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_16 : hdp_03_eq_3_16__contract_type := by
  intro Ω _ μ m n A U V
  exact NumStability.HDP.Optimization.integral_bilinear_sum_eq_sum_l2_inner A U V

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_16__contract : hdp_03_eq_3_16__contract_type :=
  hdp_03_eq_3_16

end NumStability.HDP.Contract
