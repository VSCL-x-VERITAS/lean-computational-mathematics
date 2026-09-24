import ComputationalMathematics.HDP.Graph.MaxCutSDPEquivalence
import Mathlib.Combinatorics.SimpleGraph.AdjMatrix

/-! Frozen proof-free signature for the SDP observation following display (3.25). -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_6_maxcut_sdp__contract_type : Prop :=
  ∀ {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj],
    (∀ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      ∃ M : Matrix (Fin n) (Fin n) ℝ,
        NumStability.HDP.Optimization.IsCorrelationMatrix M ∧
          NumStability.HDP.Graph.maxCutSemidefiniteMatrixValue (G.adjMatrix ℝ) M =
            NumStability.HDP.Graph.maxCutSemidefiniteValue (G.adjMatrix ℝ) X) ∧
    ∀ M : Matrix (Fin n) (Fin n) ℝ,
      NumStability.HDP.Optimization.IsCorrelationMatrix M →
        ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
          NumStability.HDP.Graph.maxCutSemidefiniteValue (G.adjMatrix ℝ) X =
            NumStability.HDP.Graph.maxCutSemidefiniteMatrixValue (G.adjMatrix ℝ) M

end NumStability.HDP.Contract
