/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReactionDiffusionTarget

/-!
# LeVeque Chapter 2: ScalarReactionDiffusionTarget

Target for the componentwise reaction-diffusion equation.
-/

open Set
namespace NumStability.Leveque02Tracer

def scalarReactionDiffusionTarget : Prop :=
  ∀ (m : ℕ) (q : ℝ → ℝ → (Fin m → ℝ)) (gradient : ℝ → (Fin m → ℝ))
    (qt qxx : Fin m → ℝ) (velocity diffusivity : ℝ)
    (production : (Fin m → ℝ) → (Fin m → ℝ)) (x t : ℝ) (spaceDomain : Set ℝ),
    0 < m → IsOpen spaceDomain → x ∈ spaceDomain →
    HasDerivAt (fun τ => q x τ) qt t →
    (∀ ξ ∈ spaceDomain, HasDerivAt (fun z => q z t) (gradient ξ) ξ) →
    HasDerivAt gradient qxx x →
    let advection : Matrix (Fin m) (Fin m) ℝ := Matrix.diagonal (fun _ => velocity)
    let diffusion : Matrix (Fin m) (Fin m) ℝ := Matrix.diagonal (fun _ => diffusivity)
    (∃ fluxDerivative : Fin m → ℝ,
      HasDerivAt (fun ξ => constantLinearFlux advection (q ξ t) -
        constantLinearFlux diffusion (gradient ξ)) fluxDerivative x ∧
      qt + fluxDerivative = production (q x t)) →
    qt + advection.mulVec (gradient x) =
      diffusivity • qxx + production (q x t)

end NumStability.Leveque02Tracer
