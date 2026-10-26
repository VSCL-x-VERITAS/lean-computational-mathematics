/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerMovingExactAverages
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerNonlinearFaceDerivative

/-!
# Derivative of Richtmyer flux on exact moving averages

The scalar flux chain rule is instantiated with exact moving cell
averages. The formula identifies the concrete derivative whose defect
from the physical time-averaged face-flux derivative must be bounded.
-/

namespace NumStability

open MeasureTheory

/-- The actual scalar Richtmyer flux evaluated on exact neighboring
cell averages has the explicit spatial derivative below. -/
theorem leveque04_richtmyer_exactAverageFaceFlux_hasDerivAt
    (profile flux flux' : ℝ → ℝ) (face timeStep width : ℝ)
    (hprofile : Continuous profile) (hwidth : 0 < width)
    (hflux : ∀ z, HasDerivAt flux (flux' z) z) :
    let left : ℝ → ℝ := fun x =>
      oneDimensionalCellAverage profile (x - width) x
    let right : ℝ → ℝ := fun x =>
      oneDimensionalCellAverage profile x (x + width)
    let leftSlope : ℝ → ℝ := fun x =>
      (profile x - profile (x - width)) / width
    let rightSlope : ℝ → ℝ := fun x =>
      (profile (x + width) - profile x) / width
    HasDerivAt
      (fun x => leveque04_richtmyerFlux timeStep width
        (fun state (_ : Fin 1) => flux (state 0))
        (fun _ => left x) (fun _ => right x) 0)
      (flux' (leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => left face) (fun _ => right face) 0) *
        ((leftSlope face + rightSlope face) / 2 -
          timeStep / (2 * width) *
            (flux' (right face) * rightSlope face -
              flux' (left face) * leftSlope face))) face := by
  dsimp only
  exact leveque04_richtmyerScalarFlux_hasDerivAt
    flux flux'
    (fun x => oneDimensionalCellAverage profile (x - width) x)
    (fun x => oneDimensionalCellAverage profile x (x + width))
    (fun x => (profile x - profile (x - width)) / width)
    (fun x => (profile (x + width) - profile x) / width)
    timeStep width face
    (leveque04_richtmyer_leftExactAverage_hasDerivAt
      profile face width hprofile hwidth)
    (leveque04_richtmyer_rightExactAverage_hasDerivAt
      profile face width hprofile hwidth)
    hflux

end NumStability
