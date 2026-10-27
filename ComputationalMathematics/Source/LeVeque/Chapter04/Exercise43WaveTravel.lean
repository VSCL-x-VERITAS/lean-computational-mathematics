/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation64ModifiedUpwind
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4, Exercise 4.3(a): waves traveling one to two cells

At a Courant number between one and two, the wave at the near face
crosses the whole target cell. The wave one face farther left travels
the remaining fraction into it, leaving two constant regions.
-/

namespace NumStability

/-- The two constant regions in the target cell after waves travel
between one and two widths. -/
noncomputable def leveque04_twoCellWaveAverage
    (speed timeStep cellWidth priorLeft left : ℝ) : ℝ :=
  ((speed * timeStep - cellWidth) * priorLeft +
    (2 * cellWidth - speed * timeStep) * left) / cellWidth

/-- The traveled lengths of the two regions are nonnegative and sum
to one cell width. -/
theorem leveque04_twoCellWave_regionLengths
    (speed timeStep cellWidth : ℝ)
    (hlower : cellWidth ≤ speed * timeStep)
    (hupper : speed * timeStep ≤ 2 * cellWidth) :
    0 ≤ speed * timeStep - cellWidth ∧
      0 ≤ 2 * cellWidth - speed * timeStep ∧
      (speed * timeStep - cellWidth) +
        (2 * cellWidth - speed * timeStep) = cellWidth := by
  refine ⟨?_, ?_, ?_⟩
  · linarith
  · linarith
  · ring

/-- Exercise 4.3(a): the full near-wave crossing and partial far-wave
crossing give exactly the modified upwind method (4.64). -/
theorem leveque04_exercise43_waveTravel
    (speed timeStep cellWidth priorLeft left current : ℝ)
    (hwidth : 0 < cellWidth)
    (hlower : cellWidth ≤ speed * timeStep)
    (hupper : speed * timeStep ≤ 2 * cellWidth) :
    leveque04_twoCellWaveAverage speed timeStep cellWidth priorLeft left =
      leveque04_equation64_step speed timeStep cellWidth
        priorLeft left current := by
  have _ := leveque04_twoCellWave_regionLengths speed timeStep
    cellWidth hlower hupper
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  unfold leveque04_twoCellWaveAverage leveque04_equation64_step
  field_simp
  ring

end NumStability
