/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveModel

/-!
# Proof-free target for LeVeque equation (2.116)

Lean indices `0,1,2` correspond to the printed spatial directions `1,2,3`.
-/

namespace NumStability.Leveque02Tracer

/-- The selected transverse plane-wave vector ansatz is exactly its six
component equations, globally over three-dimensional position and time. -/
def maxwellPlaneWaveTarget : Prop :=
  ∀ (electricAmplitude magneticAmplitude : ℝ → ℝ → ℝ)
    (electricField magneticInduction : MaxwellField),
    (electricField = maxwellPlaneElectric electricAmplitude ∧
      magneticInduction = maxwellPlaneMagnetic magneticAmplitude) ↔
    (∀ position time,
      electricField position time 0 = 0 ∧
      electricField position time 1 = electricAmplitude (position 0) time ∧
      electricField position time 2 = 0 ∧
      magneticInduction position time 0 = 0 ∧
      magneticInduction position time 1 = 0 ∧
      magneticInduction position time 2 = magneticAmplitude (position 0) time)

end NumStability.Leveque02Tracer
