/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Variable-velocity conservative advection

This pointwise classical predicate records equation (2.16). It states the
governing equation itself, rather than only its product-rule expansion.
-/

namespace NumStability.Leveque02Tracer

/-- The variable-velocity conservation equation `qₜ + (u(x) q)ₓ = 0`
at an interior space-time point. -/
def IsVariableVelocityConservationAt
    (q : ℝ → ℝ → ℝ) (velocity : ℝ → ℝ) (x t : ℝ) : Prop :=
  ∃ qt fluxDerivative : ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
    HasDerivAt (fun ξ => velocity ξ * q ξ t) fluxDerivative x ∧
    qt + fluxDerivative = 0

end NumStability.Leveque02Tracer
