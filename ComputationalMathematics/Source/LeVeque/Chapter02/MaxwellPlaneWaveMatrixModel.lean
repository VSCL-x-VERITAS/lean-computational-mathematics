/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Constant transverse Maxwell coefficient matrix

The state order is electric amplitude followed by magnetic amplitude.
-/

namespace NumStability.Leveque02Tracer

/-- The coefficient matrix for the two-component transverse Maxwell system. -/
noncomputable def maxwellPlaneWaveCoefficient
    (permittivity permeability : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, 1 / (permittivity * permeability); 1, 0]

end NumStability.Leveque02Tracer
