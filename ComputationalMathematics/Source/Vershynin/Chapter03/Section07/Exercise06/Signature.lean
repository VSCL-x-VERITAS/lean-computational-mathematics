import ComputationalMathematics.HDP.Tensor.SignedAnalyticFeature

/-! Frozen proof-free signature for Exercise 3.7.6. -/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_7_6__contract_type : Prop :=
  ∀ (n : ℕ) (f : ℝ → ℝ) (a : ℕ → ℝ)
      (hseries : NumStability.HDP.Tensor.GloballyConvergentPowerSeries f a)
      (u v : Fin n → ℝ),
    ⟪NumStability.HDP.Tensor.absolutePowerSeriesFeature f a hseries u,
      NumStability.HDP.Tensor.signedPowerSeriesFeature f a hseries v⟫_ℝ =
        f (∑ i, u i * v i) ∧
      ‖NumStability.HDP.Tensor.absolutePowerSeriesFeature f a hseries u‖ ^ 2 =
        ∑' k, |a k| * (∑ i, u i * u i) ^ k ∧
      ‖NumStability.HDP.Tensor.signedPowerSeriesFeature f a hseries u‖ ^ 2 =
        ∑' k, |a k| * (∑ i, u i * u i) ^ k

end NumStability.HDP.Contract
