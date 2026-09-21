/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEquationTarget
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# LeVeque equation (2.25)

Differential conservation of thermal energy with Fourier flux gives the
positive spatial derivative of the conductivity-temperature-gradient product.
-/

namespace NumStability.Leveque02Tracer

/-- Fourier energy conservation yields `(kappa * q)_t = (beta * q_x)_x`. -/
theorem heatEquation : heatEquationTarget := by
  intro temperature capacity conductivity gradient energyRate fluxDerivative
    productDerivative x t _henergy _hgradient hflux hconservation hproduct
  have hfourier : HasDerivAt
      (fun ξ => fourierHeatFlux (conductivity ξ) (gradient ξ))
      (-productDerivative) x := by
    unfold fourierHeatFlux
    change HasDerivAt (-fun ξ => conductivity ξ * gradient ξ) (-productDerivative) x
    exact HasDerivAt.neg hproduct
  have hfluxValue : fluxDerivative = -productDerivative := hflux.unique hfourier
  linarith

end NumStability.Leveque02Tracer
