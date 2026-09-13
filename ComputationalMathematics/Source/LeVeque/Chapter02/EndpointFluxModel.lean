/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Endpoint flux signs in LeVeque Chapter 2

For a pipe segment with ordered endpoints x₁ < x₂, the book defines F₁ and
F₂ as signed tracer mass fluxes past x₁ and x₂, both positive to the right.
Positive influx into the segment therefore equals F₁ at the left endpoint
and -F₂ at the right endpoint. A negative influx is an outflow.
The magnitude of a signed rightward flux F is |F|: it is F when F is
positive and -F when F is negative, in the latter case flowing leftward.

`atRightEndpoint = false` denotes the left endpoint x₁, and `true` denotes
the right endpoint x₂ of that ordered segment. `endpointInflux` converts a
signed rightward mass-per-time value to a signed inward mass-per-time value.
The sign convention is independent of the constitutive flux and does not
assert a time-evolution or conservation law.
-/

namespace NumStability.Leveque02Tracer

/-- Convert the book's rightward flux convention to influx at the selected
endpoint of an ordered pipe segment. -/
noncomputable def endpointInflux (atRightEndpoint : Bool) (rightwardFlux : ℝ) : ℝ :=
  if atRightEndpoint then -rightwardFlux else rightwardFlux

end NumStability.Leveque02Tracer
