/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Fourier heat conduction flux

The input state is the spatial temperature gradient, and conductivity is the
thermal conductivity. The output is signed rightward internal-energy flux in
the one-dimensional thermal material of Section2.3. With positive conductivity,
the sign gives flow down the temperature gradient. When heat capacity varies,
the gradient of energy density differs from this temperature gradient and must
not be substituted. This definition records the Fourier constitutive model;
it does not derive microscopic physics or impose an energy balance on fields.
-/

namespace NumStability.Leveque02Tracer

/-- Fourier internal-energy flux at a temperature-gradient state. -/
noncomputable def fourierHeatFlux (conductivity temperatureGradient : ℝ) : ℝ :=
  -(conductivity * temperatureGradient)

end NumStability.Leveque02Tracer
