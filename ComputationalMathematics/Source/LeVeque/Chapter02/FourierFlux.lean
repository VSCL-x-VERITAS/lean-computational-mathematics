/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxTarget

/-!
# Fourier heat-flux formula

The Fourier constitutive model evaluates to negative thermal conductivity
times temperature gradient, with physical roles documented in FourierFluxModel.
-/

namespace NumStability.Leveque02Tracer

/-- The Fourier flux model has the defining value displayed in Section2.3. -/
theorem fourierHeatFluxFormula : fourierHeatFluxTarget := by
  intro conductivity temperatureGradient
  rfl

end NumStability.Leveque02Tracer
