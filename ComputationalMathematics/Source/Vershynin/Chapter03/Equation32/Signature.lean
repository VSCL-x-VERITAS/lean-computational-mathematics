import ComputationalMathematics.HDP.Kernel.FeatureMap

/-! Frozen proof-free signature for display (3.32). -/

noncomputable section

open scoped InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_32__contract_type : Prop :=
  ∀ {X H : Type} [NormedAddCommGroup H] [InnerProductSpace ℝ H] [CompleteSpace H]
    (K : X → X → ℝ) (Φ : X → H),
    NumStability.HDP.Kernel.IsRealFeatureMap K Φ ↔
      ∀ u v, ⟪Φ u, Φ v⟫_ℝ = K u v

end NumStability.HDP.Contract
