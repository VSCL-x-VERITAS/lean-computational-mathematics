/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Temperature and internal energy density

In the one-dimensional material of Section2.3, temperature is the thermal
field and capacity is the heat capacity at a spatial point. Their product is
the internal energy density. It is this energy, rather than temperature itself,
that is conserved by endpoint energy flux in the thermal model. This definition
records the constitutive relation and does not impose a time-balance equation
on arbitrary temperature fields. Real coordinates carry these physical roles.
-/

namespace NumStability.Leveque02Tracer

/-- Internal energy density obtained from temperature and spatial heat capacity. -/
noncomputable def thermalEnergyDensity
    (capacity : ℝ → ℝ) (temperature : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  capacity x * temperature x t

end NumStability.Leveque02Tracer
