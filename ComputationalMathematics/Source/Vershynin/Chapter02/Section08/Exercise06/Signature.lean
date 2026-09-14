import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein

/-!
# Frozen effective-domain signature for Exercise 2.8.6

The exercise asks for Theorem 2.8.4 to be deduced from Exercise 2.8.5. The
printed Bernstein quotient is retained when its denominator is positive; the
zero-denominator behavior is stated separately.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein

def hdp_02_hex_h2_d8_d6_effectiveDomain__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ},
    (Finset.univ : Finset ι).Nonempty →
    (∀ i, Measurable (X i)) →
    (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
    (∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K) →
    iIndepFun X μ →
    BoundedCenteredMGFHypothesis μ K →
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
