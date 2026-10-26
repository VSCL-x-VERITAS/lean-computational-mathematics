/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.PositiveSpeedUpwind
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift

/-!
# LeVeque Chapter 4, Exercise 4.2: unit-CFL exact cell shift

The positive-speed upwind method moves one cell value to its right when
the transport distance during a step equals the uniform cell width.
The existing translated-cell-average theorem identifies that shift with
the exact cell averages of the advected profile.
-/

namespace NumStability

/-- At positive-speed unit CFL, the source's upwind step is an exact
one-cell shift of arbitrary cell values. -/
theorem leveque04_exercise42_unitShift
    (speed timeStep cellWidth : ℝ)
    (hspeed : 0 < speed) (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = cellWidth)
    (cellAverage : ℤ → ℝ) (i : ℤ) :
    leveque04_positiveUpwindStep timeStep cellWidth speed cellAverage i =
      cellAverage (i - 1) := by
  rw [leveque04_equation25 timeStep cellWidth speed cellAverage i hspeed,
    hcfl, div_self hwidth.ne']
  ring

/-- The same unit-CFL upwind step propagates exact translated cell
averages for any initial profile represented by those averages. -/
theorem leveque04_exercise42_exactAverages
    (h speed timeStep distance : ℝ) (hh : 0 < h)
    (hspeed : 0 < speed) (hcfl : speed * timeStep = h)
    (profile : ℝ → Fin 1 → ℝ) (i : ℤ) :
    leveque04_positiveUpwindStep timeStep h speed
      (fun j => CFLUnitShift.averaged h hh profile distance j 0) i =
      CFLUnitShift.averaged h hh profile
        (distance + speed * timeStep) i 0 := by
  rw [leveque04_exercise42_unitShift speed timeStep h hspeed hh hcfl,
    hcfl, CFLUnitShift.averaged_eq_shift]

/-- Exercise 4.2's exact-average statement for a locally integrable physical
profile on a positive forward-time mesh. The physical average interpretation is
provided by `CFLUnitShift.averaged_is_cell_average`; the shift identity reuses
`leveque04_exercise42_exactAverages`. -/
theorem leveque04_exercise42_exactAverages_integrable
    (h speed timeStep distance : ℝ) (hh : 0 < h)
    (hspeed : 0 < speed) (_htime : 0 < timeStep)
    (hcfl : speed * timeStep = h) (profile : ℝ → Fin 1 → ℝ)
    (_hintegrable : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (i : ℤ) :
    leveque04_positiveUpwindStep timeStep h speed
      (fun j => CFLUnitShift.averaged h hh profile distance j 0) i =
      CFLUnitShift.averaged h hh profile (distance + speed * timeStep) i 0 :=
  leveque04_exercise42_exactAverages h speed timeStep distance hh hspeed hcfl profile i

end NumStability
