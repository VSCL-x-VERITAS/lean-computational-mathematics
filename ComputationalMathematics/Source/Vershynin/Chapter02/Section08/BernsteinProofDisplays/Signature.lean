import Mathlib.Probability.Moments.Basic
import ComputationalMathematics.HDP.Scalar.SubExponential
/-!
# Frozen contract signatures for Bernstein proof displays

This file is intentionally proof-free.  It records equations (2.23) and
(2.24) from the proof of Bernstein's inequality.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

def hdp_02_heq_h2_d23__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ},
    (Finset.univ : Finset ι).Nonempty →
      (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
          (∀ i, PsiOneGauge μ (X i) < ∞) →
            iIndepFun X μ →
              ∀ {lam t : ℝ}, 0 < lam → 0 ≤ t →
                μ {ω | ∑ i, X i ω ≥ t} ≤
                  ENNReal.ofReal (Real.exp (-(lam * t))) *
                    ∏ i, ∫⁻ ω,
                      ENNReal.ofReal (Real.exp (lam * X i ω)) ∂μ

def hdp_02_heq_h2_d24__contract_type : Prop :=
  ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
    ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
      (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, PsiOneGauge μ (X i) < ∞) →
        iIndepFun X μ →
        ∀ {lam : ℝ},
          let K := Finset.univ.sup' hne
            (fun i => (PsiOneGauge μ (X i)).toReal)
          0 < K → |lam| ≤ c / K →
            ∀ i, Integrable (fun ω ↦ Real.exp (lam * X i ω)) μ ∧
              (∫ ω, Real.exp (lam * X i ω) ∂μ) ≤
                Real.exp
                  (C * lam ^ 2 * (PsiOneGauge μ (X i)).toReal ^ 2)

end NumStability.HDP.Contract
