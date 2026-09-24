import ComputationalMathematics.Source.Vershynin.Chapter03.Equation31.Signature

/-! Display (3.31): the sine-kernel form of the desired arcsine identity. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_31 : hdp_03_eq_3_31__contract_type := by
  intro n u v _ _
  rw [NumStability.HDP.Tensor.krivineFeature_inner,
    NumStability.HDP.Tensor.krivineBeta_mul_pi_div_two]

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_31__contract : hdp_03_eq_3_31__contract_type :=
  hdp_03_eq_3_31

end NumStability.HDP.Contract
