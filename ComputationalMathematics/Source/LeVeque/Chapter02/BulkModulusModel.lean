/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Linearized bulk modulus

The bulk modulus at a constant background density is the density times the
actual slope of the barotropic pressure law there.
-/

namespace NumStability.Leveque02Tracer

/-- The acoustic bulk modulus determined by a pressure law and background
density. -/
noncomputable def acousticBulkModulus
    (pressureLaw : ℝ → ℝ) (density : ℝ) : ℝ :=
  density * deriv pressureLaw density

end NumStability.Leveque02Tracer
