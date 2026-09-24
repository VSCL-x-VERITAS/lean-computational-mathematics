import ComputationalMathematics.HDP.Optimization.SemidefiniteProgram

/-! Frozen proof-free signature for the minimization-as-SDP observation. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_5_minimization_sdp__contract_type : Prop :=
  ∀ {n m : ℕ} (P : NumStability.HDP.Optimization.SemidefiniteProgram n m),
    (∀ X, P.negateObjective.Feasible X ↔ P.Feasible X) ∧
    (∀ X, P.negateObjective.value X = -P.value X) ∧
    (∀ X, P.negateObjective.IsMaximizer X ↔ P.IsMinimizer X)

end NumStability.HDP.Contract
