/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Set.Operations
import Mathlib.Logic.Function.Basic

/-!
# Factorization through attainable values

A function constant on the fibers of another function factors through its range.
The factor is defined only on attainable values, so no nonempty codomain or
extension to unattainable values is needed.
-/

namespace NumStability.Function

/-- Constancy on fibers is equivalent to factorization through the actual range. -/
theorem factorsThrough_iff_rangeFactorization
    {History : Sort*} {CurrentData : Type*} {NextData : Sort*}
    (current : History → CurrentData) (advance : History → NextData) :
    _root_.Function.FactorsThrough advance current ↔
      ∃ step : Set.range current → NextData,
        advance = step ∘ Set.rangeFactorization current := by
  constructor
  · intro hdependence
    obtain ⟨representative, hrepresentative⟩ :=
      (Set.rangeFactorization_surjective (f := current)).hasRightInverse
    refine ⟨advance ∘ representative, ?_⟩
    funext history
    apply hdependence
    exact (congrArg Subtype.val (hrepresentative (Set.rangeFactorization current history))).symm
  · rintro ⟨step, hstep⟩ history₁ history₂ hcurrent
    rw [hstep, _root_.Function.comp_apply, _root_.Function.comp_apply]
    exact congrArg step (Subtype.ext hcurrent)

end NumStability.Function
