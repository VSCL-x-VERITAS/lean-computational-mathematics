import Mathlib.Combinatorics.SimpleGraph.AdjMatrix
import Mathlib.Data.Real.Basic

/-! Frozen proof-free signature for Definition 3.6.2. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_def_3_6_2__contract_type : Prop :=
  ∀ {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj],
    (G.adjMatrix ℝ).IsSymm ∧
    ∀ i j, G.adjMatrix ℝ i j = if G.Adj i j then 1 else 0

end NumStability.HDP.Contract
