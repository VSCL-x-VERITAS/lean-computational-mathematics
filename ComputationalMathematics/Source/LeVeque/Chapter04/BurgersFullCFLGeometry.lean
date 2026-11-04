/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFiniteChain

/-!
# Sharp adjacent Burgers wave separation

The characteristic bound on all states gives an adjacent wave-speed spread
of at most that bound, rather than twice the bound. Actual shocks retain
their selected right representative. This is a characteristic-state CFL
result; a smaller bound on active shock-front speeds is a different condition.
-/

namespace NumStability

/-- The left edge speed of the actual selected Burgers fan or shock. -/
noncomputable def leveque04_burgersLeftWaveSpeed (left right : ℝ) : ℝ :=
  if left ≤ right then left else (left + right) / 2

/-- The right edge speed of the actual selected Burgers fan or shock. -/
noncomputable def leveque04_burgersRightWaveSpeed (left right : ℝ) : ℝ :=
  if left ≤ right then right else (left + right) / 2

theorem leveque04_burgers_waveSpeeds_ordered (left right : ℝ) :
    leveque04_burgersLeftWaveSpeed left right ≤
      leveque04_burgersRightWaveSpeed left right := by
  unfold leveque04_burgersLeftWaveSpeed leveque04_burgersRightWaveSpeed
  split_ifs with h
  · exact h
  · exact le_rfl

/-- Adjacent scalar entropy waves share the middle state. Their separating
speed difference is bounded by one characteristic-state bound. -/
theorem leveque04_burgers_adjacentWaveSpread_le
    (a b c bound : ℝ) (ha : |a| ≤ bound) (hb : |b| ≤ bound) (hc : |c| ≤ bound) :
    leveque04_burgersRightWaveSpeed a b -
      leveque04_burgersLeftWaveSpeed b c ≤ bound := by
  have ha' := abs_le.mp ha
  have hb' := abs_le.mp hb
  have hc' := abs_le.mp hc
  unfold leveque04_burgersLeftWaveSpeed leveque04_burgersRightWaveSpeed
  split_ifs <;> linarith

/-- A strict left tail, including the initial Riemann jump convention. -/
theorem leveque04_burgersSelectedField_left_of_waveSpeed
    (left right x time : ℝ) (htime : 0 ≤ time)
    (hx : x < leveque04_burgersLeftWaveSpeed left right * time) :
    leveque04_burgersSelectedField left right x time = left := by
  by_cases ht0 : time = 0
  · subst time
    rw [leveque04_burgersSelectedField_initial]
    simp only [mul_zero] at hx
    simp [riemannData, hx]
  have htpos : 0 < time := lt_of_le_of_ne htime (Ne.symm ht0)
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersLeftWaveSpeed, if_pos horder] at hx
    simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate, if_neg (not_le_of_gt htpos)]
    exact leveque04_burgersRarefactionForward_leftRegion left right x time horder htpos hx.le
  · simp only [leveque04_burgersLeftWaveSpeed, if_neg horder] at hx
    simp [leveque04_burgersSelectedField, horder, travelingWave, riemannData,
      sub_neg.mpr hx]

/-- The right tail is closed: the selected shock uses its right value. -/
theorem leveque04_burgersSelectedField_right_of_waveSpeed
    (left right x time : ℝ) (htime : 0 ≤ time)
    (hx : leveque04_burgersRightWaveSpeed left right * time ≤ x) :
    leveque04_burgersSelectedField left right x time = right := by
  by_cases ht0 : time = 0
  · subst time
    rw [leveque04_burgersSelectedField_initial]
    simp only [mul_zero] at hx
    simp [riemannData, not_lt.mpr hx]
  have htpos : 0 < time := lt_of_le_of_ne htime (Ne.symm ht0)
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersRightWaveSpeed, if_pos horder] at hx
    simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate, if_neg (not_le_of_gt htpos)]
    exact leveque04_burgersRarefactionForward_rightRegion left right x time horder htpos hx
  · simp only [leveque04_burgersRightWaveSpeed, if_neg horder] at hx
    simp [leveque04_burgersSelectedField, horder, travelingWave, riemannData,
      not_lt.mpr (sub_nonneg.mpr hx)]

/-- At positive time the extreme negative characteristic boundary is also
left-constant. Equality of a shock speed with this extreme would force equal
endpoint states, so no discontinuous left-boundary exception is hidden. -/
theorem leveque04_burgersSelectedField_left_of_closed_characteristic_cone
    (left right bound x time : ℝ)
    (hl : -bound ≤ left ∧ left ≤ bound) (hr : -bound ≤ right ∧ right ≤ bound)
    (htime : 0 < time) (hx : x ≤ -bound * time) :
    leveque04_burgersSelectedField left right x time = left := by
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate, if_neg (not_le_of_gt htime)]
    exact leveque04_burgersRarefactionForward_leftRegion left right x time horder htime
      (hx.trans (mul_le_mul_of_nonneg_right hl.1 htime.le))
  · have hspeed : -bound < (left + right) / 2 := by
      have : right < left := lt_of_not_ge horder
      linarith [hl.1, hr.1]
    apply leveque04_burgersSelectedField_left_of_waveSpeed left right x time htime.le
    simp only [leveque04_burgersLeftWaveSpeed, if_neg horder]
    exact hx.trans_lt (mul_lt_mul_of_pos_right hspeed htime)

end NumStability
