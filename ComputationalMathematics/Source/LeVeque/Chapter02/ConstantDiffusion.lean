/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConstantDiffusionTarget
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# LeVeque's constant-coefficient diffusion equation

Equation (2.21) follows by differentiating the actual Fick flux and identifying
its derivative on the physical spatial slice.
-/

namespace NumStability.Leveque02Tracer

/-- Constant Fick flux gives equation (2.21), with actual first and second spatial derivatives. -/
theorem constantDiffusion : constantDiffusionTarget := by
  intro E _ _ q gradient qt qxx coefficient x t spaceDomain timeDomain hx _ht
    hspace _htime _hqt _hgradient hsecond
  have hflux : HasDerivWithinAt (fun ξ => -(coefficient • gradient ξ))
      (-(coefficient • qxx)) spaceDomain x := (hsecond.const_smul coefficient).neg
  constructor
  · rintro ⟨fluxDerivative, hderiv, hzero⟩
    have hvalue := (hspace x hx).eq_deriv _ hderiv hflux
    rw [hvalue] at hzero
    exact eq_of_sub_eq_zero (by simpa only [sub_eq_add_neg] using hzero)
  · intro hvalue
    exact ⟨_, hflux, by rw [hvalue, add_neg_cancel]⟩

end NumStability.Leveque02Tracer
