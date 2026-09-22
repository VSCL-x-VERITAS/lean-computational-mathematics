/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureExpansion
import ComputationalMathematics.Source.LeVeque.Chapter02.PressureLinearizationTarget

/-!
# Pressure perturbation first variation
-/

namespace NumStability.Leveque02Tracer

/-- The pressure perturbation relation reuses the accepted pressure first
variation rather than asserting a finite-perturbation equality. -/
theorem pressureLinearization : pressureLinearizationTarget := by
  exact pressureExpansion

end NumStability.Leveque02Tracer
