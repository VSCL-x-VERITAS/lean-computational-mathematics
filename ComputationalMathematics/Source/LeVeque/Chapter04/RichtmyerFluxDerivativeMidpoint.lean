/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointError

/-!
# Time midpoint error for a physical face-flux derivative

The time average of a smooth spatial physical-flux derivative is
approximated at half time to quadratic mesh order. This is the third
premise of the Richtmyer numerical face derivative error budget.
-/

namespace NumStability

/-- A C² time trace of the physical-flux spatial derivative has a
quadratic midpoint error, measured against the spatial mesh width. -/
theorem leveque04_richtmyer_fluxDerivative_timeMidpointError
    (physicalFluxSlope : ℝ → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hmesh : timeStep ≤ width)
    (hsmooth : ContDiffOn ℝ 2 physicalFluxSlope
      (Set.Icc 0 timeStep))
    (hbound : ∀ τ,
      |iteratedDerivWithin 2 physicalFluxSlope
        (Set.Icc 0 timeStep) τ| ≤ bound) :
    |physicalFluxSlope (timeStep / 2) -
      oneDimensionalCellAverage physicalFluxSlope 0 timeStep| ≤
        (bound / 8) * width ^ 2 := by
  have hmid := leveque04_midpointError_secondOrder
    physicalFluxSlope 0 timeStep bound htime hsmooth hbound
  have hsq : timeStep ^ 2 ≤ width ^ 2 := by gcongr
  calc
    |physicalFluxSlope (timeStep / 2) -
        oneDimensionalCellAverage physicalFluxSlope 0 timeStep| =
      |oneDimensionalCellAverage physicalFluxSlope 0 timeStep -
        physicalFluxSlope (timeStep / 2)| := abs_sub_comm _ _
    _ ≤ timeStep ^ 2 * bound / 8 := by
      simpa only [zero_add, zero_sub, sub_zero] using hmid
    _ ≤ width ^ 2 * bound / 8 := by
      have hboundNonneg : 0 ≤ bound :=
        (abs_nonneg _).trans (hbound 0)
      have hmul := mul_le_mul_of_nonneg_right hsq hboundNonneg
      linarith
    _ = (bound / 8) * width ^ 2 := by ring

end NumStability
