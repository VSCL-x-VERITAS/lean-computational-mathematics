import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise03A.Signature

/-! Exercise 3.4.3(1): finite sub-Gaussian coordinates. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Any finite random vector with sub-Gaussian coordinates is sub-Gaussian,
without an independence assumption. -/
theorem hdp_03_ex_3_4_3a : hdp_03_ex_3_4_3a__contract_type := by
  intro Ω _ n _ μ _ X hSub
  exact NumStability.HDP.Vector.SubGaussian.coordinates_vectorSubGaussian hSub

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_3a__contract : hdp_03_ex_3_4_3a__contract_type :=
  hdp_03_ex_3_4_3a

end NumStability.HDP.Contract
