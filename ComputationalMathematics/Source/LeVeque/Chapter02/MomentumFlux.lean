/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumFluxTarget

/-!
# The momentum flux formula

The convective contribution transports the actual fluid momentum density.
Associativity and the square identity give the displayed density-times-squared-
velocity term; pressure remains the other contribution.
-/

namespace NumStability.Leveque02Tracer

/-- Convective momentum transport plus pressure has the source's stated form. -/
theorem momentumFlux : momentumFluxTarget := by
  intro density velocity pressure x t
  simp only [fluidMomentumFlux, fluidMomentumDensity, pow_two, mul_assoc]

end NumStability.Leveque02Tracer
