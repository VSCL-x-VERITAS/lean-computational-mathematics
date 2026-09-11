import Mathlib.Probability.Moments.Basic
import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Frozen contract signature for Theorem 2.8.2

This file is intentionally proof-free.  It records weighted Bernstein on the
effective domain of the displayed quotients and separates their zero-scale
boundary.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

/-- Effective-domain form of Theorem 2.8.2.  The positive-scale branch is the
printed weighted inequality.  When its quadratic scale vanishes, the weighted
sum is almost surely zero and its deterministic tail is stated separately. -/
def hdp_02_hthm_h2_d8_d2_effectiveDomain__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ} {a : ι → ℝ}
      (hne : (Finset.univ : Finset ι).Nonempty),
      (∀ i, Measurable (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      (∀ i, PsiOneGauge μ (X i) < ∞) →
      iIndepFun X μ →
      let K := Finset.univ.sup' hne
        (fun i => (PsiOneGauge μ (X i)).toReal)
      let A := K ^ 2 * ∑ i, a i ^ 2
      let B := K * Finset.univ.sup' hne (fun i => |a i|)
      (0 < A → ∀ {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * min (t ^ 2 / A) (t / B)))) ∧
      (A = 0 → ∀ {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
          if t = 0 then 2 else 0)

end NumStability.HDP.Contract
