/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerStateFluxDomainModel

/-!
# Proof-free domain-aware target for LeVeque equation (2.4)
-/

namespace NumStability.Leveque02Tracer

/-- For each admitted position and time, the prescribed-velocity flux function
maps a nonnegative local linear-density state to signed velocity times state. -/
def domainAwareStateFluxProductTarget : Prop :=
  ∀ (spatialDomain temporalDomain : Set ℝ)
    (velocity : ℝ → ℝ → SignedFluidVelocity)
    (state : LinearMassDensity) (x t : ℝ),
    x ∈ spatialDomain → t ∈ temporalDomain →
    0 ≤ linearMassDensityValue state →
      rightwardTracerMassFluxValue (domainAwareStateFlux velocity state x t) =
        signedFluidVelocityValue (velocity x t) * linearMassDensityValue state

end NumStability.Leveque02Tracer
