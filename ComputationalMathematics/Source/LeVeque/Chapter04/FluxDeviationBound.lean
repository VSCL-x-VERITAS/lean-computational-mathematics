/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# LeVeque Chapter 4, equation (4.15): numerical-flux deviation bound

The displayed inequality compares a two-state numerical flux to the physical
flux at a constant reference state. The prose requires the input states to be
close to that reference, but specifies no neighborhood radius.
-/

namespace NumStability

/-- The literal inequality in (4.15) at one reference state and two cell
values. A uniform or local quantifier over such triples is separate. -/
def leveque04_fluxDeviationBound
    (physicalFlux : ℝ → ℝ) (numericalFlux : ℝ → ℝ → ℝ)
    (L reference left right : ℝ) : Prop :=
  |numericalFlux left right - physicalFlux reference| ≤
    L * max |left - reference| |right - reference|

/-- Any instance of (4.15) at equal inputs forces the consistency equality
at that reference state, regardless of the chosen finite coefficient. -/
theorem leveque04_fluxDeviationBound_equal
    (physicalFlux : ℝ → ℝ) (numericalFlux : ℝ → ℝ → ℝ)
    (L reference : ℝ)
    (hbound : leveque04_fluxDeviationBound physicalFlux numericalFlux
      L reference reference reference) :
    numericalFlux reference reference = physicalFlux reference := by
  have hzero : |numericalFlux reference reference - physicalFlux reference| ≤ 0 := by
    simpa [leveque04_fluxDeviationBound] using hbound
  have hnorm : |numericalFlux reference reference - physicalFlux reference| = 0 :=
    le_antisymm hzero (abs_nonneg _)
  exact sub_eq_zero.mp (abs_eq_zero.mp hnorm)

end NumStability
