/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Translated profiles on explicit domains

This proof-free target for the forward assertion of (2.13) records spatial,
temporal, and profile domains explicitly. Their compatibility ensures that
each translated argument lies in the profile domain. Actual derivatives
within these sets express both interior and one-sided interpretations.

The proposed generalization requires only a profile derivative at the chosen
point. Independent audit must establish source applicability and the claimed
increase in regularity scope before a correspondence theorem is added.
-/

namespace NumStability.Leveque02Tracer

/-- Compatible domain slices give actual partial derivatives satisfying advection. -/
def advectionWithinProfileTarget : Prop :=
  ∀ (profile : ℝ → ℝ) (profileDerivative velocity x t : ℝ)
      (spaceDomain timeDomain profileDomain : Set ℝ),
    x ∈ spaceDomain → t ∈ timeDomain →
    Set.MapsTo (fun ξ => ξ - velocity * t) spaceDomain profileDomain →
    Set.MapsTo (fun τ => x - velocity * τ) timeDomain profileDomain →
    HasDerivWithinAt profile profileDerivative profileDomain (x - velocity * t) →
      ∃ qt qx : ℝ,
        HasDerivWithinAt (fun τ => travelingWave profile velocity x τ) qt timeDomain t ∧
        HasDerivWithinAt (fun ξ => travelingWave profile velocity ξ t) qx spaceDomain x ∧
        qt + velocity * qx = 0

end NumStability.Leveque02Tracer
