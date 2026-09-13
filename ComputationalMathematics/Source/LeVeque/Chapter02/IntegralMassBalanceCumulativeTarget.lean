/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CumulativeSectionConservationModel

/-!
# Cumulative proof-free target for LeVeque equation (2.2)

The finite-time conservation premise contains no derivative conclusion. The
target differentiates accumulated signed endpoint transport to obtain the
instantaneous fixed-section balance.
-/

namespace NumStability.Leveque02Tracer

/-- Cumulative endpoint-only mass change implies the differential balance (2.2). -/
def integralMassBalanceCumulativeTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (leftFlux rightFlux : ℝ → ℝ) (a b t : ℝ),
    IsCumulativeSectionConservation q leftFlux rightFlux a b t →
    IsSectionMassConservationAt q leftFlux rightFlux a b t

end NumStability.Leveque02Tracer

