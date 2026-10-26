/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: equivalent views of the scalar upwind update

The pointwise finite-difference form, convex interpolation, and wave-jump
orientation use the already established upwind step and interface waves.
-/

namespace NumStability

/-- The positive-speed upwind step satisfies the one-sided pointwise
finite-difference equation displayed after (4.25). -/
theorem leveque04_upwindPointForm
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth)
    (hvelocity : 0 < velocity) :
    (leveque04_positiveUpwindStep timeStep cellWidth velocity cellAverage i -
      cellAverage i) / timeStep +
      velocity * (cellAverage i - cellAverage (i - 1)) / cellWidth = 0 := by
  rw [leveque04_equation25 timeStep cellWidth velocity cellAverage i hvelocity]
  field_simp
  ring

/-- Under (4.27), the positive-speed update is a convex combination of
the old current and left-neighbor states. -/
theorem leveque04_upwindConvexCombination
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ)
    (hvelocity : 0 < velocity)
    (hcfl : IsLeveque04PositiveUpwindCFL timeStep cellWidth velocity) :
    ∃ weight : ℝ, 0 ≤ weight ∧ weight ≤ 1 ∧
      leveque04_positiveUpwindStep timeStep cellWidth velocity cellAverage i =
        weight * cellAverage (i - 1) + (1 - weight) * cellAverage i := by
  exact ⟨velocity * timeStep / cellWidth, hcfl.1, hcfl.2,
    leveque04_equation26 timeStep cellWidth velocity cellAverage i hvelocity⟩

/-- The two interface waves have the orientations used in the positive and
negative-speed propagation formulas. -/
theorem leveque04_waveJumpOrientations (cellAverage : ℤ → ℝ) (i : ℤ) :
    leveque04_leftWaveJump cellAverage i =
        cellAverage i - cellAverage (i - 1) ∧
      leveque04_rightWaveJump cellAverage i =
        cellAverage (i + 1) - cellAverage i := ⟨rfl, rfl⟩

end NumStability
