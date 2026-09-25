/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation07
import ComputationalMathematics.Source.LeVeque.Chapter02.Equation76PressureWaveTarget

/-!
# LeVeque Chapter 2, Equation (2.76): acoustic pressure wave equation

The Chapter 1 pressure-wave result supplies this restated equation under the
same explicit classical derivative assumptions.
-/

namespace NumStability.Leveque02Tracer

/-- The stationary acoustic solution satisfies the scalar pressure wave
equation displayed as (2.76). -/
theorem equation76PressureWave : equation76PressureWaveTarget := by
  intro bulkModulus density system hbulkModulus hdensity x t ptt pxx uxt utx
    hptt huxt hutx hpxx hmixed
  exact leveque01_equation07_pressureWave system hbulkModulus hdensity
    x t ptt pxx uxt utx hptt huxt hutx hpxx hmixed

end NumStability.Leveque02Tracer
