/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileMatrixEquationLocalTarget

/-!
# Local equivalence for a traveling profile
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.53) in both directions, using the reusable traveling-wave
chain rule and no global smoothness assumption. -/
theorem travelingProfileMatrixEquationLocal :
    travelingProfileMatrixEquationLocalTarget := by
  intro m _ coefficient profile profileDerivative speed x t hprofile
  have hderivatives := travelingWave_hasDerivAt_time_and_space speed x t hprofile
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    rw [ht.unique hderivatives.1, hx.unique hderivatives.2] at hresidual
    simpa [neg_smul] using eq_neg_of_add_eq_zero_right hresidual
  · intro hmatrix
    refine ⟨(-speed) • profileDerivative, profileDerivative,
      hderivatives.1, hderivatives.2, ?_⟩
    rw [hmatrix]
    simp [neg_smul]

end NumStability.Leveque02Tracer
