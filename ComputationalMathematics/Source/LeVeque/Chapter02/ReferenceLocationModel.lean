/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Reference and current locations in planar elasticity

For a material point with reference coordinates `(x,y)`, the two coordinate
fields `X` and `Y` give its current location at time `t`. This definition only
records the reference-to-current map; displacement, velocity, strain and
constitutive laws are separate claims.
-/

namespace NumStability.Leveque02Tracer

/-- Current planar location of a material point given its reference location. -/
noncomputable def currentMaterialLocation
    (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ) : ℝ × ℝ :=
  (X x y t, Y x y t)

end NumStability.Leveque02Tracer
