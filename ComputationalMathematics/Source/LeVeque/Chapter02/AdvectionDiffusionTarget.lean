/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Combined advection and diffusion

Proof-free target for (2.23), with the actual gradient and second derivative
linked to the field and both transport coefficients spatially constant.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- The combined advective and diffusive flux gives the advection-diffusion equation. -/
def advectionDiffusionTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (gradient : ℝ → E) (qt qxx : E)
    (velocity coefficient x t : ℝ) (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    (∀ ξ ∈ spaceDomain, UniqueDiffWithinAt ℝ spaceDomain ξ) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t →
    (∀ ξ ∈ spaceDomain, HasDerivWithinAt (fun z => q z t) (gradient ξ) spaceDomain ξ) →
    HasDerivWithinAt gradient qxx spaceDomain x →
    ((∃ fluxDerivative : E,
      HasDerivWithinAt (fun ξ => velocity • q ξ t - coefficient • gradient ξ)
        fluxDerivative spaceDomain x ∧ qt + fluxDerivative = 0) ↔
      qt + velocity • gradient x = coefficient • qxx)

end NumStability.Leveque02Tracer
