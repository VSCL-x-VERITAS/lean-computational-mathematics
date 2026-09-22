/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileMatrixEquationTarget

/-!
# Matrix equation for a travelling profile
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.53) follows by identifying the system derivative witnesses with
the chain-rule derivatives of the travelling profile. -/
theorem travelingProfileMatrixEquation : travelingProfileMatrixEquationTarget := by
  intro m _ coefficient profile profileDerivative speed x t _ hprofile hsystem
  rcases travelingWave_hasDerivAt_time_and_space speed x t hprofile with
    ⟨htime, hspace⟩
  rcases hsystem with ⟨qt, qx, ht, hx, hresidual⟩
  rw [ht.unique htime, hx.unique hspace] at hresidual
  simpa [neg_smul] using eq_neg_of_add_eq_zero_right hresidual

end NumStability.Leveque02Tracer
