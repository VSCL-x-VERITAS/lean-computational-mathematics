/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AdvectionDiffusionTarget
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# Combined advection and diffusion

The derivative of the actual combined flux converts differential conservation
to the constant-coefficient advection-diffusion equation.
-/

namespace NumStability.Leveque02Tracer

/-- The advective and diffusive flux contributions give equation (2.23). -/
theorem advectionDiffusion : advectionDiffusionTarget := by
  intro E _ _ q gradient qt qxx velocity coefficient x t S T hx _ht
    hspace _htime _hqt hgradient hsecond
  have hflux : HasDerivWithinAt (fun ξ => velocity • q ξ t - coefficient • gradient ξ)
      (velocity • gradient x - coefficient • qxx) S x :=
    ((hgradient x hx).const_smul velocity).sub (hsecond.const_smul coefficient)
  have hresidual : qt + (velocity • gradient x - coefficient • qxx) = 0 ↔
      qt + velocity • gradient x = coefficient • qxx := by
    rw [← add_sub_assoc, sub_eq_zero]
  constructor
  · rintro ⟨fd, hderiv, hzero⟩
    have hvalue := (hspace x hx).eq_deriv _ hderiv hflux
    rw [hvalue] at hzero
    exact hresidual.mp hzero
  · intro hvalue
    exact ⟨_, hflux, hresidual.mpr hvalue⟩

end NumStability.Leveque02Tracer
