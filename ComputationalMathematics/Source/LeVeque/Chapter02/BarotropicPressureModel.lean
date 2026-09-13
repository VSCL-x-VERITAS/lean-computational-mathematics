/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Density-only pressure closure

For the special fluid models of Section 2.6, a supplied equation of state
determines pressure from density alone. This definition records that closure;
it does not assert physical admissibility or derivative positivity for an
arbitrary pressure function.
-/

namespace NumStability.Leveque02Tracer

/-- Pressure field determined by a given function of fluid density. -/
noncomputable def barotropicPressure
    (pressureLaw : ℝ → ℝ) (density : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  pressureLaw (density x t)

end NumStability.Leveque02Tracer
