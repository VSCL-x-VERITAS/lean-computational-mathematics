/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulus

/-!
# Sound speed from the pressure-law derivative
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.56), obtained by substituting the bulk-modulus identity (2.49)
into the sound-speed formula (2.55). -/
def pressureSoundSpeedTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ)
      (densityBackground pressureSlope soundSpeed : ℝ),
    0 < densityBackground → 0 < pressureSlope →
      HasDerivAt pressureLaw pressureSlope densityBackground →
        soundSpeed = Real.sqrt
          (acousticBulkModulus pressureLaw densityBackground /
            densityBackground) →
          soundSpeed = Real.sqrt pressureSlope

end NumStability.Leveque02Tracer
