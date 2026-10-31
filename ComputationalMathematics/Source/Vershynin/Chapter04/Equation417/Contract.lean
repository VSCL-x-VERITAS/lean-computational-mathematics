import ComputationalMathematics.Source.Vershynin.Chapter04.ExpectedAdjacencyDecomposition.Contract

/-!
# Vershynin Chapter 4, Equation (4.17)
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Vershynin, Equation (4.17), together with the inherited source
discrepancy. The two eigenpair equations hold for the printed `p`-filled block
matrix, but that matrix is not the expectation of the loopless adjacency
matrix imported from Definition 3.6.2. -/
theorem hdp_04_equation_4_17 {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (∀ i j : NumStability.HDP.Graph.StochasticBlock.Vertex k,
      ∫ ω, stochasticBlockAdjacency ω i j
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
        looplessExpectedAdjacency k θ.p θ.q i j) ∧
    (∀ i : NumStability.HDP.Graph.StochasticBlock.Vertex k,
      looplessExpectedAdjacency k θ.p θ.q i i ≠
        NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k θ.p θ.q i i) ∧
    (NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.allOnes k) =
      ((((θ.p : ℝ) + θ.q) / 2) * ((2 * k : ℕ) : ℝ)) •
        NumStability.HDP.Graph.StochasticBlock.allOnes k ∧
    (NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.communitySign k) =
      ((((θ.p : ℝ) - θ.q) / 2) * ((2 * k : ℕ) : ℝ)) •
        NumStability.HDP.Graph.StochasticBlock.communitySign k := by
  have hModel := hdp_04_expected_adjacency_decomposition hk θ hpq
  refine ⟨hModel.2.1, hModel.2.2.2.2.1, ?_, ?_⟩
  · rw [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_allOnes]
    congr 1
    push_cast
    ring
  · rw [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_communitySign]
    congr 1
    push_cast
    ring

end NumStability.HDP.Contract
