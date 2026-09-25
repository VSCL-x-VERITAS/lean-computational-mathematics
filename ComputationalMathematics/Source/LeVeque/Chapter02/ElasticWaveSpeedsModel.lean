/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Sqrt

/-!
# Plane elastic wave speeds

The compressional and shear speeds use the material formulas displayed in
LeVeque equations (2.94) and (2.101). Their positivity regimes are handled by
the claims that use them.
-/

namespace NumStability.Leveque02Tracer

/-- Compressional-wave speed for Lamé parameters and density. -/
noncomputable def compressionalWaveSpeed
    (lameLambda shearModulus density : ℝ) : ℝ :=
  Real.sqrt ((lameLambda + 2 * shearModulus) / density)

/-- Shear-wave speed for shear modulus and density. -/
noncomputable def shearWaveSpeed
    (shearModulus density : ℝ) : ℝ :=
  Real.sqrt (shearModulus / density)

end NumStability.Leveque02Tracer
