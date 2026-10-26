/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerSmoothFaceError

/-!
# Spatial derivative of the nonlinear Richtmyer interface flux

For smoothly varying neighboring scalar states, the derivative of
the actual equation-(4.23) predictor and equation-(4.22) face flux is
given by the chain rule. Bounds on this expression can later supply
the quadratic face-error derivative required by the nonlinear residual.
-/

namespace NumStability

/-- The spatial derivative of the actual scalar Richtmyer predictor
on two differentiable neighboring state profiles. -/
theorem leveque04_richtmyerScalarPredictor_hasDerivAt
    (flux flux' left right left' right' : ℝ → ℝ)
    (timeStep width x : ℝ)
    (hleft : HasDerivAt left (left' x) x)
    (hright : HasDerivAt right (right' x) x)
    (hfluxLeft : HasDerivAt flux (flux' (left x)) (left x))
    (hfluxRight : HasDerivAt flux (flux' (right x)) (right x)) :
    HasDerivAt
      (fun y => leveque04_richtmyerPredictor timeStep width
        (fun state (_ : Fin 1) => flux (state 0))
        (fun _ => left y) (fun _ => right y) 0)
      ((left' x + right' x) / 2 -
        timeStep / (2 * width) *
          (flux' (right x) * right' x - flux' (left x) * left' x)) x := by
  have hL := hfluxLeft.comp x hleft
  have hR := hfluxRight.comp x hright
  have hsum := (hleft.add hright).const_mul (1 / 2 : ℝ)
  have hdiff := (hR.sub hL).const_mul (timeStep / (2 * width))
  have h := hsum.sub hdiff
  convert h using 1
  ring

/-- The actual scalar Richtmyer numerical flux has the derivative
obtained by evaluating the physical-flux derivative at the predictor. -/
theorem leveque04_richtmyerScalarFlux_hasDerivAt
    (flux flux' left right left' right' : ℝ → ℝ)
    (timeStep width x : ℝ)
    (hleft : HasDerivAt left (left' x) x)
    (hright : HasDerivAt right (right' x) x)
    (hflux : ∀ z, HasDerivAt flux (flux' z) z) :
    HasDerivAt
      (fun y => leveque04_richtmyerFlux timeStep width
        (fun state (_ : Fin 1) => flux (state 0))
        (fun _ => left y) (fun _ => right y) 0)
      (flux' (leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => left x) (fun _ => right x) 0) *
        ((left' x + right' x) / 2 -
          timeStep / (2 * width) *
            (flux' (right x) * right' x -
              flux' (left x) * left' x))) x := by
  have hp := leveque04_richtmyerScalarPredictor_hasDerivAt
    flux flux' left right left' right' timeStep width x
    hleft hright (hflux _) (hflux _)
  simpa only [leveque04_richtmyerFlux] using
    (hflux _).comp x hp

end NumStability
