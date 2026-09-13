/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumModel

/-!
# Convective and pressure contributions to momentum flux

The source fluid model transports its momentum density at the local velocity
and adds the pressure contribution. Real coordinates retain the distinct
roles of fluid mass density, signed velocity, momentum density and pressure.
This constitutive definition does not impose a balance equation on arbitrary
fields.
-/

namespace NumStability.Leveque02Tracer

/-- Total momentum flux from convective transport and pressure. -/
noncomputable def fluidMomentumFlux
    (density velocity pressure : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  fluidMomentumDensity density velocity x t * velocity x t + pressure x t

end NumStability.Leveque02Tracer
