/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelInjectiveTarget
import Mathlib.Tactic

/-!
# Positive initial density gives one-to-one Lagrangian mass labels
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- Every nonempty interval has positive initial mass, so the mass label is
strictly increasing and hence injective. -/
theorem lagrangianMassLabelInjective : lagrangianMassLabelInjectiveTarget := by
  intro initialDensity referenceLocation hintegrable hpositive
  have hstrict : StrictMono (lagrangianMassLabel initialDensity referenceLocation) := by
    intro left right hlt
    have hmass : 0 < ∫ s in left..right, initialDensity s :=
      intervalIntegral.intervalIntegral_pos_of_pos
        (hintegrable left right) hpositive hlt
    have hadd := intervalIntegral.integral_add_adjacent_intervals
      (hintegrable referenceLocation left) (hintegrable left right)
    dsimp [lagrangianMassLabel]
    linarith
  exact ⟨hstrict, hstrict.injective⟩

end NumStability.Leveque02Tracer
