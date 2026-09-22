/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureExpansionTarget

/-!
# Linearized pressure perturbation
-/

namespace NumStability.Leveque02Tracer

/-- The source relation `p̃ ≈ P'(ρ0)ρ̃` is the pressure law's first
variation along the density-perturbation direction. -/
def pressureLinearizationTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground pressureSlope densityPerturbation : ℝ),
    0 < densityBackground →
    HasDerivAt pressureLaw pressureSlope densityBackground →
    HasDerivAt
      (fun amplitude : ℝ =>
        pressureLaw (densityBackground + amplitude * densityPerturbation))
      (pressureSlope * densityPerturbation)
      0

end NumStability.Leveque02Tracer
