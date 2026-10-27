/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation64ModifiedUpwind
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4, Exercise 4.3(b): interpolation form

For Courant number between one and two, the method (4.64) linearly
interpolates between the cell one place left and the cell two places left.
-/

namespace NumStability

/-- Exercise 4.3(b): the two interpolation weights are nonnegative,
sum to one, and give exactly the modified upwind update. -/
theorem leveque04_exercise43_interpolation
    (speed timeStep cellWidth priorLeft left current : ℝ)
    (hspeed : 0 < speed) (hwidth : 0 < cellWidth)
    (hlower : 1 ≤ speed * timeStep / cellWidth)
    (hupper : speed * timeStep / cellWidth ≤ 2) :
    let courant := speed * timeStep / cellWidth
    leveque04_equation64_step speed timeStep cellWidth
        priorLeft left current =
        (2 - courant) * left + (courant - 1) * priorLeft ∧
      0 ≤ 2 - courant ∧
      0 ≤ courant - 1 ∧
      (2 - courant) + (courant - 1) = 1 := by
  dsimp only
  rw [leveque04_equation64 speed timeStep cellWidth priorLeft left current
    hspeed hwidth.ne']
  constructor
  · ring
  constructor
  · linarith
  constructor
  · linarith
  · ring

end NumStability
