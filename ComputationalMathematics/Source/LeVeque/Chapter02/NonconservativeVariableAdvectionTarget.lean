/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains

/-!
# Proof-free target for nonconservative variable-velocity advection

Equation (2.19) uses the velocity evaluated at the spatial point as the local
advection speed. The target identifies the existing pointwise transport
predicate with the equation for fixed, actual partial derivatives.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.19), expressed through actual derivatives on spatial and temporal domains. -/
def nonconservativeVariableAdvectionTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
      (q : ℝ → ℝ → E) (velocity : ℝ → ℝ) (x t : ℝ)
      (qt qx : E)
      (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    UniqueDiffWithinAt ℝ spaceDomain x →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ ↦ q x τ) qt timeDomain t →
    HasDerivWithinAt (fun ξ ↦ q ξ t) qx spaceDomain x →
    (IsLinearAdvectionSolutionWithinAt q (velocity x) x t spaceDomain timeDomain ↔
      qt + velocity x • qx = 0)

end NumStability.Leveque02Tracer
