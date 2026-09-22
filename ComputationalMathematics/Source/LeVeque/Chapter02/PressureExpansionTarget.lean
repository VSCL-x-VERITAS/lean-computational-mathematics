/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Comp

/-!
# First-order pressure expansion
-/

namespace NumStability.Leveque02Tracer

/-- The pressure expansion with ellipsis is represented by its exact first
variation along a density perturbation. -/
def pressureExpansionTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground pressureSlope densityPerturbation : ℝ),
    0 < densityBackground →
    HasDerivAt pressureLaw pressureSlope densityBackground →
    HasDerivAt
      (fun amplitude : ℝ =>
        pressureLaw (densityBackground + amplitude * densityPerturbation))
      (pressureSlope * densityPerturbation)
      0

end NumStability.Leveque02Tracer
