/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovCourantExtensionTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionIntrinsicWaves
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionGodunovAverages

/-!
# The Courant extension for the finite Burgers evolution

The intrinsic encountered-wave bound gives the propagation premise for the
same fixed finite-action field. Its physical face-flux and cell-average
identities then give the full conditional Courant extension.
-/

namespace NumStability

theorem leveque04_godunovCourantExtension : Leveque04GodunovCourantExtensionTarget := by
  unfold Leveque04GodunovCourantExtensionTarget
  intro N _hN old origin width hwidth
  dsimp only
  intro horizon bound horizon_pos _hbound hintrinsic hCFL
  have hprop := (leveque04_burgersFiniteActionPropagationBound_iff_intrinsic
    old origin width horizon bound hwidth).mpr hintrinsic
  constructor
  · intro j
    exact ⟨(leveque04_burgersFiniteActionEvolution_CFL_face_flux_integral
      old origin width horizon bound j hwidth horizon_pos hprop hCFL).1,
      leveque04_burgersFiniteActionEvolution_CFL_face_timeAverage
        old origin width horizon bound j hwidth horizon_pos hprop hCFL⟩
  · intro cell
    exact leveque04_burgersFiniteActionEvolution_CFL_cell_average
      old origin width horizon bound cell hwidth horizon_pos hprop hCFL

end NumStability
