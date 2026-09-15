import ComputationalMathematics.HDP.Scalar.IndependentSums.Bennett

/-!
# Frozen contract signature for Theorem 2.9.2

This file is intentionally proof-free.  It records Bennett's one-sided tail
bound with the source's exact centered variables, variance, and transform.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

def hdp_02_hthm_h2_d9_d2__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ},
    0 < K →
      (∀ i, Measurable (X i)) →
      (∀ i, Integrable (X i) μ) →
      (∀ i, ∀ᵐ ω ∂μ, |X i ω - ∫ y, X i y ∂μ| ≤ K) →
      iIndepFun X μ →
      ∀ {t : ℝ}, 0 < t →
        let σ2 := ∑ i, ∫ ω, (X i ω - ∫ y, X i y ∂μ) ^ 2 ∂μ
        (σ2 = 0 →
          μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} = 0) ∧
        (0 < σ2 →
          μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
            Real.exp
              (-(σ2 / K ^ 2) *
                NumStability.HDP.Scalar.IndependentSums.Bennett.bennettTransform
                  (K * t / σ2)))

end NumStability.HDP.Contract
