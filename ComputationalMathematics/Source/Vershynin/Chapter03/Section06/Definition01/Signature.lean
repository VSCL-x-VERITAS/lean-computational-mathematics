import ComputationalMathematics.HDP.Graph.MaxCut

/-! Frozen proof-free signature for Definition 3.6.1. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_def_3_6_1__contract_type : Prop :=
  ∀ {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj],
    (∀ u v, G.Adj u v → G.Adj v u) ∧
    (∀ v, ¬ G.Adj v v) ∧
    (∀ u v, s(u, v) ∈ G.edgeFinset ↔ G.Adj u v) ∧
    ∃ S : Finset V,
      NumStability.HDP.Graph.cutSize G S = NumStability.HDP.Graph.maxCut G ∧
      ∀ T : Finset V,
        NumStability.HDP.Graph.cutSize G T ≤ NumStability.HDP.Graph.maxCut G

end NumStability.HDP.Contract
