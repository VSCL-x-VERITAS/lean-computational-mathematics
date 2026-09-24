import ComputationalMathematics.HDP.Tensor.KrivineFeature

/-! Frozen proof-free signature for display (3.30). -/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_30__contract_type : Prop :=
  ∀ (n : ℕ) (u v : Fin n → ℝ),
    (∑ i, u i * u i) = 1 →
    (∑ i, v i * v i) = 1 →
    2 / Real.pi * Real.arcsin
        ⟪NumStability.HDP.Tensor.krivineLeftFeature u,
          NumStability.HDP.Tensor.krivineRightFeature v⟫_ℝ =
      NumStability.HDP.Tensor.krivineBeta * (∑ i, u i * v i)

end NumStability.HDP.Contract
