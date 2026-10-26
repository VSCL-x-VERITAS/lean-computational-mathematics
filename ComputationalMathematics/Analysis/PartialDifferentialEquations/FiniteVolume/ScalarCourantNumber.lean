/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Scalar Courant number

Source-independent total-real-division formula and its positive-width distance ratio.
The existing public NumStability names are retained as required by the compatibility policy.
-/

namespace NumStability

/-- Scalar advection Courant number for speed `velocity`, time step `Δt`,
and positive cell width `Δx`. -/
noncomputable def leveque04_scalarCourantNumber
    (timeStep cellWidth velocity : ℝ) : ℝ :=
  |velocity * timeStep / cellWidth|

/-- For a positive time step and cell width, the scalar Courant number is
the distance traveled at constant speed divided by the cell width. -/
theorem leveque04_scalarCourantNumber_eq_distanceRatio
    (timeStep cellWidth velocity : ℝ) (_htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    leveque04_scalarCourantNumber timeStep cellWidth velocity =
      |velocity * timeStep| / cellWidth := by
  simp only [leveque04_scalarCourantNumber, abs_div, abs_of_pos hwidth]

end NumStability
