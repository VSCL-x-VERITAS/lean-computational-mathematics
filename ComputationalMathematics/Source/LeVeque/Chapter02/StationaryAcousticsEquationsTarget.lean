/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulusModel

/-!
# Stationary pressure--velocity acoustics equations
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.52) identifies the zero-background-velocity component equations
with the standard stationary linear-acoustics predicate. -/
def stationaryAcousticsEquationsTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (pressure velocity : ℝ → ℝ → ℝ)
      (densityBackground pressureSlope x t : ℝ),
    0 < densityBackground → 0 < pressureSlope →
      HasDerivAt pressureLaw pressureSlope densityBackground →
        (IsConvectedLinearAcousticsSolutionAt pressure velocity
            (acousticBulkModulus pressureLaw densityBackground)
            densityBackground 0 x t ↔
          IsLinearAcousticsSolutionAt pressure velocity
            (acousticBulkModulus pressureLaw densityBackground)
            densityBackground x t)

end NumStability.Leveque02Tracer
