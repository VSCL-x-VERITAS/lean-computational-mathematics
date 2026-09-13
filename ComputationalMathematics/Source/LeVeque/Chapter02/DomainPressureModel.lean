/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Set.Basic

/-!
# Pressure closure on specified domains

The pressure law is given on its own density domain. The density field is
given on the model's space-time domain and takes values in that law domain.
No extension to vacuum, negative density or unused space-time points is
needed to evaluate pressure.
-/

namespace NumStability.Leveque02Tracer

/-- The given pressure law evaluated along a density field in its domain. -/
noncomputable def pressureOnDomains
    (densityDomain : Set ℝ) (spaceTimeDomain : Set (ℝ × ℝ))
    (pressureLaw : densityDomain → ℝ) (density : spaceTimeDomain → densityDomain)
    (location : spaceTimeDomain) : ℝ :=
  pressureLaw (density location)

end NumStability.Leveque02Tracer
