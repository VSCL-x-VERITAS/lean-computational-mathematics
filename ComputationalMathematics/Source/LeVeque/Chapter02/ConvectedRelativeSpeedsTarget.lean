/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsEigenvaluesTarget

/-!
# LeVeque Chapter 2: ConvectedRelativeSpeedsTarget

Target for observer-relative acoustic characteristic speeds.
-/

namespace NumStability.Leveque02Tracer

def convectedRelativeSpeedsTarget : Prop :=
  ∀ (bulkModulus density backgroundVelocity : ℝ),
    0 < bulkModulus → 0 < density →
      let soundSpeed := Real.sqrt (bulkModulus / density)
      Module.End.HasEigenvalue
        (Matrix.toLin' (convectedLinearAcousticsMatrix
          bulkModulus density backgroundVelocity))
        (backgroundVelocity - soundSpeed) ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (convectedLinearAcousticsMatrix
          bulkModulus density backgroundVelocity))
        (backgroundVelocity + soundSpeed) ∧
      (backgroundVelocity - soundSpeed) - backgroundVelocity = -soundSpeed ∧
      (backgroundVelocity + soundSpeed) - backgroundVelocity = soundSpeed

end NumStability.Leveque02Tracer
