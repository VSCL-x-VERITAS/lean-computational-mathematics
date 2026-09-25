/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticPressureStressIdentificationTarget

/-!
# LeVeque equation (2.96): the pressure/stress sign convention
-/

namespace NumStability.Leveque02Tracer

/-- The acoustic pressure identified with normal elastic stress has the
opposite sign, including the compressive-stress sign criterion. -/
theorem acousticPressureStressIdentification :
    acousticPressureStressIdentificationTarget := by
  intro normalStress x t
  simp [acousticPressureFromNormalStress]

end NumStability.Leveque02Tracer
