/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation5253Target
import ComputationalMathematics.Source.LeVeque.Chapter04.Equation37
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersPhysicalFluctuations
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Abel

/-!
# Equation (4.53) for the actual physical Riemann fluxes

The right-going fluctuations are the computed Burgers fan/shock contributions
or actual scalar and eigenbasis waves. Their subtraction from the original
right physical flux gives the selected interface flux and its time average.
-/

namespace NumStability

private theorem equation53_physical_burgers : Leveque04Equation53BurgersTarget := by
  intro left right
  have hfan := (leveque04_burgersFanShockContribution_eq_physical left right).2
  have hrule : leveque04_burgersPhysicalPlusFluctuation left right =
      (if left < 0 ∧ 0 < right then right ^ 2 / 2
       else max 0 ((left + right) / 2) * (right - left)) := by
    simpa only [apply_ite] using
      congrArg Prod.snd (leveque04_burgersPhysicalFluctuations_entropy_rule left right)
  have h37 := leveque04_equation37.1 left right
  refine ⟨hfan, hrule, ?_, h37.2.2.2.1, ?_⟩
  · intro time htime
    refine ⟨(h37.2.2.1 time htime).2, ?_⟩
    rw [hfan, leveque04_burgersPhysicalPlusFluctuation]
    ring
  · intro horder hstationary representative hrep
    have h := leveque04_burgersPhysicalFluctuations_stationary
      left right horder hstationary representative hrep
    exact ⟨h.1, hfan.trans h.2.2⟩

private theorem equation53_physical_scalarAffine :
    Leveque04Equation53ScalarAffineTarget := by
  intro a b left right representative _hrep
  dsimp only
  have hflux : (if a < 0 then a * right + b else a * left + b) =
      a * right + b - max a 0 * (right - left) := by
    by_cases ha : a < 0
    · rw [if_pos ha, max_eq_right ha.le]
      ring
    · rw [if_neg ha, max_eq_left (le_of_not_gt ha)]
      ring
  refine ⟨?_, hflux, ?_, ?_⟩
  · intro time htime
    simpa only [smul_eq_mul] using
      travelingRiemann_affineFlux_zeroRay a b left representative right htime
  · rw [hflux]
    ring
  · intro duration hduration
    exact scalarAffineRiemann_flux_timeAverage a b left representative right hduration

private theorem equation53_physical_linear : Leveque04Equation53LinearTarget := by
  intro m hm coefficient basis speeds heigen left right representative hrep
  dsimp only
  have h37 := leveque04_equation37.2.2 m hm coefficient basis speeds heigen
    left right representative hrep
  have hright := leveque04_linearRiemannRightTraceFlux coefficient basis speeds
    heigen left right
  have hrightCommon := (leveque04_equation37.2.2 m hm coefficient basis speeds
    heigen left right right (Or.inr rfl)).2.2.2.1 1 zero_lt_one
  have hflux : leveque04_linearGodunovFlux coefficient basis speeds left right =
      coefficient.mulVec right - leveque04_positiveFluctuation speeds
        (leveque03_riemannWave basis left right) := by
    simpa only [leveque04_positiveFluctuation] using hrightCommon.2.1.symm.trans hright
  refine ⟨?_, hflux, ?_, leveque04_equation47 basis speeds left right, h37.2.2.2.2⟩
  · intro time htime
    exact (h37.2.2.2.1 time htime).2.1
  · rw [hflux]
    abel

/-- The complete selected Equation (4.53), including actual positive
fluctuations, physical traces and every positive-duration average in all three
prescribed model applications. -/
theorem leveque04_equation53_physical : Leveque04Equation53Target :=
  ⟨equation53_physical_burgers, equation53_physical_scalarAffine,
    equation53_physical_linear⟩

end NumStability
