/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianPSystemTarget

/-!
# LeVeque equation (2.107): the Lagrangian p-system
-/

namespace NumStability.Leveque02Tracer

/-- Substitute the local equation of state into the genuine pressure
derivative in the momentum law, retaining the mass equation. -/
theorem lagrangianPSystem : lagrangianPSystemTarget := by
  intro initialDensity referenceLocation particlePosition eulerianVelocity
    eulerianDensity lagrangianPressure pressureLaw label time
    _ _ _ _ _ _ _ _ _ hpressure hclosure hmass hmomentum
  have hcomposed :
      HasDerivAt
        (fun η => pressureLaw
          (lagrangianSpecificVolume eulerianDensity particlePosition η time))
        (deriv (fun η => pressureLaw
          (lagrangianSpecificVolume eulerianDensity particlePosition η time)) label) label := by
    rw [← hclosure.deriv_eq]
    exact hpressure.congr_of_eventuallyEq hclosure.symm
  refine ⟨hcomposed, hmass, ?_⟩
  rw [← hclosure.deriv_eq]
  exact hmomentum

end NumStability.Leveque02Tracer
