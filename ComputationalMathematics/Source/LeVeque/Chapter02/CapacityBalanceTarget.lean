/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Differential balance with a capacity-weighted conserved state

The actual time derivative of the weighted state and the actual spatial flux
derivative satisfy conservation exactly when the time-independent-capacity
form (2.27) does. This target stays in the source's scalar, one-dimensional,
classical setting and is proof-free.
-/

namespace NumStability.Leveque02Tracer

/-- Weighted-state conservation is equivalent to the capacity equation (2.27). -/
def capacityBalanceTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (capacity : ℝ → ℝ) (flux : ℝ → ℝ)
    (qt conservedRate fluxDerivative x t : ℝ),
    HasDerivAt (fun τ => q x τ) qt t →
    HasDerivAt (fun τ => capacity x * q x τ) conservedRate t →
    HasDerivAt (fun ξ => flux (q ξ t)) fluxDerivative x →
    (conservedRate + fluxDerivative = 0 ↔
      capacity x * qt + fluxDerivative = 0)

end NumStability.Leveque02Tracer
