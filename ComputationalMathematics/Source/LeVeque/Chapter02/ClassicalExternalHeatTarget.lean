/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Classical heat conduction with prescribed production

The field has an actual temperature gradient on an open neighborhood of the
observation point. All derivatives are ordinary classical derivatives.
Unit capacity and constant conductivity give the displayed source heat
equation from the differential energy balance in Section 2.5.1.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Classical Fourier balance with a prescribed external source yields the heat equation. -/
def classicalExternalHeatTarget : Prop :=
  ∀ (temperature source : ℝ → ℝ → ℝ) (gradient : ℝ → ℝ)
    (conductivity qt qxx fluxDerivative x t : ℝ) (spaceDomain : Set ℝ),
    IsOpen spaceDomain → x ∈ spaceDomain →
    HasDerivAt (fun τ => temperature x τ) qt t →
    (∀ ξ ∈ spaceDomain,
      HasDerivAt (fun z => temperature z t) (gradient ξ) ξ) →
    HasDerivAt gradient qxx x →
    HasDerivAt (fun ξ => fourierHeatFlux conductivity (gradient ξ)) fluxDerivative x →
    qt + fluxDerivative = source x t →
    qt = conductivity * qxx + source x t

end NumStability.Leveque02Tracer
