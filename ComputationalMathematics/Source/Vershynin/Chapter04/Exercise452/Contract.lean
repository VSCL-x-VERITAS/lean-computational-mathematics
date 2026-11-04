import ComputationalMathematics.HDP.Graph.StochasticBlock

/-!
# Vershynin Chapter 4, Exercise 4.5.2
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.5.2: for two nonempty equal communities and
`0 ≤ q < p`, the expected adjacency has rank two, with the all-ones and
signed-community eigenvectors and the eigenvalues displayed in (4.17). -/
theorem hdp_04_exercise_4_5_2 {k : ℕ} (hk : 0 < k)
    {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    (NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k p q).rank = 2 ∧
    (NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k p q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.allOnes k) =
      (((p + q) / 2) * ((2 * k : ℕ) : ℝ)) •
        NumStability.HDP.Graph.StochasticBlock.allOnes k ∧
    (NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k p q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.communitySign k) =
      (((p - q) / 2) * ((2 * k : ℕ) : ℝ)) •
        NumStability.HDP.Graph.StochasticBlock.communitySign k := by
  refine ⟨NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_rank_eq_two hk hq hpq,
    ?_, ?_⟩
  · rw [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_allOnes]
    congr 1
    push_cast
    ring
  · rw [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_communitySign]
    congr 1
    push_cast
    ring

end NumStability.HDP.Contract
