import ComputationalMathematics.HDP.Vector.SubGaussianFinite

/-! Frozen contract signature for Exercise 3.4.3(2). -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_3b__contract_type : Prop :=
  ∀ m : ℕ, 0 < m →
    ∃ (n : ℕ) (μ : Measure ℝ) (X : Fin n → ℝ → ℝ),
      IsProbabilityMeasure μ ∧
      (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) ∧
      NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ X ∧
      0 < (⨆ i, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i)) ∧
      ENNReal.ofReal (m : ℝ) *
          (⨆ i, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i)) ≤
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ X

end NumStability.HDP.Contract
