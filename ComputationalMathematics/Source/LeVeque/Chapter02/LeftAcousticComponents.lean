/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LeftAcousticComponentsTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LeftAcousticWave

/-!
# Components of a pure left-going acoustic wave
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.61), by projecting the pure left-going vector wave in (2.60)
onto its pressure and velocity components. -/
theorem leftAcousticComponents : leftAcousticComponentsTarget := by
  intro q density soundSpeed hdensity hsoundSpeed hpure
  obtain ⟨profile, hq, _, _⟩ :=
    (leftAcousticWaveFormula q density soundSpeed hdensity hsoundSpeed).mp hpure
  refine ⟨profile, ?_⟩
  intro x t
  constructor
  · rw [hq]
    simp [eigenmodeTravelingWave, travelingWave,
      linearAcousticsLeftEigenvector, acousticImpedance, mul_comm]
  · rw [hq]
    simp [eigenmodeTravelingWave, travelingWave,
      linearAcousticsLeftEigenvector]

end NumStability.Leveque02Tracer
