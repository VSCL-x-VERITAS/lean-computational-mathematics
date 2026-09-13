/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel

/-!
# Fourier heat-flux definition correspondence

The source constitutive function acts on temperature-gradient states and
returns energy flux. Its inputs do not represent the energy-density gradient.
-/

namespace NumStability.Leveque02Tracer

/-- Fourier heat flux is negative conductivity times temperature gradient. -/
def fourierHeatFluxTarget : Prop :=
  ∀ (conductivity temperatureGradient : ℝ),
    fourierHeatFlux conductivity temperatureGradient = -(conductivity * temperatureGradient)

end NumStability.Leveque02Tracer
