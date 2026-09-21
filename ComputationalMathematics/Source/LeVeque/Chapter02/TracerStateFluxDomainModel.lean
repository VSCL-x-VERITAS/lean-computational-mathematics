/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxDomainModel

/-!
# Domain-aware unit model for the tracer state-flux function

This model preserves the separate local density-state, position, and time
arguments of LeVeque equation (2.4). Spatial and temporal extents remain target
hypotheses because the source does not fix them.
-/

namespace NumStability.Leveque02Tracer

/-- Typed equation (2.4), delegating its scalar computation to the integrated
`stateFlux` producer. -/
noncomputable def domainAwareStateFlux
    (velocity : ℝ → ℝ → SignedFluidVelocity)
    (state : LinearMassDensity) (x t : ℝ) : RightwardTracerMassFlux :=
  .ofReal (stateFlux
    (fun x' t' ↦ signedFluidVelocityValue (velocity x' t'))
    (linearMassDensityValue state) x t)

end NumStability.Leveque02Tracer
