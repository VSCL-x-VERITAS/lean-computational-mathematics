/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFlux
import ComputationalMathematics.Source.LeVeque.Chapter02.FourierTemperatureGradientTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergy

/-!
# Fourier energy flux from the temperature gradient

This wrapper connects the constitutive formula to the actual spatial
temperature derivative and reuses the integrated energy and flux formulas.
-/

namespace NumStability.Leveque02Tracer

/-- The conserved energy density and its Fourier flux use different fields:
the flux input is the temperature gradient. -/
theorem fourierTemperatureGradient : fourierTemperatureGradientTarget := by
  intro temperature capacity conductivity x t gradient hgradient
  refine ⟨thermalEnergy capacity temperature x t, ?_⟩
  rw [hgradient.deriv]
  exact fourierHeatFluxFormula (conductivity x) gradient

end NumStability.Leveque02Tracer
