/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Constant-coefficient diffusion from Fick flux

Proof-free target for (2.21). The gradient field consists of actual first
spatial derivatives, and its actual derivative supplies the second derivative.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Fick flux with a constant coefficient gives the classical diffusion equation. -/
def constantDiffusionTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (gradient : ℝ → E) (qt qxx : E) (coefficient x t : ℝ)
    (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    (∀ ξ ∈ spaceDomain, UniqueDiffWithinAt ℝ spaceDomain ξ) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t →
    (∀ ξ ∈ spaceDomain, HasDerivWithinAt (fun z => q z t) (gradient ξ) spaceDomain ξ) →
    HasDerivWithinAt gradient qxx spaceDomain x →
    ((∃ fluxDerivative : E,
      HasDerivWithinAt (fun ξ => -(coefficient • gradient ξ)) fluxDerivative spaceDomain x ∧
      qt + fluxDerivative = 0) ↔ qt = coefficient • qxx)

end NumStability.Leveque02Tracer
