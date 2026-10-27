/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictor
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointError

/-!
# Scalar Richtmyer face error from midpoint prediction

The actual equation-(4.23) predictor is compared with the physical
solution at half time. A flux Lipschitz bound transfers its state error,
while the existing midpoint quadrature theorem controls the time average.
-/

namespace NumStability

/-- A quadratic predictor error and a bounded second time derivative of
the physical face flux give quadratic error for the actual scalar
Richtmyer numerical face flux against the exact physical time average. -/
theorem leveque04_richtmyerScalar_midpointFaceError
    (flux trace : ℝ → ℝ)
    (left right : Fin 1 → ℝ)
    (timeStep width L predictorBound curvatureBound : ℝ)
    (htime : 0 < timeStep)
    (hmesh : timeStep ≤ width)
    (hL : 0 ≤ L)
    (hcurvatureBound : 0 ≤ curvatureBound)
    (hfluxLip : ∀ u v, |flux u - flux v| ≤ L * |u - v|)
    (hpredictor :
      |leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0)) left right 0 -
        trace (timeStep / 2)| ≤ predictorBound * width ^ 2)
    (hsmooth : ContDiffOn ℝ 2
      (fun τ => flux (trace τ)) (Set.Icc 0 timeStep))
    (hcurvature : ∀ τ,
      |iteratedDerivWithin 2 (fun σ => flux (trace σ))
        (Set.Icc 0 timeStep) τ| ≤ curvatureBound) :
    |leveque04_richtmyerFlux timeStep width
        (fun state (_ : Fin 1) => flux (state 0)) left right 0 -
      oneDimensionalCellAverage (fun τ => flux (trace τ)) 0 timeStep| ≤
        (L * predictorBound + curvatureBound / 8) * width ^ 2 := by
  let predictor := leveque04_richtmyerPredictor timeStep width
    (fun state (_ : Fin 1) => flux (state 0)) left right 0
  let exactFlux := oneDimensionalCellAverage
    (fun τ => flux (trace τ)) 0 timeStep
  have hmid := leveque04_midpointError_secondOrder
    (fun τ => flux (trace τ)) 0 timeStep curvatureBound
    htime hsmooth hcurvature
  have hmid' : |flux (trace (timeStep / 2)) - exactFlux| ≤
      timeStep ^ 2 * curvatureBound / 8 := by
    simpa only [zero_add, zero_sub, sub_zero, abs_sub_comm,
      exactFlux] using hmid
  have htsq : timeStep ^ 2 ≤ width ^ 2 := by
    gcongr
  have hfirst : |flux predictor - flux (trace (timeStep / 2))| ≤
      L * (predictorBound * width ^ 2) := by
    exact (hfluxLip predictor (trace (timeStep / 2))).trans
      (mul_le_mul_of_nonneg_left hpredictor hL)
  have hsecond : timeStep ^ 2 * curvatureBound / 8 ≤
      width ^ 2 * curvatureBound / 8 := by
    gcongr
  change |flux predictor - exactFlux| ≤
    (L * predictorBound + curvatureBound / 8) * width ^ 2
  calc
    |flux predictor - exactFlux| =
        |(flux predictor - flux (trace (timeStep / 2))) +
          (flux (trace (timeStep / 2)) - exactFlux)| := by
            congr 1
            ring
    _ ≤ |flux predictor - flux (trace (timeStep / 2))| +
          |flux (trace (timeStep / 2)) - exactFlux| := abs_add_le _ _
    _ ≤ L * (predictorBound * width ^ 2) +
          timeStep ^ 2 * curvatureBound / 8 := by
        exact add_le_add hfirst hmid'
    _ ≤ L * (predictorBound * width ^ 2) +
          width ^ 2 * curvatureBound / 8 := by
        exact add_le_add_right hsecond _
    _ = (L * predictorBound + curvatureBound / 8) * width ^ 2 := by ring

end NumStability
