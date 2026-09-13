/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxModel

/-!
# Constant-velocity flux without a density-domain restriction

LeVeque (2.5) specializes f(q,x,t) = u(x,t)q to constant velocity. The
algebraic specialization is valid for every real state. In the physical
tracer model q is mass per length; negative real states are an algebraic
extension of the same product convention. This target imposes no sign
premise and therefore retains either reading of the unspecified state domain.
-/

namespace NumStability.Leveque02Tracer

/-- The constant-velocity product is independent of position and time for all
real density states, including every physical nonnegative state. -/
def constantTracerFluxTarget : Prop :=
  ∀ (velocity state x t : ℝ),
    stateFlux (fun _ _ => velocity) state x t = velocity * state

end NumStability.Leveque02Tracer
