/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Diffusion with a spatially varying coefficient

Proof-free target for (2.22). The complete coefficient-gradient product is
differentiated; the gradient and time derivative are actual field derivatives.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Variable Fick flux gives the spatial derivative of the full coefficient-gradient product. -/
def variableDiffusionTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (gradient : ℝ → E) (qt : E) (coefficient : ℝ → ℝ)
    (x t : ℝ) (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    (∀ ξ ∈ spaceDomain, UniqueDiffWithinAt ℝ spaceDomain ξ) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t →
    (∀ ξ ∈ spaceDomain, HasDerivWithinAt (fun z => q z t) (gradient ξ) spaceDomain ξ) →
    ((∃ fluxDerivative : E,
      HasDerivWithinAt (fun ξ => -(coefficient ξ • gradient ξ)) fluxDerivative spaceDomain x ∧
      qt + fluxDerivative = 0) ↔
      HasDerivWithinAt (fun ξ => coefficient ξ • gradient ξ) qt spaceDomain x)

end NumStability.Leveque02Tracer
