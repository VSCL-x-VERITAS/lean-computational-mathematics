/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticsMatrixTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobian

/-!
# The constant acoustics matrix
-/

namespace NumStability.Leveque02Tracer

/-- Evaluating the gas-flux Jacobian at the background gives equation (2.46). -/
theorem acousticsMatrix : acousticsMatrixTarget := by
  intro pressureLaw densityBackground velocityBackground pressureSlope hdensity hpressure
  obtain ⟨hphysical, derivative, hderivative, hmatrix⟩ :=
    fluidJacobian pressureLaw densityBackground velocityBackground pressureSlope hdensity hpressure
  exact ⟨derivative, hderivative, hmatrix.trans hphysical⟩

end NumStability.Leveque02Tracer
