/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equation (4.64): modified upwind method

The exercise presents two algebraic forms of a positive-speed, two-cell
method. The wave interpretation requested in part (a) is a separate task.
-/

namespace NumStability

/-- The first displayed update form in (4.64). -/
noncomputable def leveque04_equation64_step
    (speed timeStep cellWidth priorLeft left current : ℝ) : ℝ :=
  current - (current - left) -
    ((speed * timeStep - cellWidth) / cellWidth) * (left - priorLeft)

/-- Equation (4.64): the first update form equals the displayed
left-state-plus-correction form when the cell width is nonzero. -/
theorem leveque04_equation64
    (speed timeStep cellWidth priorLeft left current : ℝ)
    (_hspeed : 0 < speed)
    (hwidth : cellWidth ≠ 0) :
    leveque04_equation64_step speed timeStep cellWidth priorLeft left current =
      left - (speed * timeStep / cellWidth - 1) * (left - priorLeft) := by
  unfold leveque04_equation64_step
  field_simp [hwidth]
  ring

end NumStability
