/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassBalanceWithProductionModel

/-!
# Revised proof-free target for LeVeque equation (2.2)

The premise distinguishes endpoint transport from net production within the
fixed section. When the internal-production rate vanishes, the actual mass
derivative is exactly the left signed flux minus the right signed flux.
-/

namespace NumStability.Leveque02Tracer

/-- No internal creation or destruction reduces the section balance to (2.2). -/
def integralMassBalanceProductionTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (leftFlux rightFlux : ℝ → ℝ)
    (internalProduction a b t : ℝ),
    IsSectionMassBalanceWithProductionAt q leftFlux rightFlux
      internalProduction a b t →
    internalProduction = 0 →
    IsSectionMassConservationAt q leftFlux rightFlux a b t

end NumStability.Leveque02Tracer

