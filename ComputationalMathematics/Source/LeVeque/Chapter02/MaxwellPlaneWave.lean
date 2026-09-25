/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.116): selected transverse plane-wave fields
-/

namespace NumStability.Leveque02Tracer

/-- The vector ansatz has precisely the two stated nonzero component slots,
each depending only on the first spatial coordinate and time. -/
theorem maxwellPlaneWave : maxwellPlaneWaveTarget := by
  intro electricAmplitude magneticAmplitude electricField magneticInduction
  constructor
  · rintro ⟨rfl, rfl⟩ position time
    simp [maxwellPlaneElectric, maxwellPlaneMagnetic]
  · intro h
    constructor
    · funext position time component
      rcases h position time with ⟨hE0, hE1, hE2, _, _, _⟩
      fin_cases component
      · simpa [maxwellPlaneElectric] using hE0
      · simpa [maxwellPlaneElectric] using hE1
      · simpa [maxwellPlaneElectric] using hE2
    · funext position time component
      rcases h position time with ⟨_, _, _, hB0, hB1, hB2⟩
      fin_cases component
      · simpa [maxwellPlaneMagnetic] using hB0
      · simpa [maxwellPlaneMagnetic] using hB1
      · simpa [maxwellPlaneMagnetic] using hB2

end NumStability.Leveque02Tracer
