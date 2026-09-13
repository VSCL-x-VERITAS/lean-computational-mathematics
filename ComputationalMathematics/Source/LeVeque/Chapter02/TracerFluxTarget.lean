/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxModel

/-!
# Proof-free correspondence target for LeVeque (2.3)

The density field is linear tracer density in the prescribed one-dimensional
flow, and `tracerFlux` is signed rightward mass per time. The physical density
is nonnegative at the point under consideration. No regularity or time balance
assumptions are needed to introduce this local flux convention.
-/

namespace NumStability.Leveque02Tracer

/-- The advective tracer flux product at a physical density state. -/
def fluxProductTarget : Prop :=
  ∀ (velocity density : ℝ → ℝ → ℝ) (x t : ℝ),
    0 ≤ density x t →
      tracerFlux velocity density x t = velocity x t * density x t

end NumStability.Leveque02Tracer
