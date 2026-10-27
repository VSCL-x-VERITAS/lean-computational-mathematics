/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxDensityGradient

/-!
# LeVeque Chapter 4: physical flux for the diffusion equation

The text reuses the constitutive flux from Chapter 2, now evaluating the
diffusion coefficient at the spatial point where the gradient is taken.
-/

namespace NumStability

/-- At a spatial point, the diffusion flux is negative diffusivity times the
actual density gradient. This is the Chapter 4 use of Chapter 2's Fick law. -/
theorem leveque04_diffusionPhysicalFlux
    (q : ℝ → ℝ → ℝ) (diffusivity : ℝ → ℝ)
    (x t gradient : ℝ)
    (hgradient : HasDerivAt (fun ξ => q ξ t) gradient x) :
    Leveque02Tracer.fickFlux (diffusivity x)
      (deriv (fun ξ => q ξ t) x) =
        -(diffusivity x * gradient) := by
  exact Leveque02Tracer.fickFluxDensityGradient
    q (diffusivity x) x t gradient hgradient

end NumStability
