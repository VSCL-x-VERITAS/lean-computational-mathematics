import ComputationalMathematics.HDP.Vector.SubGaussianIndependent

/-! Frozen contract signature for Lemma 3.4.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_lem_3_4_2__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} [Nonempty (Fin n)]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : Fin n → Ω → ℝ},
      (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      iIndepFun X μ →
        NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ X ∧
          NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ X ≤
            ENNReal.ofReal
              (C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X)

end NumStability.HDP.Contract
