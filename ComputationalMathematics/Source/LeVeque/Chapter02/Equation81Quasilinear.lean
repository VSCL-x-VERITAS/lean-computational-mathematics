/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Equation81QuasilinearTarget

/-!
# LeVeque Chapter 2, Equation (2.81): quasilinear system
-/

namespace NumStability.Leveque02Tracer

/-- The generic first-order equation object realizes the displayed
quasilinear residual and its pointwise hyperbolicity criterion. -/
theorem equation81Quasilinear : equation81QuasilinearTarget := by
  intro ι _ coefficient state x t
  constructor
  · rfl
  · intro q
    simp [equation81System, FirstOrderEquation.IsClassicalSolutionAt,
      FirstOrderEquation.residual]

end NumStability.Leveque02Tracer
