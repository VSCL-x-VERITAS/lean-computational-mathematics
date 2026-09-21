/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassUnitsModel
import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxModel

/-!
# Domain-aware unit model for advective tracer flux

The source leaves the spatial pipe region and time domain unspecified. This
model therefore keeps both as explicit sets of real coordinates and only
interprets equation (2.3) at admitted points.
-/

namespace NumStability.Leveque02Tracer

/-- Signed fluid velocity, measured in length per time and positive to the right. -/
inductive SignedFluidVelocity where
  | ofReal (value : ℝ)

/-- Signed tracer-mass flux, measured in mass per time and positive to the right. -/
inductive RightwardTracerMassFlux where
  | ofReal (value : ℝ)

/-- The real coordinate of signed fluid velocity. -/
def signedFluidVelocityValue : SignedFluidVelocity → ℝ
  | .ofReal value => value

/-- The real coordinate of signed tracer-mass flux. -/
def rightwardTracerMassFluxValue : RightwardTracerMassFlux → ℝ
  | .ofReal value => value

/-- Typed equation (2.3), delegating its scalar computation to the integrated
`tracerFlux` producer. Its physical interpretation is restricted by target
hypotheses to the chosen spatial and temporal domains. -/
noncomputable def domainAwareTracerFlux
    (velocity : ℝ → ℝ → SignedFluidVelocity)
    (density : ℝ → ℝ → LinearMassDensity)
    (x t : ℝ) : RightwardTracerMassFlux :=
  .ofReal (tracerFlux
    (fun x' t' ↦ signedFluidVelocityValue (velocity x' t'))
    (fun x' t' ↦ linearMassDensityValue (density x' t')) x t)

end NumStability.Leveque02Tracer
