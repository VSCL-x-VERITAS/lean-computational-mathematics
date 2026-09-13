/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.EndpointFluxModel

/-!
# Proof-free target for the endpoint flux-sign convention

F₁ and F₂ are the time-dependent signed rightward fluxes at the left and right
endpoints of an ordered pipe segment. The identities recover the signed
influxes +F₁ and -F₂ used in the explanation of (2.2).
-/

namespace NumStability.Leveque02Tracer

/-- The two endpoint influx signs in the explanation surrounding (2.2). -/
def endpointFluxSignTarget : Prop :=
  ∀ (leftFlux rightFlux : ℝ → ℝ) (t : ℝ),
    endpointInflux false (leftFlux t) = leftFlux t ∧
      endpointInflux true (rightFlux t) = -rightFlux t ∧
      ∀ F : ℝ, (0 < F → |F| = F) ∧ (F < 0 → |F| = -F)

end NumStability.Leveque02Tracer
