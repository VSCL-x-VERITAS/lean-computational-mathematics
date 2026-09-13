/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.VariableDiffusionTarget
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# Variable diffusion flux correspondence

The derivative of the complete coefficient-gradient product is the time rate
exactly when the negative Fick flux satisfies differential conservation.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.22) follows by reversing the sign of the actual Fick flux derivative. -/
theorem variableDiffusion : variableDiffusionTarget := by
  intro E _ _ q gradient qt coefficient x t S T _hx _ht _hs _hu _hqt _hg
  constructor
  · rintro ⟨fd, hflux, hzero⟩
    have hvalue : -fd = qt := (eq_neg_of_add_eq_zero_left hzero).symm
    have hfunction : (-(fun ξ => -(coefficient ξ • gradient ξ))) =
        (fun ξ => coefficient ξ • gradient ξ) := by
      funext ξ
      exact neg_neg _
    rw [← hfunction]
    exact hflux.neg.congr_deriv hvalue
  · intro hpositive
    exact ⟨-qt, hpositive.neg, add_neg_cancel qt⟩

end NumStability.Leveque02Tracer
