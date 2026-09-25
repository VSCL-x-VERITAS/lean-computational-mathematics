/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveEvolutionTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.117): scalar Maxwell plane-wave system
-/

namespace NumStability.Leveque02Tracer

/-- The constant-medium vector equations for the selected transverse fields
reduce exactly to the two displayed scalar evolution equations. -/
theorem maxwellPlaneWaveEvolution : maxwellPlaneWaveEvolutionTarget := by
  intro ε μ e b position time hε hμ hEt hBt hEx hBx
  constructor
  · rintro ⟨hE, hB⟩
    constructor
    · have h := hE 1
      simpa [maxwellTimePartial, maxwellSpatialPartial, maxwellCurl,
        maxwellPlaneElectric, maxwellPlaneMagnetic] using h
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
          maxwellPlaneElectric, maxwellPlaneMagnetic] using hE
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
