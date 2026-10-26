/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSelectedSolver
import Mathlib.Topology.Order.OrderClosed

/-!
# Forward signal cone and initial trace of the selected Burgers field

The actual shock/fan selection equals its endpoint states outside the
bounded forward cone. Hence its forward trace agrees with the Riemann data
at every point away from the initial jump.
-/

open Filter
open scoped Topology

namespace NumStability

/-- Every selected shock/fan state lies in the same bound as its two
endpoint states, also on the auxiliary backward extension. -/
theorem leveque04_burgersSelectedField_bounds
    (left right bound x t : ℝ)
    (hl : -bound ≤ left ∧ left ≤ bound) (hr : -bound ≤ right ∧ right ≤ bound) :
    -bound ≤ leveque04_burgersSelectedField left right x t ∧
      leveque04_burgersSelectedField left right x t ≤ bound := by
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate]
    split_ifs
    · simp only [travelingWave, riemannData]
      split_ifs <;> first | exact hl | exact hr
    · have h := leveque04_burgersRarefactionProfile_bounds left right (x / t) horder
      exact ⟨hl.1.trans h.1, h.2.trans hr.2⟩
  · simp only [leveque04_burgersSelectedField, if_neg horder, travelingWave, riemannData]
    split_ifs <;> first | exact hl | exact hr

/-- A bounded selected Burgers Riemann field is the left state strictly
to the left of its forward signal cone, including at the initial time. -/
theorem leveque04_burgersSelectedField_left_of_cone
    (left right bound x t : ℝ)
    (hl : -bound ≤ left ∧ left ≤ bound) (hr : -bound ≤ right ∧ right ≤ bound)
    (ht : 0 ≤ t) (hx : x < -bound * t) :
    leveque04_burgersSelectedField left right x t = left := by
  by_cases ht0 : t = 0
  · subst t
    rw [leveque04_burgersSelectedField_initial]
    simp [riemannData, show x < 0 by simpa using hx]
  have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm ht0)
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate, if_neg (not_le_of_gt htpos)]
    exact leveque04_burgersRarefactionForward_leftRegion left right x t horder htpos
      (hx.le.trans (mul_le_mul_of_nonneg_right hl.1 ht))
  · have hspeed : -bound ≤ (left + right) / 2 := by linarith [hl.1, hr.1]
    have hleft : x - (left + right) / 2 * t < 0 := by
      have h := mul_le_mul_of_nonneg_right hspeed ht
      linarith
    simp [leveque04_burgersSelectedField, horder, travelingWave, riemannData, hleft]

/-- The corresponding right state outside the bounded forward cone. -/
theorem leveque04_burgersSelectedField_right_of_cone
    (left right bound x t : ℝ)
    (hl : -bound ≤ left ∧ left ≤ bound) (hr : -bound ≤ right ∧ right ≤ bound)
    (ht : 0 ≤ t) (hx : bound * t < x) :
    leveque04_burgersSelectedField left right x t = right := by
  by_cases ht0 : t = 0
  · subst t
    rw [leveque04_burgersSelectedField_initial]
    simp [riemannData, show 0 < x by simpa using hx,
      show ¬ x < 0 by simpa using not_lt.mpr (le_of_lt hx)]
  have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm ht0)
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate, if_neg (not_le_of_gt htpos)]
    exact leveque04_burgersRarefactionForward_rightRegion left right x t horder htpos
      ((mul_le_mul_of_nonneg_right hr.2 ht).trans hx.le)
  · have hspeed : (left + right) / 2 ≤ bound := by linarith [hl.2, hr.2]
    have hright : 0 < x - (left + right) / 2 * t := by
      have h := mul_le_mul_of_nonneg_right hspeed ht
      linarith
    simp [leveque04_burgersSelectedField, horder, travelingWave, riemannData, hright,
      not_lt.mpr hright.le]

/-- At every nonjump point, the forward field eventually equals the
initial state exactly, rather than merely approaching it. -/
theorem leveque04_burgersSelectedField_eventually_initial
    (left right x : ℝ) (hx : x ≠ 0) :
    (fun t => leveque04_burgersSelectedField left right x t) =ᶠ[𝓝[>] (0 : ℝ)]
      (fun _ => riemannData left right right x) := by
  let B := max |left| |right|
  have hB : 0 ≤ B := (abs_nonneg left).trans (le_max_left _ _)
  have hl : -B ≤ left ∧ left ≤ B := abs_le.mp (le_max_left _ _)
  have hr : -B ≤ right ∧ right ≤ B := abs_le.mp (le_max_right _ _)
  have hden : 0 < B + 1 := by linarith
  have hsmall : ∀ᶠ t in 𝓝[>] (0 : ℝ), t < |x| / (B + 1) :=
    (eventually_lt_nhds (div_pos (abs_pos.mpr hx) hden)).filter_mono nhdsWithin_le_nhds
  filter_upwards [self_mem_nhdsWithin, hsmall] with t ht htsmall
  have htpos : 0 < t := ht
  have hscaled := (lt_div_iff₀ hden).mp htsmall
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · have hcone : x < -B * t := by rw [abs_of_neg hneg] at hscaled; nlinarith
    rw [leveque04_burgersSelectedField_left_of_cone left right B x t hl hr htpos.le hcone]
    simp [riemannData, hneg]
  · have hcone : B * t < x := by rw [abs_of_pos hpos] at hscaled; nlinarith
    rw [leveque04_burgersSelectedField_right_of_cone left right B x t hl hr htpos.le hcone]
    simp [riemannData, hpos, not_lt.mpr hpos.le]

/-- The forward initial trace is the prescribed Riemann state away
from the jump, whose chosen point value has no bearing on this limit. -/
theorem leveque04_burgersSelectedField_initialTrace
    (left right x : ℝ) (hx : x ≠ 0) :
    Tendsto (fun t => leveque04_burgersSelectedField left right x t)
      (𝓝[>] (0 : ℝ)) (𝓝 (riemannData left right right x)) := by
  exact tendsto_const_nhds.congr'
    (leveque04_burgersSelectedField_eventually_initial left right x hx).symm

end NumStability
