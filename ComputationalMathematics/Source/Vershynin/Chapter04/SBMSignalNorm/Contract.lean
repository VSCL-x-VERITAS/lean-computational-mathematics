import ComputationalMathematics.HDP.Graph.StochasticBlock

/-!
# Vershynin Chapter 4, stochastic-block signal norm
-/

open scoped Matrix.Norms.L2Operator

namespace NumStability.HDP.Contract

/-- For two nonempty equal communities and `0 ≤ q < p`, the expected
adjacency signal has operator norm equal to the leading eigenvalue.  Dividing
by the total number `2k` of vertices gives the exact fixed-parameter linear
growth asserted in the chapter. -/
theorem hdp_04_sbm_signal_norm {k : ℕ} (hk : 0 < k)
    {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    ‖NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k p q‖ =
        ((p + q) / 2) * ((2 * k : ℕ) : ℝ) ∧
      ‖NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k p q‖ /
          ((2 * k : ℕ) : ℝ) = (p + q) / 2 ∧
      (∀ i j : NumStability.HDP.Graph.StochasticBlock.Vertex k,
        |NumStability.HDP.Graph.StochasticBlock.communitySign k i| =
          |NumStability.HDP.Graph.StochasticBlock.communitySign k j|) := by
  have hnorm :=
    NumStability.HDP.Graph.StochasticBlock.norm_expectedAdjacency hk hq hpq
  refine ⟨?_, ?_, ?_⟩
  · rw [hnorm]
    push_cast
    ring
  · rw [hnorm]
    have hkR : (0 : ℝ) < k := by exact_mod_cast hk
    push_cast
    field_simp
  · intro i j
    rw [NumStability.HDP.Graph.StochasticBlock.abs_communitySign,
      NumStability.HDP.Graph.StochasticBlock.abs_communitySign]

end NumStability.HDP.Contract
