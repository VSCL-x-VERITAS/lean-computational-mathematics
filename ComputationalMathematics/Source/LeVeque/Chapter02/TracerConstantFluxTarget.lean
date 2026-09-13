/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxModel

/-!
# Proof-free correspondence target for LeVeque (2.5)

The prescribed velocity is constant in position and time. Its signed tracer
flux therefore depends only on the linear-density state through multiplication
by that constant velocity. A velocity of either sign, including zero, is
allowed; the density state is physically nonnegative.
-/

namespace NumStability.Leveque02Tracer

/-- Constant-velocity specialization of the source's space-time flux. -/
def constantFluxTarget : Prop :=
  ∀ (velocity state x t : ℝ),
    0 ≤ state → stateFlux (fun _ _ => velocity) state x t = velocity * state

end NumStability.Leveque02Tracer
