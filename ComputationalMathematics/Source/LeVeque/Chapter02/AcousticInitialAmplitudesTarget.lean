/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Acoustic initial wave amplitudes
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.64): evaluating the two-wave acoustic representation at the
initial time packages the two profile values as a column vector. -/
def acousticInitialAmplitudesTarget : Prop :=
  ∀ (density soundSpeed : ℝ) (pressure velocity : ℝ → ℝ → ℝ)
      (leftProfile rightProfile : ℝ → ℝ),
    (∀ x t,
      linearAcousticsState pressure velocity x t =
        leftProfile (x + soundSpeed * t) •
            linearAcousticsLeftEigenvector density soundSpeed +
          rightProfile (x - soundSpeed * t) •
            linearAcousticsRightEigenvector density soundSpeed) →
      ∀ x,
        (linearAcousticsEigenvectorMatrix density soundSpeed).mulVec
            ![leftProfile x, rightProfile x] =
          linearAcousticsState pressure velocity x 0

end NumStability.Leveque02Tracer
