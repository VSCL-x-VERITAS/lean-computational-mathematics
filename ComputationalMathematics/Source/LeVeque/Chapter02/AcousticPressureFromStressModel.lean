/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Acoustic pressure perturbation from elastic normal stress

The sign convention in LeVeque equation (2.96) identifies a compressive
(negative) normal stress with a positive acoustic pressure perturbation.
-/

namespace NumStability.Leveque02Tracer

/-- The acoustic pressure perturbation identified with normal elastic stress. -/
def acousticPressureFromNormalStress
    (normalStress : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  -normalStress x t

end NumStability.Leveque02Tracer
