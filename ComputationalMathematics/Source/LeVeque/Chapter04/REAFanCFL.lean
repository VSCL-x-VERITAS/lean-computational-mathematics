/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Cell
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4, equation (4.36): noninteracting acoustics fans

For waves of the same speed magnitude entering a cell from its two faces,
their fronts remain ordered exactly when the travel-to-width ratio is at
most one half.
-/

namespace NumStability

/-- The right-going front from the left face has not crossed the left-going
front from the right face after one time step. -/
def IsLeveque04REAFanNoninteracting
    (interface : ℤ → ℝ) (i : ℤ) (soundSpeed timeStep : ℝ) : Prop :=
  interface (i - 1) + soundSpeed * timeStep ≤
    interface i - soundSpeed * timeStep

/-- Equation (4.36): for a positive-width cell, noninteraction of the two
opposing acoustic fronts is equivalent to the half-Courant bound. -/
theorem leveque04_equation36
    (interface : ℤ → ℝ) (i : ℤ) (soundSpeed timeStep : ℝ)
    (hwidth : 0 < leveque04_cellWidth interface i) :
    IsLeveque04REAFanNoninteracting interface i soundSpeed timeStep ↔
      soundSpeed * timeStep / leveque04_cellWidth interface i ≤ (1 / 2 : ℝ) := by
  rw [div_le_iff₀ hwidth]
  unfold IsLeveque04REAFanNoninteracting leveque04_cellWidth
  constructor <;> intro h <;> linarith

end NumStability
