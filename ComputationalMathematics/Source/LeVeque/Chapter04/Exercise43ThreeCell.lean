/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise43WaveTravel

/-!
# LeVeque Chapter 4, Exercise 4.3(e): waves traveling two to three cells

The two nearest waves cross the whole target cell. The wave two faces
farther left travels the remaining fraction into it, so the cell
average interpolates between the cells two and three places left.
-/

namespace NumStability

/-- The analogous three-cell wave-propagation update, written as two
complete wave crossings followed by one partial crossing. -/
noncomputable def leveque04_threeCellWaveStep
    (speed timeStep cellWidth priorThird priorSecond priorFirst current : ℝ) : ℝ :=
  current - (current - priorFirst) - (priorFirst - priorSecond) -
    ((speed * timeStep - 2 * cellWidth) / cellWidth) *
      (priorSecond - priorThird)

/-- Exercise 4.3(e): the three-cell method is an interpolation between
the states two and three cells to the left, with nonnegative weights. -/
theorem leveque04_exercise43_threeCell
    (speed timeStep cellWidth priorThird priorSecond priorFirst current : ℝ)
    (hwidth : 0 < cellWidth)
    (hlower : 2 * cellWidth ≤ speed * timeStep)
    (hupper : speed * timeStep ≤ 3 * cellWidth) :
    let fraction := (speed * timeStep - 2 * cellWidth) / cellWidth
    leveque04_threeCellWaveStep speed timeStep cellWidth
        priorThird priorSecond priorFirst current =
        (1 - fraction) * priorSecond + fraction * priorThird ∧
      0 ≤ fraction ∧ fraction ≤ 1 := by
  dsimp only
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  constructor
  · unfold leveque04_threeCellWaveStep
    ring
  constructor
  · exact div_nonneg (sub_nonneg.mpr hlower) hwidth.le
  · apply (div_le_iff₀ hwidth).mpr
    linarith

/-- At Courant numbers two and three, the method is exactly a two- or
three-cell shift, respectively. -/
theorem leveque04_exercise43_threeCell_endpoints
    (cellWidth priorThird priorSecond priorFirst current : ℝ)
    (hwidth : 0 < cellWidth) :
    leveque04_threeCellWaveStep 1 (2 * cellWidth) cellWidth
        priorThird priorSecond priorFirst current = priorSecond ∧
      leveque04_threeCellWaveStep 1 (3 * cellWidth) cellWidth
        priorThird priorSecond priorFirst current = priorThird := by
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  constructor <;> unfold leveque04_threeCellWaveStep <;>
    field_simp <;> ring

end NumStability
