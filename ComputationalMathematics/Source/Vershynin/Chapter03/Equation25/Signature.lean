import ComputationalMathematics.HDP.Graph.MaxCutSemidefinite
import Mathlib.Combinatorics.SimpleGraph.AdjMatrix

/-! Frozen proof-free signature for display (3.25). -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_25__contract_type : Prop :=
  ∀ {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj],
    ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      NumStability.HDP.Graph.maxCutSemidefiniteValue (G.adjMatrix ℝ) X =
          NumStability.HDP.Graph.maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ∧
        ∀ Y : NumStability.HDP.Optimization.UnitVectorFamily n,
          NumStability.HDP.Graph.maxCutSemidefiniteValue (G.adjMatrix ℝ) Y ≤
            NumStability.HDP.Graph.maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ)

end NumStability.HDP.Contract
