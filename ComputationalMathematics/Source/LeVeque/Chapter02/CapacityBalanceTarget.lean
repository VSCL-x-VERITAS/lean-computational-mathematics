/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Differential balance with a capacity-weighted conserved state

The actual time derivative of the weighted state and the actual spatial flux
derivative satisfy conservation. Time-independent capacity then gives the
displayed equation (2.27). The state space may be any real normed vector space;
the scalar material model is included. This target is proof-free.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Conservation of the weighted state gives the capacity equation (2.27). -/
def capacityBalanceTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (capacity : ℝ → ℝ) (flux : E → E)
    (qt conservedRate fluxDerivative : E) (x t : ℝ)
    (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    UniqueDiffWithinAt ℝ spaceDomain x → UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t →
    HasDerivWithinAt (fun τ => capacity x • q x τ) conservedRate timeDomain t →
    HasDerivWithinAt (fun ξ => flux (q ξ t)) fluxDerivative spaceDomain x →
    conservedRate + fluxDerivative = 0 →
    capacity x • qt + fluxDerivative = 0

end NumStability.Leveque02Tracer
