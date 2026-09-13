/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Fick constitutive flux in one dimension

The gradient state is the spatial derivative of linear tracer density, rather
than the density itself. Flux is signed rightward tracer mass per time. The
coefficient is the diffusion coefficient; positive values give flux down the
gradient. This constitutive definition does not impose conservation or derive
the microscopic law. It records the flux model introduced in (2.20).
-/

namespace NumStability.Leveque02Tracer

/-- Fick flux as a function of the spatial-gradient state and diffusion coefficient. -/
noncomputable def fickFlux (coefficient gradient : ℝ) : ℝ :=
  -(coefficient * gradient)

end NumStability.Leveque02Tracer
