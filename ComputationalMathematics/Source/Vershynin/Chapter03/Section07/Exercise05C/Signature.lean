import ComputationalMathematics.HDP.Tensor.AnalyticFeature

/-! Frozen proof-free signature for Exercise 3.7.5(c). -/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_7_5c__contract_type : Prop :=
  ∀ (n : ℕ) (f : ℝ → ℝ) (a : ℕ → ℝ)
      (ha : ∀ k, 0 ≤ a k)
      (hseries : NumStability.HDP.Tensor.GloballyConvergentPowerSeries f a)
      (u v : Fin n → ℝ),
    ⟪NumStability.HDP.Tensor.powerSeriesFeature f a ha hseries u,
      NumStability.HDP.Tensor.powerSeriesFeature f a ha hseries v⟫_ℝ =
      f (∑ i, u i * v i)

end NumStability.HDP.Contract
