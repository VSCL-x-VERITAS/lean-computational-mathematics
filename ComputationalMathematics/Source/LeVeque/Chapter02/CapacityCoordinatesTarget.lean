/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityModel

/-!
# Capacity coordinate definition correspondence

Proof-free target for the conserved-coordinate and flux roles in Section 2.4.
-/

namespace NumStability.Leveque02Tracer

/-- Capacity weights the conserved coordinate while flux uses the unweighted state. -/
def capacityModelTarget : Prop :=
  ∀ (capacity state : ℝ) (flux : ℝ → ℝ),
    (capacityStateFlux capacity state flux).1 = capacity * state ∧
    (capacityStateFlux capacity state flux).2 = flux state

end NumStability.Leveque02Tracer
