/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Ordered acoustic eigenvector matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.63): the first and second columns of `R` are the displayed
left- and right-going acoustic eigenvectors, respectively. -/
def acousticEigenvectorMatrixTarget : Prop :=
  ∀ (density soundSpeed : ℝ),
    (fun i => linearAcousticsEigenvectorMatrix density soundSpeed i 0) =
        linearAcousticsLeftEigenvector density soundSpeed ∧
      (fun i => linearAcousticsEigenvectorMatrix density soundSpeed i 1) =
        linearAcousticsRightEigenvector density soundSpeed

end NumStability.Leveque02Tracer
