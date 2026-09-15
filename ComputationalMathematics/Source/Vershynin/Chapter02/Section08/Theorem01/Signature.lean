import Mathlib.Probability.Moments.Basic
import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Frozen contract signature for Theorem 2.8.1

This file is intentionally proof-free.  It records Bernstein's inequality on
the effective domain of its two displayed quotients, together with the exact
degenerate conclusion when every `ψ₁` gauge vanishes.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

/-- Effective-domain form of Theorem 2.8.1.  The positive-energy branch is the
printed inequality verbatim.  The zero-energy branch avoids assigning a real
value to the source's undefined `0 / 0` quotients and records the corresponding
deterministic tail instead. -/
def hdp_02_hthm_h2_d8_d1_effectiveDomain__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
      (∀ i, Measurable (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      (∀ i, PsiOneGauge μ (X i) < ∞) →
      iIndepFun X μ →
      let S := ∑ i, ((PsiOneGauge μ (X i)).toReal) ^ 2
      let M := Finset.univ.sup' hne
        (fun i => (PsiOneGauge μ (X i)).toReal)
      (0 < S → ∀ {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, X i ω| ≥ t} ≤
          2 * Real.exp (-(c * min (t ^ 2 / S) (t / M)))) ∧
      (S = 0 → ∀ {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, X i ω| ≥ t} ≤
          if t = 0 then 2 else 0)

end NumStability.HDP.Contract
