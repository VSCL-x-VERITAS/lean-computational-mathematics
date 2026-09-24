import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise09A.Signature

/-! Exercise 3.4.9(a): a linearly scaled `ℓ₁` ball has isotropic normalized
volume. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_4_9a : hdp_03_ex_3_4_9a__contract_type := by
  refine ⟨NumStability.HDP.Vector.L1Ball.isotropicRadius, ?_, ?_⟩
  · intro n hn
    exact NumStability.HDP.Vector.L1Ball.isotropicRadius_linear_bounds hn
  · intro n hn
    exact NumStability.HDP.Vector.L1Ball.uniformMeasure_isIsotropic hn

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_9a__contract : hdp_03_ex_3_4_9a__contract_type :=
  hdp_03_ex_3_4_9a

end NumStability.HDP.Contract
