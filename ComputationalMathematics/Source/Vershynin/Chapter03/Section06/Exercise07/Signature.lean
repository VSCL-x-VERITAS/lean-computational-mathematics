import ComputationalMathematics.HDP.Graph.GaussianHyperplaneExpectation

/-! Frozen proof-free signature for Exercise 3.6.7. -/

noncomputable section

open scoped InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_6_7__contract_type : Prop :=
  ∀ (n : ℕ) (u v : EuclideanSpace ℝ (Fin n)),
    ‖u‖ = 1 → ‖v‖ = 1 →
      NumStability.HDP.Graph.gaussianHyperplaneOppositeProbability u v =
        Real.arccos ⟪u, v⟫_ℝ / Real.pi

end NumStability.HDP.Contract
