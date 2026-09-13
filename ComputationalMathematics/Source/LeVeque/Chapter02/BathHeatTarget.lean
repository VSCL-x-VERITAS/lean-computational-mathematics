/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Heat conduction in a constant-temperature bath

The exchange source is proportional to bath temperature minus rod temperature.
The coefficient and bath temperature are fixed. Actual classical Fourier
balance yields the source equation of Section 2.5.1, with feedback dependence
on the temperature retained explicitly.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- A constant-temperature bath contributes the exchange term to classical heat balance. -/
def bathHeatTarget : Prop :=
  ∀ (temperature : ℝ → ℝ → ℝ) (gradient : ℝ → ℝ)
    (conductivity exchange bathTemperature qt qxx fluxDerivative x t : ℝ)
    (spaceDomain : Set ℝ),
    IsOpen spaceDomain → x ∈ spaceDomain →
    HasDerivAt (fun τ => temperature x τ) qt t →
    (∀ ξ ∈ spaceDomain,
      HasDerivAt (fun z => temperature z t) (gradient ξ) ξ) →
    HasDerivAt gradient qxx x →
    HasDerivAt (fun ξ => fourierHeatFlux conductivity (gradient ξ)) fluxDerivative x →
    qt + fluxDerivative = exchange * (bathTemperature - temperature x t) →
    qt = conductivity * qxx + exchange * (bathTemperature - temperature x t)

end NumStability.Leveque02Tracer
