import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise04.Signature

/-! Exercise 3.3.4: characterization by one-dimensional Gaussian marginals. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- A finite-dimensional real random vector is multivariate Gaussian if and
only if every one-dimensional inner-product marginal is Gaussian. -/
theorem hdp_03_ex_3_3_4 : hdp_03_ex_3_3_4__contract_type := by
  intro n Omega _ mu X hX
  exact NumStability.HDP.Vector.Gaussian.hasGaussianLaw_iff_inner_marginals hX

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_4__contract : hdp_03_ex_3_3_4__contract_type :=
  hdp_03_ex_3_3_4

end NumStability.HDP.Contract
