/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.WaveCellEffect
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42UnitCFL
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Module

/-!
# LeVeque Chapter 4, Exercise 4.2(a): the unit-CFL wave picture

At positive-speed unit CFL the wave front starting at a cell's left
face reaches its right face exactly. The cell is entirely in the state
behind that front, and the upwind numerical update shifts the old
cell average by one cell.
-/

namespace NumStability

/-- At unit CFL a right-going front crosses exactly one cell width. -/
theorem leveque04_exercise42_waveFront_at_rightFace
    (leftFace rightFace speed timeStep : ℝ)
    (_hwidth : 0 < rightFace - leftFace)
    (hcfl : speed * timeStep = rightFace - leftFace) :
    leftFace + speed * timeStep = rightFace := by
  linarith

/-- The constant region behind the front occupies the whole cell at
unit CFL, so its average is exactly the incoming left state. -/
theorem leveque04_exercise42_waveAverage_unitCFL
    {m : ℕ} (speed timeStep cellWidth : ℝ)
    (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = cellWidth)
    (leftState rightState : Fin m → ℝ) :
    leveque04_singleWaveCellAverage speed timeStep cellWidth
      leftState rightState = leftState := by
  have htravel : 0 ≤ speed * timeStep := by rw [hcfl]; exact hwidth.le
  have hinside : speed * timeStep ≤ cellWidth := hcfl.le
  have h := leveque04_waveCellEffect speed timeStep cellWidth
    leftState rightState (rightState - leftState)
    hwidth htravel hinside rfl
  rw [h, hcfl, div_self hwidth.ne']
  module

/-- The geometric one-cell crossing agrees with the proved scalar
upwind update at the same unit-CFL time step. -/
theorem leveque04_exercise42_waveShift
    (speed timeStep cellWidth : ℝ)
    (hspeed : 0 < speed)
    (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = cellWidth)
    (old : ℤ → ℝ) (i : ℤ) :
    leveque04_positiveUpwindStep timeStep cellWidth speed old i =
      old (i - 1) := by
  exact leveque04_exercise42_unitShift speed timeStep cellWidth
    hspeed hwidth hcfl old i

end NumStability
