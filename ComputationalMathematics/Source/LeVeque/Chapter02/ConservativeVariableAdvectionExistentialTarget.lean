/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Revised proof-free target for variable-velocity conservative advection

The conservative side existentially binds its actual product-flux derivative.
This prevents an unrelated proposed derivative from changing the equivalence
and exposes precisely the product-rule expansion used after equation (2.16).
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.16), with the actual product-flux derivative existentially bound. -/
def conservativeVariableAdvectionExistentialTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (velocity : ℝ → ℝ)
    (timeDerivative spatialDerivative velocityDerivative x t : ℝ),
    HasDerivAt (fun τ => q x τ) timeDerivative t →
    HasDerivAt (fun ξ => q ξ t) spatialDerivative x →
    HasDerivAt velocity velocityDerivative x →
    ((∃ fluxDerivative : ℝ,
        HasDerivAt (fun ξ => velocity ξ * q ξ t) fluxDerivative x ∧
          timeDerivative + fluxDerivative = 0) ↔
      timeDerivative + velocity x * spatialDerivative +
        velocityDerivative * q x t = 0)

end NumStability.Leveque02Tracer

