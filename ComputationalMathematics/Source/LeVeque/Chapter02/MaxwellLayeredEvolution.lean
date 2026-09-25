/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellLayeredEvolutionTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.121): layered-medium plane-wave system
-/

namespace NumStability.Leveque02Tracer

/-- The layered-medium Maxwell residuals are equivalent to the two displayed
scalar equations, retaining the derivative of the full magnetic quotient. -/
theorem maxwellLayeredEvolution : maxwellLayeredEvolutionTarget := by
  intro ε μ e b position time hμ hEt hBt hquot hEx
  constructor
  · rintro ⟨hE, hB⟩
    constructor
    · have h := hE 1
      simpa [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
        maxwellPlaneElectric, maxwellPlaneMagnetic, deriv_const_mul_field] using h
    · have h := hB 2
      simpa [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
        maxwellPlaneElectric, maxwellPlaneMagnetic] using h
  · rintro ⟨hE, hB⟩
    constructor
    · intro component
      fin_cases component
      · simp [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
          maxwellPlaneElectric, maxwellPlaneMagnetic]
      · simpa [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
          maxwellPlaneElectric, maxwellPlaneMagnetic, deriv_const_mul_field] using hE
      · simp [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
          maxwellPlaneElectric, maxwellPlaneMagnetic]
    · intro component
      fin_cases component
      · simp [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
          maxwellPlaneElectric, maxwellPlaneMagnetic]
      · simp [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
          maxwellPlaneElectric, maxwellPlaneMagnetic]
      · simpa [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
          maxwellPlaneElectric, maxwellPlaneMagnetic] using hB

end NumStability.Leveque02Tracer
