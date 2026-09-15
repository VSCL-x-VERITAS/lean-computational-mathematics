import Mathlib.Probability.Moments.Basic

/-!
# Frozen contract signature for Theorem 2.8.4

This file is intentionally proof-free. It records bounded Bernstein on the
effective domain of the displayed quotient and states its zero-denominator
boundary separately.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

/-- Effective-domain form of Theorem 2.8.4. The positive-denominator branch is
the printed bounded Bernstein inequality. At a zero denominator, the summands
are almost surely zero and the exact deterministic tail is stated separately. -/
def hdp_02_hthm_h2_d8_d4_effectiveDomain__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hne : (Finset.univ : Finset ι).Nonempty),
    (∀ i, Measurable (X i)) →
    (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
    (∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K) →
    iIndepFun X μ →
    let σ2 := ∑ i, ∫ ω, X i ω ^ 2 ∂μ
    ∀ {t : ℝ}, 0 ≤ t →
      let D := σ2 + K * t / 3
      (0 < D →
        μ.real {ω | |∑ i, X i ω| ≥ t} ≤
          2 * Real.exp (-((t ^ 2 / 2) / D))) ∧
      (D = 0 →
        μ.real {ω | |∑ i, X i ω| ≥ t} ≤
          if t = 0 then 2 else 0)

end NumStability.HDP.Contract
