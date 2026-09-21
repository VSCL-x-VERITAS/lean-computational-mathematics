/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxDomainModel

/-!
# Proof-free domain-aware target for LeVeque equation (2.3)
-/

namespace NumStability.Leveque02Tracer

/-- At every admitted pipe position and time, signed tracer flux is prescribed
velocity times nonnegative linear tracer density. -/
def domainAwareFluxProductTarget : Prop :=
  ∀ (spatialDomain temporalDomain : Set ℝ)
    (velocity : ℝ → ℝ → SignedFluidVelocity)
    (density : ℝ → ℝ → LinearMassDensity) (x t : ℝ),
    x ∈ spatialDomain → t ∈ temporalDomain →
    0 ≤ linearMassDensityValue (density x t) →
      rightwardTracerMassFluxValue (domainAwareTracerFlux velocity density x t) =
        signedFluidVelocityValue (velocity x t) *
          linearMassDensityValue (density x t)

end NumStability.Leveque02Tracer
