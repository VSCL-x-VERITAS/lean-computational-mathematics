/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Proof-free target for variable-velocity conservative advection

For an actual time derivative, density gradient, and velocity derivative, the
conservation-form equation is equivalent to its product-rule expansion. This
keeps the velocity-divergence term that distinguishes conserved linear density
from the nonconservative concentration equation later in the section.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.16), with its spatial product derivative made explicit. -/
def conservativeVariableAdvectionTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (velocity : ℝ → ℝ)
    (timeDerivative spatialDerivative velocityDerivative fluxDerivative x t : ℝ),
    HasDerivAt (fun τ => q x τ) timeDerivative t →
    HasDerivAt (fun ξ => q ξ t) spatialDerivative x →
    HasDerivAt velocity velocityDerivative x →
    (HasDerivAt (fun ξ => velocity ξ * q ξ t) fluxDerivative x ∧
        timeDerivative + fluxDerivative = 0 ↔
      timeDerivative + velocity x * spatialDerivative +
        velocityDerivative * q x t = 0)

end NumStability.Leveque02Tracer

