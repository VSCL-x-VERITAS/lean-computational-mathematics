/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Autonomous endpoint substitution in a section-mass balance

Proof-free target for the rewrite from equation (2.2) to equation (2.6).
The section mass is abstract here: specializing it to the displayed spatial
integral recovers the book equation without choosing an integration theory or
a convention for temporal boundary points.
-/

namespace NumStability.Leveque02Tracer

/-- Replacing the two endpoint fluxes by one autonomous state flux preserves
the derivative form of the section-mass balance on any time domain. -/
def autonomousMassBalanceRewriteTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux leftFlux rightFlux mass : ℝ → ℝ)
    (a b t : ℝ) (timeDomain : Set ℝ),
    a < b →
      t ∈ timeDomain →
        leftFlux t = flux (q a t) →
          rightFlux t = flux (q b t) →
            (HasDerivWithinAt mass (leftFlux t - rightFlux t) timeDomain t ↔
              HasDerivWithinAt mass
                (flux (q a t) - flux (q b t)) timeDomain t)

end NumStability.Leveque02Tracer
