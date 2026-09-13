/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Conservation with spatial capacity

Proof-free target for (2.27). The conserved state is capacity times the field,
while the flux is evaluated at the unweighted field. The capacity depends only
on space. The displayed differential law is selected independently of the
unresolved sign in the earlier printed integral balance.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Time-independent capacity converts conservation of the weighted state to (2.27). -/
def capacityConservationTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (capacity flux : ℝ → ℝ)
    (qt fluxDerivative x t : ℝ) (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    UniqueDiffWithinAt ℝ spaceDomain x → UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t →
    HasDerivWithinAt (fun ξ => flux (q ξ t)) fluxDerivative spaceDomain x →
    ((∃ energyRate : ℝ,
      HasDerivWithinAt (fun τ => capacity x * q x τ) energyRate timeDomain t ∧
      energyRate + fluxDerivative = 0) ↔
      capacity x * qt + fluxDerivative = 0)

end NumStability.Leveque02Tracer
