/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Time-independent heat capacity

Proof-free target for the reduction of (2.25) to (2.26). Temperature gradients
and both differentiated products are actual derivatives. The capacity depends
on space only. This target does not derive the preceding integral balance.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Removing time-independent heat capacity from the time derivative gives (2.26). -/
def heatCapacityTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (gradient : ℝ → E) (qt productDerivative : E)
    (capacity conductivity : ℝ → ℝ) (x t : ℝ) (spaceDomain timeDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    (∀ ξ ∈ spaceDomain, UniqueDiffWithinAt ℝ spaceDomain ξ) →
    UniqueDiffWithinAt ℝ timeDomain t →
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t →
    (∀ ξ ∈ spaceDomain, HasDerivWithinAt (fun z => q z t) (gradient ξ) spaceDomain ξ) →
    HasDerivWithinAt (fun ξ => conductivity ξ • gradient ξ)
      productDerivative spaceDomain x →
    (HasDerivWithinAt (fun τ => capacity x • q x τ) productDerivative timeDomain t ↔
      capacity x • qt = productDerivative)

end NumStability.Leveque02Tracer
