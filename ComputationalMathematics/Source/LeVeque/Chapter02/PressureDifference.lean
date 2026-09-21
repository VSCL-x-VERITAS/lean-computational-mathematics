/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureDifferenceTarget

/-!
# Endpoint pressure contribution

Expanding the established momentum-flux model separates the signed endpoint
flux difference into its convective and pressure parts.  Equal endpoint
pressures then cancel the pressure part.
-/

namespace NumStability.Leveque02Tracer

/-- Only the endpoint pressure difference contributes through the pressure
part of the signed momentum-flux difference. -/
theorem pressureDifference : pressureDifferenceTarget := by
  intro density velocity pressure a b t
  constructor
  · simp only [fluidMomentumFlux, fluidMomentumDensity, pow_two]
    ring
  · intro hpressure
    simp only [fluidMomentumFlux, fluidMomentumDensity, pow_two]
    rw [hpressure]
    ring

end NumStability.Leveque02Tracer
