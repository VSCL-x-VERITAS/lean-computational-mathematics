/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Cell
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: one right-going wave entering a cell

The wave travels `speed * timeStep` into the cell. Behind it the state is
the left Riemann state; ahead of it the state is the original right
state. The two constant regions are averaged by their lengths.
-/

namespace NumStability

/-- The average of the constant regions behind and ahead of one wave. -/
noncomputable def leveque04_singleWaveCellAverage
    {m : ℕ} (speed timeStep cellWidth : ℝ)
    (leftState rightState : Fin m → ℝ) : Fin m → ℝ :=
  cellWidth⁻¹ •
    ((speed * timeStep) • leftState +
      (cellWidth - speed * timeStep) • rightState)

/-- A positive-speed wave changes the average by minus the wave jump
times its traveled fraction of the cell width. -/
theorem leveque04_waveCellEffect
    {m : ℕ} (speed timeStep cellWidth : ℝ)
    (leftState rightState wave : Fin m → ℝ)
    (hwidth : 0 < cellWidth)
    (htravel : 0 ≤ speed * timeStep)
    (hinside : speed * timeStep ≤ cellWidth)
    (hjump : wave = rightState - leftState) :
    leveque04_singleWaveCellAverage speed timeStep cellWidth
        leftState rightState =
      rightState - (speed * timeStep / cellWidth) • wave := by
  have _ : 0 ≤ cellWidth - speed * timeStep := sub_nonneg.mpr hinside
  have _ := htravel
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  subst wave
  funext j
  simp only [leveque04_singleWaveCellAverage, Pi.smul_apply,
    Pi.add_apply, Pi.sub_apply, smul_eq_mul]
  field_simp
  ring

end NumStability
