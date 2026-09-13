/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConservativeVariableAdvectionExistentialTarget

/-!
# Variable-velocity conservative advection

The actual derivative of the product flux `u(x) q(x,t)` expands by the product
rule. This yields the velocity-divergence term in LeVeque equation (2.16).
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.16) is equivalent to its classical product-rule expansion. -/
theorem conservativeVariableAdvection :
    conservativeVariableAdvectionExistentialTarget := by
  intro q velocity timeDerivative spatialDerivative velocityDerivative x t
    htime hspace hvelocity
  have hproduct : HasDerivAt (fun ξ => velocity ξ * q ξ t)
      (velocityDerivative * q x t + velocity x * spatialDerivative) x :=
    hvelocity.mul hspace
  constructor
  · rintro ⟨fluxDerivative, hflux, hzero⟩
    have hvalue := hflux.unique hproduct
    rw [hvalue] at hzero
    linarith
  · intro hzero
    refine ⟨velocityDerivative * q x t + velocity x * spatialDerivative,
      hproduct, ?_⟩
    linarith

end NumStability.Leveque02Tracer

