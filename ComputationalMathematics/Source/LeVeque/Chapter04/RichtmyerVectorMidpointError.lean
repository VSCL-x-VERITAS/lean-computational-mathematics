/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorPhysicalFluxAverageDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageMidpoint
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Vector midpoint estimate for the Richtmyer physical face flux

The existing scalar cell-average midpoint estimate applies to every
coordinate of a finite vector time trace. The supremum norm packages
the componentwise estimates into a vector bound.
-/

namespace NumStability

open MeasureTheory Set

theorem leveque04_richtmyer_vectorCellMidpoint_error
    {m : ℕ} (profile : ℝ → Fin m → ℝ)
    (left right bound : ℝ)
    (hcell : left < right) (hbound : 0 ≤ bound)
    (hcontinuous : Continuous profile)
    (hsmooth : ∀ p, ContDiffOn ℝ 2 (fun x => profile x p)
      (Icc left right))
    (hsecond : ∀ p x,
      |iteratedDerivWithin 2 (fun y => profile y p)
        (Icc left right) x| ≤ bound) :
    ‖oneDimensionalCellAverage profile left right -
        profile ((left + right) / 2)‖ ≤
      (right - left) ^ 2 * bound / 8  := by
  exact cellAverage_midpoint_error_le_of_component_bounds profile left right bound
    hcell hbound (hcontinuous.intervalIntegrable (μ := volume) left right) hsmooth hsecond


theorem leveque04_richtmyer_vectorMidpointTimeAverage_error
    {m : ℕ} (trace : ℝ → Fin m → ℝ)
    (timeStep curvature : ℝ)
    (htime : 0 < timeStep) (hcurvature : 0 ≤ curvature)
    (hcontinuous : Continuous trace)
    (hsmooth : ∀ p, ContDiffOn ℝ 2 (fun τ => trace τ p)
      (Icc 0 timeStep))
    (hsecond : ∀ p τ,
      |iteratedDerivWithin 2 (fun σ => trace σ p)
        (Icc 0 timeStep) τ| ≤ curvature) :
    ‖oneDimensionalCellAverage trace 0 timeStep -
        trace (timeStep / 2)‖ ≤ timeStep ^ 2 * curvature / 8 := by
  simpa only [zero_add, sub_zero] using
    (leveque04_richtmyer_vectorCellMidpoint_error
      trace 0 timeStep curvature htime hcurvature
      hcontinuous hsmooth hsecond)

theorem leveque04_richtmyer_vectorMidpointTimeAverage_meshError
    {m : ℕ} (trace : ℝ → Fin m → ℝ)
    (timeStep width curvature : ℝ)
    (htime : 0 < timeStep) (hmesh : timeStep ≤ width)
    (hcurvature : 0 ≤ curvature)
    (hcontinuous : Continuous trace)
    (hsmooth : ∀ p, ContDiffOn ℝ 2 (fun τ => trace τ p)
      (Icc 0 timeStep))
    (hsecond : ∀ p τ,
      |iteratedDerivWithin 2 (fun σ => trace σ p)
        (Icc 0 timeStep) τ| ≤ curvature) :
    ‖trace (timeStep / 2) -
        oneDimensionalCellAverage trace 0 timeStep‖ ≤
      (curvature / 8) * width ^ 2 := by
  have hmid := leveque04_richtmyer_vectorMidpointTimeAverage_error
    trace timeStep curvature htime hcurvature hcontinuous hsmooth hsecond
  rw [norm_sub_rev] at hmid
  have hsq : timeStep ^ 2 ≤ width ^ 2 := by gcongr
  calc
    _ ≤ timeStep ^ 2 * curvature / 8 := hmid
    _ ≤ width ^ 2 * curvature / 8 := by gcongr
    _ = (curvature / 8) * width ^ 2 := by ring

end NumStability
