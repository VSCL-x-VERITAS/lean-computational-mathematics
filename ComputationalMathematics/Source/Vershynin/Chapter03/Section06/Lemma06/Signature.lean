import ComputationalMathematics.HDP.Graph.GaussianHyperplaneExpectation

/-! Frozen proof-free signature for Lemma 3.6.6. -/

noncomputable section

open scoped InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_lem_3_6_6__contract_type : Prop :=
  ∀ (n : ℕ) (u v : EuclideanSpace ℝ (Fin n)),
    ‖u‖ = 1 → ‖v‖ = 1 →
      NumStability.HDP.Graph.gaussianHyperplaneSignCorrelation u v =
        2 / Real.pi * Real.arcsin ⟪u, v⟫_ℝ

end NumStability.HDP.Contract
