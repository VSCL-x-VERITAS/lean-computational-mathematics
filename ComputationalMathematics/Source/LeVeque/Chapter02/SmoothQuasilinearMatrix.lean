/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.QuasilinearMatrix
import ComputationalMathematics.Source.LeVeque.Chapter02.SmoothQuasilinearMatrixTarget

/-!
# The smooth positive-dimensional Jacobian form of a conservation law
-/

namespace NumStability.Leveque02Tracer

/-- The chain rule gives equation (2.41) throughout a smooth state. -/
theorem smoothQuasilinearMatrix : smoothQuasilinearMatrixTarget := by
  intro m _hm q flux derivative _hq x t qx hqx hflux
  exact quasilinearMatrix m q flux derivative x t qx hqx hflux

end NumStability.Leveque02Tracer
