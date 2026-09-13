/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target for the variable-velocity characteristic equation

The target records equation (2.17) and its initial condition on a time domain
where the actual derivative is unique. It does not add a global ODE existence
or uniqueness theorem, whose hypotheses are not specified in the source.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.17) expressed using the actual derivative on its time domain. -/
def variableVelocityCharacteristicEquationTarget : Prop :=
  ∀ (velocity curve : ℝ → ℝ) (initialPoint : ℝ) (timeDomain : Set ℝ),
    0 ∈ timeDomain →
    curve 0 = initialPoint →
    (∀ t ∈ timeDomain, UniqueDiffWithinAt ℝ timeDomain t) →
    (∀ t ∈ timeDomain,
      HasDerivWithinAt curve (velocity (curve t)) timeDomain t) →
    curve 0 = initialPoint ∧
      ∀ t ∈ timeDomain,
        derivWithin curve timeDomain t = velocity (curve t)

end NumStability.Leveque02Tracer
