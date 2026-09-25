/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveMatrixTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.118): transverse Maxwell coefficient matrix
-/

namespace NumStability.Leveque02Tracer

/-- The printed matrix and its action on the ordered electric/magnetic state. -/
theorem maxwellPlaneWaveMatrix : maxwellPlaneWaveMatrixTarget := by
  intro ε μ hε hμ
  constructor
  · rfl
  · intro spatialDerivative
    funext component
    fin_cases component <;>
      simp [maxwellPlaneWaveCoefficient, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two]

end NumStability.Leveque02Tracer
