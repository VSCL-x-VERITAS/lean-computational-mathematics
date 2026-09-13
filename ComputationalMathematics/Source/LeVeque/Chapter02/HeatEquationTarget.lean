/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergyModel
import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Differential conservation of thermal energy

Proof-free target for the displayed equation (2.25). The time derivative is
of internal energy, while Fourier flux uses the actual temperature gradient.
This correspondence starts from differential energy conservation. The sign
in the preceding printed integral equation is a separate unresolved source issue.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Fourier energy conservation has the displayed differential heat-equation form. -/
def heatEquationTarget : Prop :=
  ∀ (temperature : ℝ → ℝ → ℝ) (capacity conductivity gradient : ℝ → ℝ)
    (energyRate x t : ℝ) (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    (∀ ξ ∈ spaceDomain, UniqueDiffWithinAt ℝ spaceDomain ξ) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => thermalEnergyDensity capacity temperature x τ)
      energyRate timeDomain t →
    (∀ ξ ∈ spaceDomain,
      HasDerivWithinAt (fun z => temperature z t) (gradient ξ) spaceDomain ξ) →
    ((∃ fluxDerivative : ℝ,
      HasDerivWithinAt (fun ξ => fourierHeatFlux (conductivity ξ) (gradient ξ))
        fluxDerivative spaceDomain x ∧ energyRate + fluxDerivative = 0) ↔
      HasDerivWithinAt (fun ξ => conductivity ξ * gradient ξ)
        energyRate spaceDomain x)

end NumStability.Leveque02Tracer
