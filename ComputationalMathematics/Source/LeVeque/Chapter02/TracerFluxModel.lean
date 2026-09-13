/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerMassModel

/-!
# Tracer flux in LeVeque (2.3)--(2.5)

In the prescribed one-dimensional dilute-tracer model, `velocity x t` is the
signed fluid velocity, positive to the right, measured in length per time.
The state argument of `stateFlux` and the field argument of `tracerFlux` are
linear tracer densities, measured in mass per length, after the area conversion
described by `linearDensity`. Their flux is signed tracer mass per time,
positive to the right. Negative velocity is permitted; physical density is
nonnegative. These are the physical roles of real coordinates in this model.

The source obtains the product by multiplying speed through a fixed point by
tracer mass per length. This is the advective flux convention for the specified
model; the definitions impose no differential balance law on arbitrary data.
The separate state argument preserves the source's distinction between the
flux function f(q,x,t) and its evaluation along a density field q(x,t).
-/

namespace NumStability.Leveque02Tracer

/-- The prescribed-velocity flux function of the linear tracer density state,
position, and time, as introduced in (2.4). -/
noncomputable def stateFlux (velocity : ℝ → ℝ → ℝ) (state x t : ℝ) : ℝ :=
  velocity x t * state

/-- Rightward tracer flux at a fixed spatial point, evaluated along a linear
tracer density field, as in (2.3). -/
noncomputable def tracerFlux
    (velocity density : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  stateFlux velocity (density x t) x t

end NumStability.Leveque02Tracer
