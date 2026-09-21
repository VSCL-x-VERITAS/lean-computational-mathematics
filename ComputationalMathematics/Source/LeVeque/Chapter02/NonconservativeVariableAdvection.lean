/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonconservativeVariableAdvectionTarget

/-!
# LeVeque equation (2.19)

The existing pointwise linear-advection predicate, specialized to the local
speed `u(x)`, is exactly the nonconservative variable-velocity equation for
the actual partial derivatives.
-/

namespace NumStability.Leveque02Tracer

/-- Nonconservative variable-velocity advection has the form `q_t + u(x) q_x = 0`. -/
theorem nonconservativeVariableAdvection : nonconservativeVariableAdvectionTarget := by
  intro E _ _ q velocity x t qt qx spaceDomain timeDomain _hx _ht
    hspaceUnique htimeUnique hqt hqx
  constructor
  · rintro ⟨qt', qx', hqt', hqx', hzero⟩
    rw [htimeUnique.eq_deriv _ hqt' hqt, hspaceUnique.eq_deriv _ hqx' hqx] at hzero
    exact hzero
  · intro hzero
    exact ⟨qt, qx, hqt, hqx, hzero⟩

end NumStability.Leveque02Tracer
