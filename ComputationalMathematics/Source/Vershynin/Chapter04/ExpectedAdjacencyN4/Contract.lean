import ComputationalMathematics.Source.Vershynin.Chapter04.ExpectedAdjacencyDecomposition.Contract

/-!
# Vershynin Chapter 4, four-vertex expected adjacency example
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Source-discrepancy witness for the displayed `n=4` matrix. The printed
matrix has two constant `p` diagonal blocks and two constant `q` off-diagonal
blocks, but its positive diagonal cannot equal the expectation of the loopless
adjacency matrix imported from Definition 3.6.2. -/
theorem hdp_04_expected_adjacency_n4_example
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (∀ i j : NumStability.HDP.Graph.StochasticBlock.Vertex 2,
      ∫ ω, stochasticBlockAdjacency ω i j
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure 2 θ =
        looplessExpectedAdjacency 2 θ.p θ.q i j) ∧
    (∀ a b : Fin 2,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 2 θ.p θ.q
        (0, a) (0, b) = θ.p) ∧
    (∀ a b : Fin 2,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 2 θ.p θ.q
        (1, a) (1, b) = θ.p) ∧
    (∀ a b : Fin 2,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 2 θ.p θ.q
        (0, a) (1, b) = θ.q) ∧
    (∀ a b : Fin 2,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 2 θ.p θ.q
        (1, a) (0, b) = θ.q) ∧
    (∀ i : NumStability.HDP.Graph.StochasticBlock.Vertex 2,
      looplessExpectedAdjacency 2 θ.p θ.q i i ≠
        NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 2 θ.p θ.q i i) := by
  have hModel := hdp_04_expected_adjacency_decomposition (k := 2) (by omega) θ hpq
  refine ⟨hModel.2.1, ?_⟩
  refine ⟨by simp [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency],
    by simp [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency],
    by simp [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency],
    by simp [NumStability.HDP.Graph.StochasticBlock.expectedAdjacency], ?_⟩
  exact hModel.2.2.2.2.1

end NumStability.HDP.Contract
