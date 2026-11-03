/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionInitialWavePositions

/-!
# Necessary initial speeds and directional states from the full-step bound

A sufficiently small positive time always exists within the same positive
horizon. The actual initial wave positions and physical S-cones then bound
both original fan-edge states, or the original shock mean. At any nonzero
jump this implies the directional inequalities -S <= q_left and q_right <= S.
Large constant states and stationary shocks are retained. These are necessary
consequences, not a replacement of the full-step encountered-wave bound by
initial speeds in the intended Godunov theorem.
-/

noncomputable section
open Set

namespace NumStability

private theorem exists_small_time (horizon width constant : ℝ)
    (hT : 0 < horizon) (hw : 0 < width) (hc : 0 ≤ constant) :
    ∃ time, time ∈ Ioc (0 : ℝ) horizon ∧ constant * time < width := by
  let time := min horizon (width / (constant + 1)) / 2
  have hd : 0 < constant + 1 := by linarith
  have hdiv : 0 < width / (constant + 1) := div_pos hw hd
  have ht : 0 < time := div_pos (lt_min hT hdiv) (by norm_num)
  have htT : time ≤ horizon := by
    have hm := min_le_left horizon (width / (constant + 1))
    dsimp [time]
    linarith
  have htdiv : time < width / (constant + 1) := by
    have hm := min_le_right horizon (width / (constant + 1))
    dsimp [time]
    linarith
  have hmul := (lt_div_iff₀ hd).mp htdiv
  exact ⟨time, ⟨ht, htT⟩, by nlinarith⟩

private theorem bound_from_position (x a q time bound : ℝ) (ht : 0 < time)
    (hpos : x = a + q * time) (hcone : |x - a| ≤ bound * time) : |q| ≤ bound := by
  have hm : |q| * time ≤ bound * time := by
    simpa only [hpos, add_sub_cancel_left, abs_mul, abs_of_pos ht] using hcone
  by_contra hn
  exact not_lt_of_ge hm (mul_lt_mul_of_pos_right (lt_of_not_ge hn) ht)

theorem leveque04_burgersFiniteActionPropagationBound_initial_wave_speeds {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (horizon_pos : 0 < horizon)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound) :
    (leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1) →
      |leveque04_burgersActionState old j.val| ≤ bound ∧
      |leveque04_burgersActionState old (j.val + 1)| ≤ bound) ∧
    (leveque04_burgersActionState old (j.val + 1) < leveque04_burgersActionState old j.val →
      |(leveque04_burgersActionState old j.val + leveque04_burgersActionState old (j.val + 1)) / 2| ≤ bound) := by
  obtain ⟨time, ht, hsmall⟩ := exists_small_time horizon width
    (leveque04_burgersPrimitiveBound old + bound) horizon_pos hwidth
    (add_nonneg (leveque04_burgersPrimitiveBound_nonneg old) hprop.1)
  constructor
  · intro horder
    have hp := leveque04_burgersFiniteAction_initial_ascending_edge_positions
      old origin width horizon bound time j hwidth horder hprop ht hsmall
    have hc := leveque04_burgersFiniteActionPropagationBound_label_cones
      old origin width horizon bound time j hwidth (ne_of_lt horder) hprop ⟨ht.1.le, ht.2⟩
    exact ⟨bound_from_position _ _ _ time bound ht.1 hp.1 hc.1,
      bound_from_position _ _ _ time bound ht.1 hp.2 hc.2⟩
  · intro horder
    have hp := leveque04_burgersFiniteAction_initial_descending_shock_position
      old origin width horizon bound time j hwidth horder hprop ht hsmall
    have hc := (leveque04_burgersFiniteActionPropagationBound_label_cones
      old origin width horizon bound time j hwidth (Ne.symm (ne_of_lt horder)) hprop ⟨ht.1.le, ht.2⟩).1
    exact bound_from_position _ _ _ time bound ht.1 hp hc

/-- These directional state bounds permit local comparison feet to pass
through arbitrary equal-state cells and either unbounded supplied tail. -/
theorem leveque04_burgersFiniteActionPropagationBound_initial_jump_directional_states {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (horizon_pos : 0 < horizon)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1)) :
    -bound ≤ leveque04_burgersActionState old j.val ∧
      leveque04_burgersActionState old (j.val + 1) ≤ bound := by
  have hs := leveque04_burgersFiniteActionPropagationBound_initial_wave_speeds
    old origin width horizon bound j hwidth horizon_pos hprop
  rcases lt_or_gt_of_ne hjump with horder | horder
  · have hb := hs.1 horder
    exact ⟨(abs_le.mp hb.1).1, (abs_le.mp hb.2).2⟩
  · have hb := abs_le.mp (hs.2 horder)
    constructor <;> linarith [hb.1, hb.2]

end NumStability
