/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.GenericPSystemNotationTarget

/-!
# LeVeque equation (2.108): generic lower-case p-system notation
-/

namespace NumStability.Leveque02Tracer

/-- The existential derivative witnesses in the generic p-system are
uniquely the ordinary partial derivatives in the printed equations. -/
theorem genericPSystemNotation : genericPSystemNotationTarget := by
  intro specificVolume velocity pressureLaw massCoordinate time
  constructor
  · rintro ⟨volumeTime, velocitySpace, velocityTime, pressureSpace,
      hvolume, hvelocitySpace, hvelocityTime, hpressureSpace, hmass, hmomentum⟩
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
    · simpa only [hvolume.deriv] using hvolume
    · simpa only [hvelocitySpace.deriv] using hvelocitySpace
    · simpa only [hvelocityTime.deriv] using hvelocityTime
    · simpa only [hpressureSpace.deriv] using hpressureSpace
    · rw [hvolume.deriv, hvelocitySpace.deriv]
      exact hmass
    · rw [hvelocityTime.deriv, hpressureSpace.deriv]
      exact hmomentum
  · rintro ⟨hvolume, hvelocitySpace, hvelocityTime, hpressureSpace, hmass, hmomentum⟩
    exact ⟨_, _, _, _, hvolume, hvelocitySpace, hvelocityTime,
      hpressureSpace, hmass, hmomentum⟩

end NumStability.Leveque02Tracer
