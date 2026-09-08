/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Logic.Function.RangeFactorization

/-!
# LeVeque Chapter 1, dependence on current data

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 10 (raw PDF page 32), Section 1.7. A one-step method determines
the next-time solution entirely from current-time data.

At a fixed time level, `History` describes admissible transitions, `current`
extracts their complete current-time data, and `advance` is the next-time
solution. These types and the extractor are arbitrary: auxiliary current data
may be included, and no update outside the attainable range is required.
-/

namespace NumStability

/-- Dependence only on current data is exactly an update on attainable current
data, with arbitrary admissible histories and next-time solution types. -/
theorem leveque01_oneStepMethod_iff_attainableCurrentDataMap
    {History : Sort*} {CurrentData : Type*} {NextData : Sort*}
    (current : History → CurrentData) (advance : History → NextData) :
    (∀ history₁ history₂, current history₁ = current history₂ →
      advance history₁ = advance history₂) ↔
      ∃ step : Set.range current → NextData,
        advance = step ∘ Set.rangeFactorization current := by
  simpa only [_root_.Function.FactorsThrough] using
    Function.factorsThrough_iff_rangeFactorization current advance

end NumStability
