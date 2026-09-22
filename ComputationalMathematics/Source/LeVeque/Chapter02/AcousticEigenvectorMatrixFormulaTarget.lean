/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Explicit acoustic eigenvector matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.65): the acoustic eigenvector matrix written in terms of the
acoustic impedance. -/
def acousticEigenvectorMatrixFormulaTarget : Prop :=
  ∀ (density soundSpeed : ℝ),
    linearAcousticsEigenvectorMatrix density soundSpeed =
      !![-acousticImpedance density soundSpeed,
          acousticImpedance density soundSpeed; 1, 1]

end NumStability.Leveque02Tracer
