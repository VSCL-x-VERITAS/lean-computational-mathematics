/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergyModel
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target for Fourier flux of an actual temperature gradient

The conserved density is heat capacity times temperature. The Fourier energy
flux uses the temperature gradient, even when that density has a different
spatial derivative.
-/

namespace NumStability.Leveque02Tracer

/-- Internal energy and Fourier flux at an actual one-dimensional temperature
gradient in Section 2.3. -/
def fourierTemperatureGradientTarget : Prop :=
  ∀ (temperature : ℝ → ℝ → ℝ) (capacity conductivity : ℝ → ℝ)
    (x t gradient : ℝ),
    HasDerivAt (fun ξ => temperature ξ t) gradient x →
      thermalEnergyDensity capacity temperature x t =
          capacity x * temperature x t ∧
        fourierHeatFlux (conductivity x) (deriv (fun ξ => temperature ξ t) x) =
          -(conductivity x * gradient)

end NumStability.Leveque02Tracer
