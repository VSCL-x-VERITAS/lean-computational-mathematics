import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.GrothendieckBound288.Signature

/-! The elementary Gaussian proof gives a universal Grothendieck constant at most 288. -/

namespace NumStability.HDP.Contract

universe u

theorem hdp_03_body_3_5_grothendieck_bound_288 :
    hdp_03_body_3_5_grothendieck_bound_288__contract_type.{u} :=
  NumStability.HDP.Optimization.isGrothendieckConstant_288

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_5_grothendieck_bound_288__contract :
    hdp_03_body_3_5_grothendieck_bound_288__contract_type.{u} :=
  hdp_03_body_3_5_grothendieck_bound_288

end NumStability.HDP.Contract
