import ComputationalMathematics.HDP.Graph.StochasticBlock

/-!
# Expected adjacency on finite indices

The loopless population matrix is independent of the random edge construction.
Keeping its definition here lets deterministic spectral arguments import it
without the probability and operator-norm development.
-/

namespace NumStability.HDP.Graph.FinStochasticBlock

/-- The expected loopless adjacency matrix for a supplied community map. -/
def expectedAdjacency {n : ℕ} (community : Fin n → Fin 2) (p q : ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  fun i j ↦ if i = j then 0 else if community i = community j then p else q

end NumStability.HDP.Graph.FinStochasticBlock
