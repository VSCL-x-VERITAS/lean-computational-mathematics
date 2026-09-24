import ComputationalMathematics.HDP.Vector.SubGaussianFinite

/-! Frozen contract signature for Exercise 3.4.3(1). -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_3a__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} [Nonempty (Fin n)]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ},
    (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ X

end NumStability.HDP.Contract
