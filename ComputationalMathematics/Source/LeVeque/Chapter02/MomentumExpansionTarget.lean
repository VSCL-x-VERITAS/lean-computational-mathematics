/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Momentum expansion about a constant background
-/

namespace NumStability.Leveque02Tracer

/-- The exact density--velocity product expansion preceding the momentum first
variation on page 28. -/
def momentumExpansionTarget : Prop :=
  ∀ (densityBackground velocityBackground densityPerturbation velocityPerturbation : ℝ),
    (densityBackground + densityPerturbation) *
        (velocityBackground + velocityPerturbation) =
      densityBackground * velocityBackground +
        densityPerturbation * velocityBackground +
        densityBackground * velocityPerturbation +
        densityPerturbation * velocityPerturbation

end NumStability.Leveque02Tracer
