import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for the gauge-facing ψ₂ characterization theorem

This file is intentionally proof-free.  The semantic theorem and stable alias
are checked against this exact proposition by the contract wrapper.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hthm_hpsi2_hnorm_hcharacterizations__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0),
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ∀ {K : ℝ}, 0 < K →
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K →
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
              ENNReal.ofReal (C * K)) ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ((∃ K : ℝ, 0 < K ∧
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) ↔
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < (⊤ : ENNReal)))

end NumStability.HDP.Contract
