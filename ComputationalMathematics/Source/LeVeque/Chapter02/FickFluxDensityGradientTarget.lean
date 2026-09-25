/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxModel
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target for the density-gradient form of Fick's law

The argument to the constitutive flux is the actual spatial derivative of the
one-dimensional density field at the selected space-time point.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.20) with its gradient state tied to the spatial derivative of
the scalar density. -/
def fickFluxDensityGradientTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (coefficient x t gradient : ℝ),
    HasDerivAt (fun ξ => q ξ t) gradient x →
      fickFlux coefficient (deriv (fun ξ => q ξ t) x) =
        -(coefficient * gradient)

end NumStability.Leveque02Tracer
