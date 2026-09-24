import ComputationalMathematics.HDP.Graph.RandomCut

/-! Frozen proof-free signature for Proposition 3.6.3. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_prop_3_6_3__contract_type : Prop :=
  ∀ {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj],
    NumStability.HDP.Graph.uniformBoolCutExpectation G =
        (G.edgeFinset.card : ℝ) / 2 ∧
      (NumStability.HDP.Graph.maxCut G : ℝ) / 2 ≤
        NumStability.HDP.Graph.uniformBoolCutExpectation G

end NumStability.HDP.Contract
