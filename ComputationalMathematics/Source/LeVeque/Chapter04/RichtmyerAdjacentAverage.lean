/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdjacentCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointError

/-!
# Centered exact cell averages at a Richtmyer face

The mean of the two neighboring exact cell averages is a midpoint
quadrature value on their union. This supplies the spatial state term
in the actual scalar Richtmyer half-time predictor estimate.
-/

namespace NumStability

open MeasureTheory

/-- For a C² profile, the two neighboring exact cell averages have a
second-order centered mean at their shared face. -/
theorem leveque04_richtmyer_adjacentExactAverages_midpointError
    (profile : ℝ → ℝ) (face width bound : ℝ)
    (hwidth : 0 < width)
    (hleft : IntervalIntegrable profile volume (face - width) face)
    (hright : IntervalIntegrable profile volume face (face + width))
    (hsmooth : ContDiffOn ℝ 2 profile
      (Set.Icc (face - width) (face + width)))
    (hderiv : ∀ x,
      |iteratedDerivWithin 2 profile
        (Set.Icc (face - width) (face + width)) x| ≤ bound) :
    |(oneDimensionalCellAverage profile (face - width) face +
          oneDimensionalCellAverage profile face (face + width)) / 2 -
        profile face| ≤ bound * width ^ 2 / 2 := by
  rw [adjacentCellAverage_mean_eq_unionAverage
    profile face width hwidth hleft hright]
  have hmid := leveque04_midpointError_secondOrder
    profile (face - width) (face + width) bound
    (by linarith) hsmooth hderiv
  have hcenter : ((face - width) + (face + width)) / 2 = face := by ring
  rw [hcenter] at hmid
  convert hmid using 1
  ring

end NumStability
