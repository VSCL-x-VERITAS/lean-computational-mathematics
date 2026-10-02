import ComputationalMathematics.HDP.Graph.StochasticBlock

/-!
# Vershynin Chapter 4, Definition 4.5.1
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Definition 4.5.1: two equal communities and independent
Bernoulli edge coordinates, with probability `p` within communities and `q`
across them. When `p=q`, the product law is the Erdős--Rényi special case. -/
theorem hdp_04_definition_4_5_1 (k : ℕ)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) :
    Fintype.card (NumStability.HDP.Graph.StochasticBlock.Vertex k) = 2 * k ∧
      NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
        Measure.pi (fun e : NumStability.HDP.Graph.StochasticBlock.Edge k ↦
          (PMF.bernoulli
            (NumStability.HDP.Graph.StochasticBlock.edgeProbability θ e)
            (NumStability.HDP.Graph.StochasticBlock.edgeProbability_le_one θ e)).toMeasure) ∧
      (θ.p = θ.q →
        NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
          Measure.pi (fun _ : NumStability.HDP.Graph.StochasticBlock.Edge k ↦
            (PMF.bernoulli θ.p θ.hp).toMeasure)) := by
  exact ⟨by simp, rfl,
    NumStability.HDP.Graph.StochasticBlock.graphMeasure_eq_erdosRenyi_of_p_eq_q k θ⟩

end NumStability.HDP.Contract
