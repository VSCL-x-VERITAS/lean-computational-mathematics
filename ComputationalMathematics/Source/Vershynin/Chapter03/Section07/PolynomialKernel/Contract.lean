import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.PolynomialKernel.Signature

/-! Section 3.7.1: the inhomogeneous polynomial kernel is positive
semidefinite. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_7_polynomial_kernel :
    hdp_03_body_3_7_polynomial_kernel__contract_type := by
  intro n r hr k
  exact NumStability.HDP.Kernel.polynomialKernel_isPositiveSemidefinite r hr.le k

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_7_polynomial_kernel__contract :
    hdp_03_body_3_7_polynomial_kernel__contract_type :=
  hdp_03_body_3_7_polynomial_kernel

end NumStability.HDP.Contract
