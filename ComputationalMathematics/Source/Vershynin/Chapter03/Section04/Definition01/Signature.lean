import ComputationalMathematics.HDP.Vector.SubGaussian

/-! Frozen contract signature for Definition 3.4.1. -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_def_3_4_1__contract_type : Prop :=
  ∀ {n : ℕ} [Nonempty (Fin n)]
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ),
    (NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ X ↔
      ∀ u : Fin n → ℝ,
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
          (NumStability.HDP.Vector.linearMarginal X u)) ∧
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ X =
      ⨆ u : NumStability.HDP.Vector.SubGaussian.UnitDirection n,
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal X u.1)

end NumStability.HDP.Contract
