/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxModel

/-!
# Proof-free correspondence target for LeVeque (2.4)

The state argument is linear tracer density, distinct from position and time.
Velocity is prescribed. The scalar output is signed rightward tracer mass per
time, as documented by `stateFlux` in the one-dimensional dilute-tracer model.
-/

namespace NumStability.Leveque02Tracer

/-- The flux function with explicit density-state, position, and time inputs. -/
def stateFluxTarget : Prop :=
  ∀ (velocity : ℝ → ℝ → ℝ) (state x t : ℝ),
    0 ≤ state → stateFlux velocity state x t = velocity x t * state

end NumStability.Leveque02Tracer
