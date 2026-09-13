/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Material derivative along a particle curve

Proof-free correspondence for the operator following LeVeque (2.18).
-/

open Set

namespace NumStability.Leveque02Tracer

/-- The material derivative is the actual field derivative observed along a particle curve. -/
def materialDerivativeTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (velocity curve : ℝ → ℝ)
    (F : (ℝ × ℝ) →L[ℝ] E) (qt qx : E) (t : ℝ)
    (spaceDomain timeDomain characteristicTimes : Set ℝ),
    t ∈ characteristicTimes →
    MapsTo (fun τ => (curve τ, τ)) characteristicTimes (spaceDomain ×ˢ timeDomain) →
    UniqueDiffWithinAt ℝ spaceDomain (curve t) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasFDerivWithinAt (Function.uncurry q) F (spaceDomain ×ˢ timeDomain) (curve t, t) →
    HasDerivWithinAt (fun τ => q (curve t) τ) qt timeDomain t →
    HasDerivWithinAt (fun x => q x t) qx spaceDomain (curve t) →
    HasDerivWithinAt curve (velocity (curve t)) characteristicTimes t →
    HasDerivWithinAt (fun τ => q (curve τ) τ)
      (qt + velocity (curve t) • qx) characteristicTimes t

end NumStability.Leveque02Tracer
