/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# One-dimensional linear elastic normal-stress model

The constitutive law is a model assumption: normal stress is selected as a
linear function of extensional strain. The law is not derived from kinematics.
-/

namespace NumStability.Leveque02Tracer

/-- Normal stress specified by the one-dimensional linear elastic law. -/
noncomputable def planeNormalStress
    (lameLambda shearModulus : ℝ) (extensionStrain : ℝ → ℝ → ℝ)
    (x t : ℝ) : ℝ :=
  (lameLambda + 2 * shearModulus) * extensionStrain x t

end NumStability.Leveque02Tracer
