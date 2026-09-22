/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulusModel

/-!
# Matrix form of convected linear acoustics
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.50) is the constant-matrix form of the two convected acoustic
equations (2.48) at a positive-density background state. -/
def convectedAcousticsMatrixTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (pressure velocity : ℝ → ℝ → ℝ)
      (pressureSlope densityBackground backgroundVelocity x t : ℝ),
    0 < densityBackground → HasDerivAt pressureLaw pressureSlope densityBackground →
      (IsConstantCoefficientLinearSystemSolutionAt
          (linearAcousticsState pressure velocity)
          (convectedLinearAcousticsMatrix
            (acousticBulkModulus pressureLaw densityBackground)
            densityBackground backgroundVelocity) x t ↔
        IsConvectedLinearAcousticsSolutionAt
          pressure velocity (acousticBulkModulus pressureLaw densityBackground)
          densityBackground backgroundVelocity x t)

end NumStability.Leveque02Tracer
