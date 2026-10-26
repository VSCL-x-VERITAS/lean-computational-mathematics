/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation64ModifiedUpwind
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4, Exercise 4.3(d): CFL domain for the two-cell method

After cancellation, (4.64) depends on the two cells one and two places
left. The exact positive-advection backtrace of the target cell lies
inside this numerical dependence interval exactly for Courant numbers
between one and two.
-/

namespace NumStability

/-- The actual stencil of (4.64) omits the current cell value. -/
theorem leveque04_equation64_independent_current
    (speed timeStep cellWidth priorLeft left current₁ current₂ : ℝ)
    (hspeed : 0 < speed) (hwidth : cellWidth ≠ 0) :
    leveque04_equation64_step speed timeStep cellWidth
        priorLeft left current₁ =
      leveque04_equation64_step speed timeStep cellWidth
        priorLeft left current₂ := by
  rw [leveque04_equation64 speed timeStep cellWidth
    priorLeft left current₁ hspeed hwidth,
    leveque04_equation64 speed timeStep cellWidth
      priorLeft left current₂ hspeed hwidth]

/-- For a unit-width target cell, its exact backtraced interval is
`[-courant, 1-courant]`. The two influencing old cells cover `[-2,0]`. -/
def IsLeveque04TwoCellCFL (courant : ℝ) : Prop :=
  Set.Icc (-courant) (1 - courant) ⊆ Set.Icc (-2 : ℝ) 0

/-- Exercise 4.3(d): the exact backtraced cell fits in the actual
two-cell numerical stencil precisely for Courant numbers in `[1,2]`. -/
theorem leveque04_exercise43_cfl (courant : ℝ) :
    IsLeveque04TwoCellCFL courant ↔
      1 ≤ courant ∧ courant ≤ 2 := by
  unfold IsLeveque04TwoCellCFL
  constructor
  · intro h
    have hleft : -courant ∈ Set.Icc (-courant) (1 - courant) := by
      simp
    have hright : 1 - courant ∈ Set.Icc (-courant) (1 - courant) := by
      simp
    have hl := h hleft
    have hr := h hright
    simp only [Set.mem_Icc] at hl hr
    constructor <;> linarith
  · rintro ⟨hlower, hupper⟩ x hx
    simp only [Set.mem_Icc] at hx ⊢
    constructor <;> linarith

end NumStability
