/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.QuadraticCellAverage
import Mathlib.Tactic.Linarith

/-!
# Exact physical averages under signed scalar upwind transport

The signed recurrence transports every cell average exactly for a zero or
unit-cell displacement. A quadratic test forces those displacements when
the recurrence is exact. The recurrence is exposed as an expression, so
these lemmas introduce no second numerical-step definition.
-/

namespace NumStability

/-- Exactness on a quadratic test forces stationary or unit-cell displacement. -/
theorem signedUpwind_quadraticAverage_exactness_necessity
    (width timeStep speed : ℝ) (hwidth : 0 < width) (_htime : 0 < timeStep)
    (hexact : width ^ 2 / 12 - timeStep / width *
      (max speed 0 * (-width ^ 2) + min speed 0 * width ^ 2) =
      oneDimensionalCellAverage (fun x : ℝ => (x-speed*timeStep)^2)
        (-width/2) (width/2)) :
    speed*timeStep = -width ∨ speed*timeStep = 0 ∨ speed*timeStep = width := by
  have hav := oneDimensionalCellAverage_translated_quadratic 0 width
    (speed*timeStep) hwidth
  simp only [zero_sub, zero_add] at hav
  rw [neg_div, hav] at hexact
  by_cases hs : 0 ≤ speed
  · rw [max_eq_left hs, min_eq_right hs] at hexact
    have hz : (speed*timeStep)*(speed*timeStep-width) = 0 := by
      field_simp [hwidth.ne'] at hexact
      nlinarith
    rcases mul_eq_zero.mp hz with hz | hz
    · exact Or.inr (Or.inl hz)
    · exact Or.inr (Or.inr (sub_eq_zero.mp hz))
  · have hsneg : speed ≤ 0 := le_of_lt (lt_of_not_ge hs)
    rw [max_eq_right hsneg, min_eq_left hsneg] at hexact
    have hz : (speed*timeStep)*(speed*timeStep+width) = 0 := by
      field_simp [hwidth.ne'] at hexact
      nlinarith
    rcases mul_eq_zero.mp hz with hz | hz
    · exact Or.inr (Or.inl hz)
    · exact Or.inl (eq_neg_of_add_eq_zero_left hz)

/-- An aligned signed recurrence advances actual averages of arbitrary profiles. -/
theorem signedUpwind_exact_average_of_gridAligned
    (width timeStep speed : ℝ) (hwidth : 0 < width) (htime : 0 < timeStep)
    (halign : speed*timeStep = -width ∨ speed*timeStep = 0 ∨ speed*timeStep = width)
    (profile : ℝ → Fin 2 → ℝ)
    (_hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (distance : ℝ) (j : ℤ) (p : Fin 2) :
    CFLUnitShift.averaged width hwidth profile distance j p - timeStep/width *
      (max speed 0 * (CFLUnitShift.averaged width hwidth profile distance j p -
        CFLUnitShift.averaged width hwidth profile distance (j-1) p) +
      min speed 0 * (CFLUnitShift.averaged width hwidth profile distance (j+1) p -
        CFLUnitShift.averaged width hwidth profile distance j p)) =
    CFLUnitShift.averaged width hwidth profile (distance+speed*timeStep) j p := by
  rcases halign with hneg | hzero | hpos
  · have hs : speed ≤ 0 := by nlinarith
    have hratio : timeStep/width*speed = -1 := by
      field_simp [hwidth.ne']
      nlinarith [hneg]
    rw [max_eq_right hs, min_eq_left hs, hneg]
    simp only [zero_mul, zero_add]
    rw [← mul_assoc, hratio]
    have hshift := CFLUnitShift.averaged_eq_shift width hwidth profile
      (distance-width) (j+1)
    have hleft : CFLUnitShift.averaged width hwidth profile (distance-width) j =
        CFLUnitShift.averaged width hwidth profile distance (j+1) := by
      simpa only [sub_add_cancel, add_sub_cancel_right] using hshift.symm
    have hd : distance + -width = distance-width := by ring
    rw [hd, hleft]
    ring
  · have hs : speed = 0 := (mul_eq_zero.mp hzero).resolve_right htime.ne'
    subst speed
    simp
  · have hs : 0 ≤ speed := by nlinarith
    have hratio : timeStep/width*speed = 1 := by
      field_simp [hwidth.ne']
      nlinarith [hpos]
    rw [max_eq_left hs, min_eq_right hs, hpos, CFLUnitShift.averaged_eq_shift]
    simp only [zero_mul, add_zero]
    rw [← mul_assoc, hratio]
    ring

end NumStability
