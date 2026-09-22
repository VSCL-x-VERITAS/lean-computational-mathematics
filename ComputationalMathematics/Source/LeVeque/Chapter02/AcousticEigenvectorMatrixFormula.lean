/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticEigenvectorMatrixFormulaTarget

/-!
# Explicit acoustic eigenvector matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.65): the acoustic eigenvector matrix in terms of impedance. -/
theorem acousticEigenvectorMatrixFormula : acousticEigenvectorMatrixFormulaTarget := by
  intro density soundSpeed
  simp [linearAcousticsEigenvectorMatrix, acousticImpedance]

end NumStability.Leveque02Tracer
