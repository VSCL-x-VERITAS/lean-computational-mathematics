/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumFluxModel

/-!
# Endpoint pressure contribution

The pressure part of the momentum-flux difference is determined by the
pressures at the two endpoints.  In particular, equal endpoint pressures make
that contribution vanish.
-/

namespace NumStability.Leveque02Tracer

/-- The signed endpoint momentum-flux contribution splits into its convective
and pressure parts, and equal endpoint pressures remove the pressure part. -/
def pressureDifferenceTarget : Prop :=
  ∀ (density velocity pressure : ℝ → ℝ → ℝ) (a b t : ℝ),
    fluidMomentumFlux density velocity pressure a t -
          fluidMomentumFlux density velocity pressure b t =
        (density a t * velocity a t ^ 2 - density b t * velocity b t ^ 2) +
          (pressure a t - pressure b t) ∧
      (pressure a t = pressure b t →
        fluidMomentumFlux density velocity pressure a t -
            fluidMomentumFlux density velocity pressure b t =
          density a t * velocity a t ^ 2 - density b t * velocity b t ^ 2)

end NumStability.Leveque02Tracer
