import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Exercise05B.Signature

/-! Exercise 3.7.5(b): every finite polynomial with nonnegative coefficients is
realized by the inner product of a finite direct sum of tensor powers. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_7_5b : hdp_03_ex_3_7_5b__contract_type := by
  intro n d a ha u v
  exact NumStability.HDP.Tensor.polynomialFeature_inner a ha u v

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_7_5b__contract : hdp_03_ex_3_7_5b__contract_type :=
  hdp_03_ex_3_7_5b

end NumStability.HDP.Contract
