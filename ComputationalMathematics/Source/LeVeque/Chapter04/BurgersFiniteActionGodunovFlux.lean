/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionComparisonFeet
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BurgersQuadraticInterfaceFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFlux

/-!
# Actual original-face physical flux under the full-step encountered-speed CFL

Every actual minimizing foot has the original two-state primitive value.
The two explicit outgoing comparison feet have their actual global action
values. Actual global optimality and the quadratic comparison lemma therefore
identify the SAME constructed evolution's physical flux with the original
Godunov zero-ray flux. No local solver is substituted for the global field;
stationary-shock ties have equal physical flux. Interactions elsewhere and
terminal Courant-one contact remain allowed.
-/

noncomputable section
open Set

namespace NumStability

private theorem corner_action_normalized (left right velocity time : ℝ) (ht : 0 < time) :
    left * (-velocity * time) + (right - left) * max (-velocity * time) 0 +
        (-velocity * time) ^ 2 / (2 * time) =
      time * (if 0 ≤ velocity then velocity ^ 2 / 2 - left * velocity
        else velocity ^ 2 / 2 - right * velocity) := by
  by_cases hu : 0 ≤ velocity
  · rw [if_pos hu, max_eq_right (mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hu) ht.le),
      mul_zero, add_zero]
    field_simp [ht.ne']
    ring
  · rw [if_neg hu, max_eq_left (mul_nonneg (neg_nonneg.mpr (le_of_not_ge hu)) ht.le)]
    field_simp [ht.ne']
    ring

/-- At every original face throughout0<t<T, actual physical flux is the
original two-state Godunov flux for EVERY fullstep S with S*T<=h. -/
theorem leveque04_burgersFiniteActionEvolution_CFL_face_flux {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) (htime : time ∈ Ioo (0 : ℝ) horizon) :
    leveque04_burgersFiniteActionEvolution old origin width
        (leveque04_burgersActionFace origin width j.val) time ^ 2 / 2 =
      leveque04_burgersSelectedInterfaceState
        (leveque04_burgersActionState old j.val) (leveque04_burgersActionState old (j.val + 1)) ^ 2 / 2 := by
  let a := leveque04_burgersActionFace origin width j.val
  let qL := leveque04_burgersActionState old j.val
  let qR := leveque04_burgersActionState old (j.val + 1)
  let foot := leveque04_burgersFiniteActionFoot old origin width a time
  let u := (a - foot) / time
  let B := if 0 ≤ u then u ^ 2 / 2 - qL * u else u ^ 2 / 2 - qR * u
  have hdisp : foot - a = -u * time := by
    dsimp [u]
    field_simp [htime.1.ne']
    ring
  have hp := leveque04_burgersFiniteAction_minimizer_CFL_primitive
    old origin width horizon bound time foot j hwidth hprop hCFL htime
    (leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width a time)
  have haction : leveque04_burgersAction old origin width a time foot =
      leveque04_burgersInitialPrimitive old origin width a + time * B := by
    unfold leveque04_burgersAction
    rw [hp]
    change leveque04_burgersInitialPrimitive old origin width a + qL * (foot - a) +
      (qR - qL) * max (foot - a) 0 + (a - foot) ^ 2 / (2 * time) = _
    rw [show (a - foot) ^ 2 = (foot - a) ^ 2 by ring, hdisp]
    have hn := corner_action_normalized qL qR u time htime.1
    dsimp [B]
    linear_combination hn
  have hc := leveque04_burgersFiniteAction_CFL_comparison_action_values
    old origin width horizon bound time j hwidth hprop hCFL htime
  have hleft := leveque04_burgersFiniteActionFoot_global_min old origin width a time hwidth.le htime.1
    (a - max 0 qL * time)
  have hright := leveque04_burgersFiniteActionFoot_global_min old origin width a time hwidth.le htime.1
    (a - min 0 qR * time)
  change leveque04_burgersAction old origin width a time foot ≤ _ at hleft hright
  rw [haction, hc.1] at hleft
  rw [haction, hc.2] at hright
  have hBL : B ≤ -(max 0 qL) ^ 2 / 2 := by
    by_contra hn
    have hm := mul_lt_mul_of_pos_left (lt_of_not_ge hn) htime.1
    nlinarith
  have hBR : B ≤ -(min 0 qR) ^ 2 / 2 := by
    by_contra hn
    have hm := mul_lt_mul_of_pos_left (lt_of_not_ge hn) htime.1
    nlinarith
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width _ time htime.1,
    leveque04_burgersFiniteActionVelocity]
  change u ^ 2 / 2 = leveque04_burgersSelectedInterfaceState qL qR ^ 2 / 2
  rw [leveque04_burgersSelectedInterfaceFlux_eq_max]
  exact burgers_zeroRayFlux_of_quadratic_comparisons qL qR u hBL hBR

end NumStability
