import ComputationalMathematics.HDP.Optimization.GrothendieckConstant

/-! Frozen proof-free signature for the first proof of Theorem 3.5.1. -/

namespace NumStability.HDP.Contract

universe u

set_option linter.style.nameCheck false in
def hdp_03_body_3_5_grothendieck_bound_288__contract_type : Prop :=
  NumStability.HDP.Optimization.IsGrothendieckConstant.{u} 288

end NumStability.HDP.Contract
