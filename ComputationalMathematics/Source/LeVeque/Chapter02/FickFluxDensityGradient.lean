/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFlux
import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxDensityGradientTarget

/-!
# Fick flux of an actual density gradient

This source wrapper connects the spatial derivative to the existing scalar
constitutive flux. It reuses the already proved flux formula.
-/

namespace NumStability.Leveque02Tracer

/-- Fick's flux formula for the actual spatial derivative of a scalar density. -/
theorem fickFluxDensityGradient : fickFluxDensityGradientTarget := by
  intro q coefficient x t gradient hgradient
  rw [hgradient.deriv]
  exact fickFluxFormula coefficient gradient

end NumStability.Leveque02Tracer
