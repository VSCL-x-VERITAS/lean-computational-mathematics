/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionEnvelopeDerivative

/-!
# Touching quadratic actions along a differentiable curve

Keep a true minimizing foot fixed while the observation moves. Its action is
smooth along a differentiable curve, regardless of initial corners or changes
of the selected minimizer. Fermat's theorem identifies the envelope derivative;
two distinct touching feet force the Rankine-Hugoniot mean velocity.
-/

open Set Filter
open scoped Topology

namespace NumStability

theorem quadraticActionEnvelope_curve_hasDerivAt
    (potential envelope curve : ℝ → ℝ) (time foot speed : ℝ) (htime : 0 < time)
    (hcurve : HasDerivAt curve speed time)
    (hmajor : ∀ s, 0 < s → envelope s ≤ potential foot + (curve s - foot) ^ 2 / (2 * s))
    (htouch : envelope time = potential foot + (curve time - foot) ^ 2 / (2 * time))
    (hdiff : DifferentiableAt ℝ envelope time) :
    HasDerivAt envelope
      (speed * ((curve time - foot) / time) - ((curve time - foot) / time) ^ 2 / 2) time := by
  have haction : HasDerivAt (fun s => potential foot + (curve s - foot) ^ 2 / (2 * s))
      (speed * ((curve time - foot) / time) - ((curve time - foot) / time) ^ 2 / 2) time := by
    convert (hasDerivAt_const time (potential foot)).add
      (((hcurve.sub_const foot).pow 2).div
        ((hasDerivAt_id time).const_mul 2) (by positivity : 2 * time ≠ 0)) using 1
    simp only [id_eq, Pi.pow_apply]
    field_simp [ne_of_gt htime]
    ring
  have hlocal : IsLocalMin
      (fun s => potential foot + (curve s - foot) ^ 2 / (2 * s) - envelope s) time := by
    filter_upwards [isOpen_Ioi.mem_nhds htime] with s hs
    change potential foot + (curve time - foot) ^ 2 / (2 * time) - envelope time ≤ _
    rw [htouch]
    linarith [hmajor s hs]
  have hzero := hlocal.hasDerivAt_eq_zero (haction.sub hdiff.hasDerivAt)
  convert hdiff.hasDerivAt using 1
  linarith

theorem quadraticActionEnvelope_curve_speed_of_distinct_touching_feet
    (potential envelope curve : ℝ → ℝ) (time y z speed : ℝ) (htime : 0 < time)
    (hcurve : HasDerivAt curve speed time) (hyz : y ≠ z)
    (hmajorY : ∀ s, 0 < s → envelope s ≤ potential y + (curve s - y) ^ 2 / (2 * s))
    (hmajorZ : ∀ s, 0 < s → envelope s ≤ potential z + (curve s - z) ^ 2 / (2 * s))
    (htouchY : envelope time = potential y + (curve time - y) ^ 2 / (2 * time))
    (htouchZ : envelope time = potential z + (curve time - z) ^ 2 / (2 * time))
    (hdiff : DifferentiableAt ℝ envelope time) :
    speed = (((curve time - y) / time) + ((curve time - z) / time)) / 2 := by
  have hY := quadraticActionEnvelope_curve_hasDerivAt potential envelope curve time y speed
    htime hcurve hmajorY htouchY hdiff
  have hZ := quadraticActionEnvelope_curve_hasDerivAt potential envelope curve time z speed
    htime hcurve hmajorZ htouchZ hdiff
  let u := (curve time - y) / time
  let v := (curve time - z) / time
  have hneq : u ≠ v := by
    intro heq
    have hmul := congrArg (fun r : ℝ => r * time) heq
    dsimp [u, v] at hmul
    simp only [div_mul_cancel₀ _ (ne_of_gt htime)] at hmul
    exact hyz (by linarith)
  have hid : speed * u - u ^ 2 / 2 = speed * v - v ^ 2 / 2 := hY.unique hZ
  have hprod : (u - v) * (2 * speed - u - v) = 0 := by nlinarith
  have heq := (mul_eq_zero.mp hprod).resolve_left (sub_ne_zero.mpr hneq)
  dsimp [u, v] at heq
  linarith

end NumStability
