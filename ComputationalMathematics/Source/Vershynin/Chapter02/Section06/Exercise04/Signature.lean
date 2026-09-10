import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Probability.Independence.Basic

/-!
# Frozen contract signature for Exercise 2.6.4

The existential constant records the exercise's allowance to replace the
constant `2` in Hoeffding's exponent by an unspecified positive absolute
constant.  The factor `2` in front is inherited from the two-sided estimate in
Theorem 2.6.3.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d6_d4__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ},
      (∀ i, Measurable (X i)) →
      iIndepFun X μ →
      (∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i)) →
      0 < t →
      0 < ∑ i, ‖M i - m i‖ ^ 2 →
      μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
        2 * Real.exp
          (-(c * t ^ 2 / ∑ i, ‖M i - m i‖ ^ 2))

end NumStability.HDP.Contract
