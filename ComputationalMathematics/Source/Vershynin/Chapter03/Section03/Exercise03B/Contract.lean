import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise03B.Signature

/-! Exercise 3.3.3(b): sum of independent centered Gaussian variables. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- A finite sum of independent centered Gaussian variables is centered
Gaussian, with variance equal to the sum of the component variances. -/
theorem hdp_03_ex_3_3_3b : hdp_03_ex_3_3_3b__contract_type := by
  intro n Omega _ mu _ X variance hLaw hIndep
  exact
    NumStability.HDP.Scalar.SubGaussian.independentGaussianSumLaw hLaw hIndep

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_3b__contract : hdp_03_ex_3_3_3b__contract_type :=
  hdp_03_ex_3_3_3b

end NumStability.HDP.Contract
