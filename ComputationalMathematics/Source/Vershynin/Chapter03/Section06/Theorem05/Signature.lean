import ComputationalMathematics.HDP.Graph.GaussianHyperplaneExpectation

/-! Frozen proof-free signature for Theorem 3.6.5. -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_thm_3_6_5__contract_type : Prop :=
  ∀ (n : ℕ) (G : SimpleGraph (Fin n))
    [DecidableRel G.Adj]
    (X : NumStability.HDP.Optimization.UnitVectorFamily n),
    NumStability.HDP.Graph.maxCutSemidefiniteValue (G.adjMatrix ℝ) X =
        NumStability.HDP.Graph.maxCutSemidefiniteOptimalValue
          (G.adjMatrix ℝ) →
    (439 / 500 : ℝ) * (NumStability.HDP.Graph.maxCut G : ℝ) ≤
        (439 / 500 : ℝ) *
          NumStability.HDP.Graph.maxCutSemidefiniteOptimalValue
            (G.adjMatrix ℝ) ∧
      (439 / 500 : ℝ) *
          NumStability.HDP.Graph.maxCutSemidefiniteOptimalValue
            (G.adjMatrix ℝ) ≤
        NumStability.HDP.Graph.gaussianHyperplaneCutExpectation
          (G.adjMatrix ℝ) X

end NumStability.HDP.Contract
