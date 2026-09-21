/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import Mathlib.Data.Matrix.Mul

/-!
# Reaction, advection and species-dependent diffusion

The common advective velocity gives a repeated diagonal coefficient. The
diffusion matrix is diagonal, allowing a separate constant diffusivity for
each species; scalar diffusion is its constant-diagonal case. The actual
combined flux and kinetic source give the displayed system (2.30).
-/

open Set

namespace NumStability.Leveque02Tracer

/-- A conservative balance with advective and diffusive fluxes gives the
reaction-advection-diffusion system for a nonempty family of species. -/
def reactionDiffusionTarget : Prop :=
  ∀ (m : ℕ) (q : ℝ → ℝ → (Fin m → ℝ)) (gradient : ℝ → (Fin m → ℝ))
    (qt qxx : Fin m → ℝ) (velocity : ℝ) (diffusivity : Fin m → ℝ)
    (production : (Fin m → ℝ) → (Fin m → ℝ)) (x t : ℝ) (spaceDomain : Set ℝ),
    0 < m → IsOpen spaceDomain → x ∈ spaceDomain →
    HasDerivAt (fun τ => q x τ) qt t →
    (∀ ξ ∈ spaceDomain, HasDerivAt (fun z => q z t) (gradient ξ) ξ) →
    HasDerivAt gradient qxx x →
    let advection : Matrix (Fin m) (Fin m) ℝ := Matrix.diagonal (fun _ => velocity)
    let diffusion : Matrix (Fin m) (Fin m) ℝ := Matrix.diagonal diffusivity
    (∃ fluxDerivative : Fin m → ℝ,
      HasDerivAt (fun ξ => constantLinearFlux advection (q ξ t) -
        constantLinearFlux diffusion (gradient ξ)) fluxDerivative x ∧
      qt + fluxDerivative = production (q x t)) →
    qt + advection.mulVec (gradient x) = diffusion.mulVec qxx + production (q x t)

end NumStability.Leveque02Tracer
