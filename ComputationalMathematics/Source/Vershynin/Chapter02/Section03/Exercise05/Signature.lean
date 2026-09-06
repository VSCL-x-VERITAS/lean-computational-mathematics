import Mathlib.Probability.Independence.Integration
import Mathlib.Probability.HasLaw
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-! Frozen proof-free signature for Exercise 2.3.5. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators
open scoped NNReal

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d3_d5__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0},
    (hp : ∀ i, p i ≤ 1) →
    iIndepFun B μ →
    (∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ) →
    (∀ i, Measurable (B i)) →
    ∀ {δ : ℝ}, 0 < δ → δ ≤ 1 →
    (∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ) →
    (∀ (lam : ℝ),
      Integrable (fun ω => Real.exp (lam * ∑ i, (if B i ω then 1 else 0))) μ) →
    μ.real {ω |
        δ * (∑ i, (p i : ℝ)) ≤
          |(∑ i, (if B i ω then 1 else 0)) - ∑ i, (p i : ℝ)|} ≤
      2 * Real.exp (-(∑ i, (p i : ℝ)) * δ ^ 2 / 4)

end NumStability.HDP.Contract
