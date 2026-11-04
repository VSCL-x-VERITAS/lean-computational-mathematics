import ComputationalMathematics.HDP.Graph.StochasticBlock

/-!
# Vershynin Chapter 4, Definition 4.5.1

Normalization, marginal probabilities and finite configuration probabilities
characterize the loopless balanced stochastic-block joint law.
-/

noncomputable section

open MeasureTheory
open scoped NNReal ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Definition 4.5.1: two communities of size `k`, independent
Bernoulli edge choices with probabilities `p` within and `q` across them,
and the equal-parameter Erdős--Rényi specialization. Finite configurations
include the empty configuration with probability one, including `k=0`.
The parameters range over all of `[0,1]²`, with no separation hypothesis. -/
theorem hdp_04_definition_4_5_1 (k : ℕ)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) :
    let probability : NumStability.HDP.Graph.StochasticBlock.Edge k → ℝ≥0 :=
      fun e ↦ if e.1.1.1 = e.1.2.1 then θ.p else θ.q
    let μ := NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ
    Fintype.card (NumStability.HDP.Graph.StochasticBlock.Vertex k) = 2 * k ∧
      μ Set.univ = 1 ∧
      (∀ e : NumStability.HDP.Graph.StochasticBlock.Edge k,
        μ {x | x e = true} = (probability e : ℝ≥0∞)) ∧
      (∀ (S : Finset (NumStability.HDP.Graph.StochasticBlock.Edge k))
        (v : NumStability.HDP.Graph.StochasticBlock.Edge k → Bool),
        μ {x | ∀ e ∈ S, x e = v e} =
          ∏ e ∈ S, if v e then (probability e : ℝ≥0∞)
            else ((1 - probability e : ℝ≥0) : ℝ≥0∞)) ∧
      (θ.p = θ.q →
        ∀ (S : Finset (NumStability.HDP.Graph.StochasticBlock.Edge k))
          (v : NumStability.HDP.Graph.StochasticBlock.Edge k → Bool),
          μ {x | ∀ e ∈ S, x e = v e} =
            ∏ e ∈ S, if v e then (θ.p : ℝ≥0∞)
              else ((1 - θ.p : ℝ≥0) : ℝ≥0∞)) := by
  classical
  dsimp only
  refine ⟨by simp, ?_, ?_, ?_, ?_⟩
  · simp [NumStability.HDP.Graph.StochasticBlock.graphMeasure]
  · intro e
    simpa using
      NumStability.HDP.Graph.StochasticBlock.graphMeasure_finite_configuration
        k θ {e} (fun _ ↦ true)
  · intro S v
    exact NumStability.HDP.Graph.StochasticBlock.graphMeasure_finite_configuration k θ S v
  · intro hpq S v
    simpa [NumStability.HDP.Graph.StochasticBlock.edgeProbability, hpq] using
      NumStability.HDP.Graph.StochasticBlock.graphMeasure_finite_configuration k θ S v

end NumStability.HDP.Contract
