/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Actual derivatives along advection characteristics

This proof-free target for (2.14) retains a joint derivative of the field, the
advection equation expressed through actual partial derivative witnesses, and
the domain of the characteristic. Unique differentiability of the coordinate
slices identifies those partial derivatives with the joint derivative.

The value space is a real normed vector space. The source's scalar case is its
specialization to real values; the additional scope requires independent audit.
-/

namespace NumStability.Leveque02Tracer

/-- The actual characteristic derivative vanishes for a differentiable advection field. -/
def characteristicDerivativeTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
      (field : ℝ → ℝ → E) (jointDerivative : (ℝ × ℝ) →L[ℝ] E)
      (velocity origin t : ℝ) (spaceDomain timeDomain characteristicTimes : Set ℝ),
    t ∈ characteristicTimes →
    Set.MapsTo (fun τ => (origin + velocity * τ, τ)) characteristicTimes
      (Set.prod spaceDomain timeDomain) →
    UniqueDiffWithinAt ℝ spaceDomain (origin + velocity * t) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasFDerivWithinAt (Function.uncurry field) jointDerivative
      (Set.prod spaceDomain timeDomain) (origin + velocity * t, t) →
    IsLinearAdvectionSolutionWithinAt field velocity (origin + velocity * t) t
      spaceDomain timeDomain →
    HasDerivWithinAt (fun τ => field (origin + velocity * τ) τ) 0 characteristicTimes t

end NumStability.Leveque02Tracer
