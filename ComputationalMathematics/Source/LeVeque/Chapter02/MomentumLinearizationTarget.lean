/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# First variation of momentum
-/

namespace NumStability.Leveque02Tracer

/-- The source's approximate momentum perturbation is the exact derivative at
zero perturbation amplitude. -/
def momentumLinearizationTarget : Prop :=
  ∀ (densityBackground velocityBackground densityPerturbation velocityPerturbation : ℝ),
    HasDerivAt
      (fun amplitude : ℝ =>
        (densityBackground + amplitude * densityPerturbation) *
          (velocityBackground + amplitude * velocityPerturbation))
      (velocityBackground * densityPerturbation +
        densityBackground * velocityPerturbation)
      0

end NumStability.Leveque02Tracer
