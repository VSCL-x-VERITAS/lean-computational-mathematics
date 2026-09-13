/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Conservative transport along a variable-velocity characteristic

Proof-free target for (2.18). All field, velocity, and curve derivatives are
actual derivatives on their stated domains; no global ODE solvability is assumed.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- The actual material derivative in conservative transport is minus velocity divergence times state. -/
def variableVelocityCharacteristicTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (velocity curve : ℝ → ℝ)
    (F : (ℝ × ℝ) →L[ℝ] E) (velocityDerivative t : ℝ)
    (spaceDomain timeDomain characteristicTimes : Set ℝ),
    t ∈ characteristicTimes →
    MapsTo (fun τ => (curve τ, τ)) characteristicTimes (spaceDomain ×ˢ timeDomain) →
    UniqueDiffWithinAt ℝ spaceDomain (curve t) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasFDerivWithinAt (Function.uncurry q) F (spaceDomain ×ˢ timeDomain) (curve t, t) →
    HasDerivWithinAt velocity velocityDerivative spaceDomain (curve t) →
    HasDerivWithinAt curve (velocity (curve t)) characteristicTimes t →
    (∃ timeDerivative fluxDerivative : E,
      HasDerivWithinAt (fun τ => q (curve t) τ) timeDerivative timeDomain t ∧
      HasDerivWithinAt (fun x => velocity x • q x t) fluxDerivative spaceDomain (curve t) ∧
      timeDerivative + fluxDerivative = 0) →
    HasDerivWithinAt (fun τ => q (curve τ) τ)
      (-(velocityDerivative • q (curve t) t)) characteristicTimes t

end NumStability.Leveque02Tracer
