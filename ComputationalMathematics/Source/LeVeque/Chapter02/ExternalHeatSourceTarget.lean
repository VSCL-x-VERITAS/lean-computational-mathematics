/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Heat conduction with an external source

Unit capacity identifies the temperature with conserved energy density.
Conductivity is constant and the prescribed external source depends on space
and time, independently of temperature. All rates and gradients below are
actual derivatives. This is a proof-free target for Section 2.5.1.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Fourier balance with prescribed external production gives the source heat equation. -/
def externalHeatSourceTarget : Prop :=
  ∀ (temperature source : ℝ → ℝ → ℝ) (gradient : ℝ → ℝ)
    (conductivity qt qxx fluxDerivative x t : ℝ) (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    (∀ ξ ∈ spaceDomain, UniqueDiffWithinAt ℝ spaceDomain ξ) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => temperature x τ) qt timeDomain t →
    (∀ ξ ∈ spaceDomain,
      HasDerivWithinAt (fun z => temperature z t) (gradient ξ) spaceDomain ξ) →
    HasDerivWithinAt gradient qxx spaceDomain x →
    HasDerivWithinAt (fun ξ => fourierHeatFlux conductivity (gradient ξ))
      fluxDerivative spaceDomain x →
    qt + fluxDerivative = source x t →
    qt = conductivity * qxx + source x t

end NumStability.Leveque02Tracer
