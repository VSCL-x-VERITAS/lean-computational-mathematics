/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.TensorAdjointMatrixTarget

namespace NumStability.Bhatia.Chapter01

/-- Bhatia I.4: the adjoint of a tensor product in fixed orthonormal matrix coordinates. -/
theorem tensorAdjointInCoordinates : Targets.tensorAdjointInCoordinates := by
  intro n A B
  exact Matrix.conjTranspose_kronecker A B

end NumStability.Bhatia.Chapter01
