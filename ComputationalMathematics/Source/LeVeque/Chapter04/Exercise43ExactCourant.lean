/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation64ModifiedUpwind
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, Exercise 4.3(c): exact integer-cell shifts

At Courant numbers one and two, the modified three-cell method (4.64)
selects the cell average one or two cells to the left. Translation of a
profile by the same integer number of cell widths gives those averages.
-/

namespace NumStability

/-- At Courant number one, (4.64) selects the immediately left cell. -/
theorem leveque04_equation64_unitShift
    (speed timeStep cellWidth priorLeft left current : ℝ)
    (hspeed : 0 < speed) (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = cellWidth) :
    leveque04_equation64_step speed timeStep cellWidth
      priorLeft left current = left := by
  rw [leveque04_equation64 speed timeStep cellWidth priorLeft left current
    hspeed hwidth.ne', hcfl, div_self hwidth.ne']
  ring

/-- At Courant number two, (4.64) selects the cell two places left. -/
theorem leveque04_equation64_twoShift
    (speed timeStep cellWidth priorLeft left current : ℝ)
    (hspeed : 0 < speed) (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = 2 * cellWidth) :
    leveque04_equation64_step speed timeStep cellWidth
      priorLeft left current = priorLeft := by
  rw [leveque04_equation64 speed timeStep cellWidth priorLeft left current
    hspeed hwidth.ne', hcfl]
  rw [mul_div_cancel_right₀ _ hwidth.ne']
  ring

/-- Translating a profile by two cell widths shifts its exact cell
averages two integer cells, by two applications of the existing theorem. -/
theorem leveque04_averaged_twoShift
    {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (profile : ℝ → ι → ℝ) (distance : ℝ) (i : ℤ) :
    CFLUnitShift.averaged h hh profile (distance + 2 * h) i =
      CFLUnitShift.averaged h hh profile distance (i - 2) := by
  have ht : distance + 2 * h = (distance + h) + h := by ring
  rw [ht, CFLUnitShift.averaged_eq_shift,
    CFLUnitShift.averaged_eq_shift]
  congr 1
  ring

/-- Exercise 4.3(c), Courant one: applying (4.64) to exact initial
cell averages gives the exact advected cell average after one step. -/
theorem leveque04_exercise43_unitExact
    (h speed timeStep distance : ℝ) (hh : 0 < h)
    (hspeed : 0 < speed) (hcfl : speed * timeStep = h)
    (profile : ℝ → Fin 1 → ℝ) (i : ℤ) :
    leveque04_equation64_step speed timeStep h
        (CFLUnitShift.averaged h hh profile distance (i - 2) 0)
        (CFLUnitShift.averaged h hh profile distance (i - 1) 0)
        (CFLUnitShift.averaged h hh profile distance i 0) =
      CFLUnitShift.averaged h hh profile
        (distance + speed * timeStep) i 0 := by
  rw [leveque04_equation64_unitShift speed timeStep h _ _ _ hspeed hh hcfl,
    hcfl, CFLUnitShift.averaged_eq_shift]

/-- Exercise 4.3(c), Courant two: the same method advances exact cell
averages by two cells at the corresponding physical transport distance. -/
theorem leveque04_exercise43_twoExact
    (h speed timeStep distance : ℝ) (hh : 0 < h)
    (hspeed : 0 < speed) (hcfl : speed * timeStep = 2 * h)
    (profile : ℝ → Fin 1 → ℝ) (i : ℤ) :
    leveque04_equation64_step speed timeStep h
        (CFLUnitShift.averaged h hh profile distance (i - 2) 0)
        (CFLUnitShift.averaged h hh profile distance (i - 1) 0)
        (CFLUnitShift.averaged h hh profile distance i 0) =
      CFLUnitShift.averaged h hh profile
        (distance + speed * timeStep) i 0 := by
  rw [leveque04_equation64_twoShift speed timeStep h _ _ _ hspeed hh hcfl,
    hcfl, leveque04_averaged_twoShift]

/-- Exercise 4.3(c): at either listed integer Courant number, the modified
upwind method advances the cell averages of any locally integrable physical
profile exactly on a positive forward-time mesh. -/
theorem leveque04_exercise43_integerCourantExact_integrable
    (h speed timeStep distance : ℝ) (hh : 0 < h)
    (hspeed : 0 < speed) (_htime : 0 < timeStep) (profile : ℝ → Fin 1 → ℝ)
    (_hintegrable : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (i : ℤ) (hcfl : speed * timeStep = h ∨ speed * timeStep = 2 * h) :
    leveque04_equation64_step speed timeStep h
      (CFLUnitShift.averaged h hh profile distance (i - 2) 0)
      (CFLUnitShift.averaged h hh profile distance (i - 1) 0)
      (CFLUnitShift.averaged h hh profile distance i 0) =
      CFLUnitShift.averaged h hh profile (distance + speed * timeStep) i 0 := by
  rcases hcfl with hunit | htwo
  · exact leveque04_exercise43_unitExact h speed timeStep distance hh hspeed hunit profile i
  · exact leveque04_exercise43_twoExact h speed timeStep distance hh hspeed htwo profile i

end NumStability
