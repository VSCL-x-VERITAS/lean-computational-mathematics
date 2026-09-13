/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReactionDiffusionTarget

/-!
# Reaction, advection, and species-dependent diffusion

The derivative of the combined constant-linear advective and diffusive flux is
equivalent to the displayed reaction-advection-diffusion balance.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.30) in matrix flux and expanded balance forms. -/
theorem reactionDiffusion : reactionDiffusionTarget := by
  intro m q gradient qt qxx velocity diffusivity production x t spaceDomain
    hOpen hx htime hspace hgradient
  dsimp only
  let advection : Matrix (Fin m) (Fin m) ℝ := Matrix.diagonal (fun _ => velocity)
  let diffusion : Matrix (Fin m) (Fin m) ℝ := Matrix.diagonal diffusivity
  have hadvection : HasDerivAt
      (fun ξ => constantLinearFlux advection (q ξ t))
      (advection.mulVec (gradient x)) x :=
    hasDerivAt_constantLinearFlux_comp advection (fun ξ => q ξ t)
      (gradient x) x (hspace x hx)
  have hdiffusion : HasDerivAt
      (fun ξ => constantLinearFlux diffusion (gradient ξ))
      (diffusion.mulVec qxx) x :=
    hasDerivAt_constantLinearFlux_comp diffusion gradient qxx x hgradient
  have hcombined := hadvection.sub hdiffusion
  constructor
  · rintro ⟨fluxDerivative, hflux, hbalance⟩
    have hvalue := hflux.unique hcombined
    rw [hvalue] at hbalance
    have hsub : qt + advection.mulVec (gradient x) - diffusion.mulVec qxx =
        production (q x t) := by
      simpa [sub_eq_add_neg, add_assoc] using hbalance
    simpa [advection, diffusion, Matrix.mulVec_diagonal, add_comm] using
      (sub_eq_iff_eq_add.mp hsub)
  · intro hsystem
    refine ⟨advection.mulVec (gradient x) - diffusion.mulVec qxx, hcombined, ?_⟩
    have hsub : qt + advection.mulVec (gradient x) - diffusion.mulVec qxx =
        production (q x t) :=
      sub_eq_iff_eq_add.mpr (by
        simpa [advection, diffusion, Matrix.mulVec_diagonal, add_comm] using hsystem)
    simpa [sub_eq_add_neg, add_assoc] using hsub

end NumStability.Leveque02Tracer
