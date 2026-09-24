import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.KrivineBound.Signature

/-! Krivine's feature construction and the Gaussian sign identity give the
explicit Grothendieck constant `1 / β`. -/

namespace NumStability.HDP.Contract

universe u

theorem hdp_03_body_3_7_krivine_bound :
    hdp_03_body_3_7_krivine_bound__contract_type.{u} :=
  NumStability.HDP.Optimization.isGrothendieckConstant_inv_krivineBeta

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_7_krivine_bound__contract :
    hdp_03_body_3_7_krivine_bound__contract_type.{u} :=
  hdp_03_body_3_7_krivine_bound

end NumStability.HDP.Contract
