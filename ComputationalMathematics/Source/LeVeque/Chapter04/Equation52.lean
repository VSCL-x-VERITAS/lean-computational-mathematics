/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation5253Target
import ComputationalMathematics.Source.LeVeque.Chapter04.Equation37
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersPhysicalFluctuations
import Mathlib.Tactic.Ring

/-!
# Equation (4.52) for the actual physical Riemann fluxes

The negative fluctuations are the computed Burgers fan/shock contributions or
the actual scalar and eigenbasis waves. The physical traces and their time
averages reuse the verified model constructions of Equation (4.37).
-/

namespace NumStability

private theorem equation52_physical_burgers : Leveque04Equation52BurgersTarget := by
  intro left right
  have hfan := (leveque04_burgersFanShockContribution_eq_physical left right).1
  have hrule : leveque04_burgersPhysicalMinusFluctuation left right =
      (if left < 0 ∧ 0 < right then -(left ^ 2) / 2
       else min 0 ((left + right) / 2) * (right - left)) := by
    simpa only [apply_ite] using
      congrArg Prod.fst (leveque04_burgersPhysicalFluctuations_entropy_rule left right)
  have h37 := leveque04_equation37.1 left right
  refine ⟨hfan, hrule, ?_, h37.2.2.2.1, ?_⟩
  · intro time htime
    refine ⟨(h37.2.2.1 time htime).2, ?_⟩
    rw [hfan, leveque04_burgersPhysicalMinusFluctuation]
    ring
  · intro horder hstationary representative hrep
    have h := leveque04_burgersPhysicalFluctuations_stationary
      left right horder hstationary representative hrep
    exact ⟨h.1, hfan.trans h.2.1⟩

private theorem equation52_physical_scalarAffine :
    Leveque04Equation52ScalarAffineTarget := by
  intro a b left right representative _hrep
  dsimp only
  have hflux : (if a < 0 then a * right + b else a * left + b) =
      a * left + b + min a 0 * (right - left) := by
    by_cases ha : a < 0
    · rw [if_pos ha, min_eq_left ha.le]
      ring
    · rw [if_neg ha, min_eq_right (le_of_not_gt ha)]
      ring
  refine ⟨?_, hflux, ?_, ?_⟩
  · intro time htime
    simpa only [smul_eq_mul] using
      travelingRiemann_affineFlux_zeroRay a b left representative right htime
  · rw [hflux]
    ring
  · intro duration hduration
    exact scalarAffineRiemann_flux_timeAverage a b left representative right hduration

private theorem equation52_physical_linear : Leveque04Equation52LinearTarget := by
  intro m hm coefficient basis speeds heigen left right representative hrep
  dsimp only
  have h37 := leveque04_equation37.2.2 m hm coefficient basis speeds heigen
    left right representative hrep
  have hflux : leveque04_linearGodunovFlux coefficient basis speeds left right =
      coefficient.mulVec left + leveque04_negativeFluctuation speeds
        (leveque03_riemannWave basis left right) := by
    simpa only [leveque04_negativeFluctuation] using
      leveque04_equation49 coefficient basis speeds left right
  refine ⟨?_, hflux, ?_, leveque04_equation48 basis speeds left right, h37.2.2.2.2⟩
  · intro time htime
    exact (h37.2.2.2.1 time htime).2.1
  · rw [hflux]
    exact add_sub_cancel_left _ _

/-- The complete selected Equation (4.52): original left physical flux plus
the actual negative fluctuation, including interface traces and every positive
time average in the Burgers, scalar-affine and real-eigenbasis linear cases. -/
theorem leveque04_equation52_physical : Leveque04Equation52Target :=
  ⟨equation52_physical_burgers, equation52_physical_scalarAffine,
    equation52_physical_linear⟩

end NumStability
