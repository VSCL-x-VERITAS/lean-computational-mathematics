/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# One-dimensional linear elastic shear-stress model

The constitutive law selects shear stress as a linear function of shear strain.
It is a material-model assumption, not a conclusion of kinematics.
-/

namespace NumStability.Leveque02Tracer

/-- Shear stress specified by the one-dimensional linear elastic law. -/
noncomputable def planeShearStress
    (shearModulus : ℝ) (shearStrain : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  2 * shearModulus * shearStrain x t

end NumStability.Leveque02Tracer
