/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellAmpereModel

/-!
# Transverse plane-wave polarization for the Maxwell fields

Only the `x` coordinate and time enter the scalar amplitudes. The electric
field points in the second Cartesian direction and the magnetic induction in
the third.
-/

namespace NumStability.Leveque02Tracer

/-- Electric field for the selected transverse polarization. -/
def maxwellPlaneElectric (amplitude : ℝ → ℝ → ℝ) : MaxwellField :=
  fun position time => ![0, amplitude (position 0) time, 0]

/-- Magnetic induction for the selected transverse polarization. -/
def maxwellPlaneMagnetic (amplitude : ℝ → ℝ → ℝ) : MaxwellField :=
  fun position time => ![0, 0, amplitude (position 0) time]

end NumStability.Leveque02Tracer
