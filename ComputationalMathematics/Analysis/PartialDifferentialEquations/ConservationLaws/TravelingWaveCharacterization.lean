/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Rectangle solution domain for a translated profile

For every real speed, rectangle conservation with its integrability conditions
holds exactly when the profile is integrable on every bounded interval.
-/

open MeasureTheory

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The full rectangle solution property requires precisely interval integrability
of the profile. This includes discontinuous profiles and every real speed. -/
theorem travelingWave_isRectangleConservationLawSolution_iff
    (profile : ℝ → E) (speed : ℝ) :
    IsRectangleConservationLawSolution (travelingWave profile speed)
      (fun state => speed • state) ↔
      ∀ a b, IntervalIntegrable profile volume a b := by
  constructor
  · intro h a b
    simpa only [travelingWave_zero] using h.1 a b 0
  · intro h
    exact travelingWave_isRectangleConservationLawSolution profile h speed

end NumStability
