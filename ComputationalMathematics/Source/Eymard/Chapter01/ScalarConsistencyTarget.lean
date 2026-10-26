/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.FluxConsistency

/-!
# A scalar consistent numerical flux

The modified Lax–Friedrichs formula in (21.7), with `D = alpha / 2`, supplies
the two-state consistency condition (21.5). Only its diagonal identity is
selected here; the interval-restricted monotonicity conditions are separate.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume

/-- The explicit constant-coefficient flux satisfies diagonal consistency. -/
def scalarConsistencyTarget : Prop :=
  ∀ (physicalFlux : ℝ → ℝ) (alpha : ℝ), 0 ≤ alpha →
    IsScalarFluxConsistent physicalFlux
      (fun a b : ℝ =>
        (physicalFlux a + physicalFlux b) / 2 - alpha * (b - a) / 2)

end NumStability.Eymard.Chapter01
