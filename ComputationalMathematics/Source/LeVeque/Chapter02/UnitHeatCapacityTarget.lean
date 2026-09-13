/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxModel
import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergyModel
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Unit heat capacity and diffusion

At identically unit capacity, energy equals temperature. The same actual
gradient therefore enters the Fourier and Fick laws, and the energy equation
is the temperature diffusion equation with the full conductivity-gradient
product differentiated. This is a proof-free target for independent audit.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Unit capacity identifies the energy, flux and differential-equation descriptions. -/
def unitHeatCapacityTarget : Prop :=
  ∀ (temperature : ℝ → ℝ → ℝ) (conductivity gradient : ℝ → ℝ)
    (productDerivative x t : ℝ) (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    (∀ ξ ∈ spaceDomain, UniqueDiffWithinAt ℝ spaceDomain ξ) →
    UniqueDiffWithinAt ℝ timeDomain t →
    (∀ ξ ∈ spaceDomain,
      HasDerivWithinAt (fun z => temperature z t) (gradient ξ) spaceDomain ξ) →
    HasDerivWithinAt (fun ξ => conductivity ξ * gradient ξ)
      productDerivative spaceDomain x →
    (∀ ξ τ, thermalEnergyDensity (fun _ => 1) temperature ξ τ = temperature ξ τ) ∧
    (∀ ξ ∈ spaceDomain,
      HasDerivWithinAt (fun z => thermalEnergyDensity (fun _ => 1) temperature z t)
        (gradient ξ) spaceDomain ξ) ∧
    fourierHeatFlux (conductivity x) (gradient x) =
      fickFlux (conductivity x) (gradient x) ∧
    (HasDerivWithinAt (fun τ => thermalEnergyDensity (fun _ => 1) temperature x τ)
      productDerivative timeDomain t ↔
      HasDerivWithinAt (fun τ => temperature x τ) productDerivative timeDomain t)

end NumStability.Leveque02Tracer
