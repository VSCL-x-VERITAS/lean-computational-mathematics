/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# One-dimensional longitudinal kinematics

For a material location `X(x,t)`, the strain is its spatial derivative minus
one, and the velocity is its time derivative. These are the one-dimensional
specializations of the planar material fields used earlier in the chapter.
-/

namespace NumStability.Leveque02Tracer

/-- Longitudinal strain from a one-dimensional material location. -/
noncomputable def longitudinalStrain (X : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  deriv (fun ξ => X ξ t) x - 1

/-- Longitudinal material velocity from the same location. -/
noncomputable def longitudinalMaterialVelocity (X : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  deriv (fun τ => X x τ) t

end NumStability.Leveque02Tracer
