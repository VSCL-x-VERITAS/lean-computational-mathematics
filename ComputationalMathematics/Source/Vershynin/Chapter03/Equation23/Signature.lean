import ComputationalMathematics.HDP.Graph.MaxCutSigns

/-! Frozen proof-free signature for display (3.23). -/

namespace NumStability.HDP.Contract

open scoped BigOperators

set_option linter.style.nameCheck false in
def hdp_03_eq_3_23__contract_type : Prop :=
  ∀ {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj]
      (x : NumStability.HDP.Optimization.SignVector n),
    (NumStability.HDP.Graph.cutSize G
        (NumStability.HDP.Graph.positiveVertices x) : ℝ) =
        (1 / 2 : ℝ) * ∑ i, ∑ j,
          (if x i ≠ x j then G.adjMatrix ℝ i j else 0) ∧
      (1 / 2 : ℝ) * ∑ i, ∑ j,
          (if x i ≠ x j then G.adjMatrix ℝ i j else 0) =
        NumStability.HDP.Graph.signCutValue G x ∧
      NumStability.HDP.Graph.signCutValue G x =
        (1 / 4 : ℝ) * ∑ i, ∑ j,
          G.adjMatrix ℝ i j * (1 - (x i).value * (x j).value)

end NumStability.HDP.Contract
