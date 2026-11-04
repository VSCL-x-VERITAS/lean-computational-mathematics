/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsFirstOrderTarget

/-!
# Formal first-order accuracy of Lax–Friedrichs

The general smooth-reference local estimate, scalar leading term and exact
quadratic example are distinct from the derived global linear-system result.
The latter uses an actual characteristic Cauchy field, its genuine physical
cell averages and the conservative numerical operator under modewise CFL.
-/

namespace NumStability

/-- Chapter4's formal smooth-solution first-order claim, together with the
explicit fixed-data linear Cauchy global consequence in the reviewed target. -/
theorem leveque04_laxFriedrichs_firstOrder :
    leveque04_laxFriedrichs_firstOrder_target := by
  unfold leveque04_laxFriedrichs_firstOrder_target
  refine ⟨leveque04_laxFriedrichs_c2RectangleReference_closedTimeRegionalResidual,
    leveque04_laxFriedrichs_unrestrictedSmoothAdvectionLeadingResidual, ?_, ?_⟩
  · intro speed ratio width i hratio hwidth _hcfl
    exact leveque04_laxFriedrichs_quadraticAdvectionResidual
      speed ratio width i hratio hwidth
  · intro m _ coefficient basis speeds heigen profile ratio horizon
      hratio hhorizon hcfl hsmooth hcompact
    dsimp only
    refine ⟨fun x => linearCharacteristicEvolution_initial basis speeds _ x, ?_, ?_⟩
    · apply linearCharacteristicEvolution_isRectangleSolution coefficient basis speeds heigen
      intro p a b
      simpa only [LinearEquiv.apply_symm_apply] using
        (hsmooth p).continuous.intervalIntegrable a b
    · exact leveque04_linearLaxFriedrichs_compactC2Cauchy_firstOrder
        coefficient basis speeds heigen profile ratio horizon
        hratio hhorizon hcfl hsmooth hcompact

end NumStability
