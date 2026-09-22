/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengthsTarget

/-!
# Acoustic wave strengths
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.67): the two acoustic wave strengths. -/
theorem acousticWaveStrengthsFormula : acousticWaveStrengthsTarget := by
  intro density soundSpeed pressure velocity hImpedance
  have hne : acousticImpedance density soundSpeed ≠ 0 := ne_of_gt hImpedance
  funext i
  fin_cases i <;>
    simp [acousticWaveStrengths, linearAcousticsEigenvectorMatrixInverse,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;>
    field_simp

end NumStability.Leveque02Tracer
