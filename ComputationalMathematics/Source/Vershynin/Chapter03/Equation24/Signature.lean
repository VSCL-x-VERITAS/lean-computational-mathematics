import ComputationalMathematics.HDP.Graph.MaxCutSigns

/-! Frozen proof-free signature for display (3.24). -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_24__contract_type : Prop :=
  ∀ {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj],
    (∃ x : NumStability.HDP.Optimization.SignVector n,
        NumStability.HDP.Graph.signCutValue G x =
          (NumStability.HDP.Graph.maxCut G : ℝ)) ∧
      ∀ x : NumStability.HDP.Optimization.SignVector n,
        NumStability.HDP.Graph.signCutValue G x ≤
          (NumStability.HDP.Graph.maxCut G : ℝ)

end NumStability.HDP.Contract
