import ComputationalMathematics.HDP.Optimization.GrothendieckKrivine

/-! Frozen proof-free signature for Krivine's bound in the second proof of
Grothendieck's inequality. -/

namespace NumStability.HDP.Contract

universe u

set_option linter.style.nameCheck false in
def hdp_03_body_3_7_krivine_bound__contract_type : Prop :=
  NumStability.HDP.Optimization.IsGrothendieckConstant.{u}
    NumStability.HDP.Tensor.krivineBeta⁻¹

end NumStability.HDP.Contract
