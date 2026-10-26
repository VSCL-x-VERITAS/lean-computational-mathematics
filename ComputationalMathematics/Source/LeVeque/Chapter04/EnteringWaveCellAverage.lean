/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage

/-!
# LeVeque Chapter 4: a wave entering a cell

On printed page 79, the wave jump is right minus left. As the front moves
into the cell, its left state replaces its right state over the swept length.
This wrapper calculates the actual integrable profile and normalized spatial
averages for that single-wave contribution. It does not construct a full REA step.
-/

namespace NumStability
open MeasureTheory

/-- The explicit one-wave profile and actual spatial-average contract. -/
def Leveque04EnteringWaveCellAverageTarget : Prop :=
  ∀ (m : ℕ) (leftState valueAtJump rightState : Fin (m+1) → ℝ)
    (face cellWidth speed elapsedTime : ℝ),
    0 < cellWidth → 0 < speed → 0 ≤ elapsedTime →
    speed * elapsedTime ≤ cellWidth →
    let q := fun x t => travelingWave
      (riemannData leftState valueAtJump rightState) speed (x-face) t
    IntervalIntegrable (fun x => q x 0) volume face (face+cellWidth) ∧
    IntervalIntegrable (fun x => q x elapsedTime) volume face (face+cellWidth) ∧
    oneDimensionalCellAverage (fun x => q x 0) face (face+cellWidth) = rightState ∧
    oneDimensionalCellAverage (fun x => q x elapsedTime) face (face+cellWidth) =
      rightState - (speed * elapsedTime / cellWidth) • (rightState-leftState)


/-- The reusable traveling-jump calculation supplies the source contribution. -/
theorem leveque04_enteringWaveCellAverage : Leveque04EnteringWaveCellAverageTarget := by
  intro m left valueAtJump right face width speed elapsedTime hwidth hspeed htime htravel
  exact travelingWave_entering_cellAverage m left valueAtJump right
    face width speed elapsedTime hwidth hspeed htime htravel

end NumStability
