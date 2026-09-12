import Mathlib.Probability.Moments.Basic
import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Frozen contract signature for Corollary 2.8.3

This file is intentionally proof-free.  It records Bernstein's inequality for
averages on the effective domain of its displayed rates and separates the
zero-gauge boundary.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

/-- Effective-domain form of Corollary 2.8.3.  The positive-gauge branch is
the printed inequality.  At zero maximal gauge the average is almost surely
zero, so its deterministic tail is stated without undefined quotients. -/
def hdp_02_hcor_h2_d8_d3_effectiveDomain__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
      (∀ i, Measurable (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      (∀ i, PsiOneGauge μ (X i) < ∞) →
      iIndepFun X μ →
      let K := Finset.univ.sup' hne
        (fun i => (PsiOneGauge μ (X i)).toReal)
      (0 < K → ∀ {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * min (t ^ 2 / K ^ 2) (t / K) *
            (Fintype.card ι : ℝ)))) ∧
      (K = 0 → ∀ {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
          if t = 0 then 2 else 0)

end NumStability.HDP.Contract
