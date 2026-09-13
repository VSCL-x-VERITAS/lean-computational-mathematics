/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains

/-!
# Constant flux and the advection equation

This proof-free target for (2.12) retains actual derivatives of the state and
its constant linear flux. The proposed extension to normed vector values and
relative domains requires independent statement-faithfulness review.
-/

namespace NumStability.Leveque02Tracer

/-- Conservation with constant linear flux is equivalent to linear advection. -/
def constantFluxAdvectionTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
      (field : ℝ → ℝ → E) (velocity x t : ℝ) (spatialDerivative : E)
      (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    UniqueDiffWithinAt ℝ spaceDomain x →
    HasDerivWithinAt (fun ξ => field ξ t) spatialDerivative spaceDomain x →
    ((∃ qt fluxDerivative : E,
        HasDerivWithinAt (fun τ => field x τ) qt timeDomain t ∧
        HasDerivWithinAt (fun ξ => velocity • field ξ t) fluxDerivative spaceDomain x ∧
        qt + fluxDerivative = 0) ↔
      IsLinearAdvectionSolutionWithinAt field velocity x t spaceDomain timeDomain)

end NumStability.Leveque02Tracer
